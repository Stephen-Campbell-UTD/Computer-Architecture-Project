`define MULTICYCLE

`ifndef IMPL
`include "./opcodes.v"
`endif

`include "../components/Control/ControlStates.v"

`include "../components/RAM/RAM.v"
`include "../components/Control/Control.v"
`include "../components/Misc Registers/GeneralRegister.v"
`include "../components/Register Track Selector/RegisterTrackSelector.v"
`include "../components/Control Decode/ControlDecode.v"
`include "../components/Muxes/Mux4.v"
`include "../components/Muxes/Mux2.v"
`include "../components/Register File/RegisterFile.v"
`include "../components/Sign Extender/SignExtender.v"
`include "../components/Left Shift/LeftShift.v"
`include "../components/ALU/ALU.v"

module Multicycle (
    input clk,
    input reset,
    input [10:0] debugAddress,
    output [7:0] debugMemOut,
    output [3:0] controlState
);

  //must keep consistent with ID
  parameter INSTRUCTION_SIZE = 20;
  parameter OP_SIZE = 6;
  parameter REG_ADDRESS_SIZE = 2;
  parameter SMALL_IMMEDIATE_SIZE = 10;
  parameter BIG_IMMEDIATE_SIZE = 12;
  parameter JUMP_ADDRESS_SIZE = 9;  //left shifted twice
  parameter OP_LSB = INSTRUCTION_SIZE - OP_SIZE;
  parameter REG_MSB = OP_LSB - 1;

  //additional params
  parameter ADDRESS_SIZE = 11;
  parameter WORD_SIZE = 64;
  parameter [ADDRESS_SIZE-1:0] PC_START = 0;

  wire [WORD_SIZE-1:0] pc_aluSrcA;
  wire [ADDRESS_SIZE-1:0] pc_memGetDataMux;

  wire [INSTRUCTION_SIZE-1:0] mem_ir;
  wire [WORD_SIZE-1:0] mem_mdr;

  wire [OP_SIZE-1:0] ir_control;  //for opcode
  wire [ADDRESS_SIZE-1:0] ir_leftShiftAddress;
  wire [REG_ADDRESS_SIZE-1:0] ir_regTSAlpha;
  wire [REG_ADDRESS_SIZE-1:0] ir_regTSBeta;
  wire [REG_ADDRESS_SIZE-1:0] ir_regTSGamma;
  wire [BIG_IMMEDIATE_SIZE-1:0] ir_signExtendBig;
  wire [SMALL_IMMEDIATE_SIZE-1:0] ir_signExtendOffset;

  wire [WORD_SIZE-1:0] mdr_regWriteDataMux;

  wire [WORD_SIZE-1:0] signExtendOffset_aluSrcBMux;
  wire [WORD_SIZE-1:0] signExtendOffset_leftShiftOffset;

  wire [WORD_SIZE-1:0] regBusA_aluSrcAMux;

  wire [WORD_SIZE-1:0] regBusB_aluSrcBMux;
  wire [WORD_SIZE-1:0] regBusB_memData;

  wire [WORD_SIZE-1:0] leftShiftOffset_aluSrcBMux;

  wire [WORD_SIZE-1:0] aluSrcAMux_AluA;
  wire [WORD_SIZE-1:0] aluSrcBMux_AluB;

  wire [WORD_SIZE-1:0] alu_aluOut;
  wire alu_pcWriteCombo;
  wire [ADDRESS_SIZE-1:0] alu_pcSrcMux;

  wire [ADDRESS_SIZE-1:0] leftShiftAddress_pcSrcMux;

  wire [ADDRESS_SIZE-1:0] aluOut_pcSrcMux;
  wire [ADDRESS_SIZE-1:0] aluOut_memGetDataMux;
  wire [WORD_SIZE-1:0] aluOut_regWriteDataMux;

  wire [WORD_SIZE-1:0] signExtendBig_regWriteDataMux;

  wire [ADDRESS_SIZE-1:0] pcSrcMux_pc;
  wire [ADDRESS_SIZE-1:0] memGetDatMux_memAddress;

  wire pcWrite;
  wire pcWriteCond;
  wire memGetData;
  wire memRead;
  wire [1:0] regWriteDataSelect;
  wire irWrite;
  wire regWrite;
  wire aluSrcA;
  wire [1:0] aluSrcB;
  wire [3:0] aluOP;
  wire [1:0] pcSrc;
  wire regTrackSelect;

  wire pcWriteCombo;

  wire [REG_ADDRESS_SIZE-1:0] regTS_regSelA;
  wire [REG_ADDRESS_SIZE-1:0] regTS_regSelB;
  wire [REG_ADDRESS_SIZE-1:0] regTS_regSelWrite;

  wire [WORD_SIZE-1:0] regWriteDataMux_regBusWriteData;


  //CONTROL


  wire [3:0] controlFSM_controlDecode;
  Control control (
      .opcode(ir_control),
      .clk(clk),
      .reset(reset),
      .state(controlFSM_controlDecode)
  );
  //   assign controlState = controlFSM_controlDecode;

  ControlDecode controlDecode (
      .state(controlFSM_controlDecode),
      .opcode(ir_control),
      .pcWrite(pcWrite),
      .pcWriteCond(pcWriteCond),
      .memGetData(memGetData),
      .memRead(memRead),
      .regWriteDataSelect(regWriteDataSelect),
      .irWrite(irWrite),
      .aluSrcA(aluSrcA),
      .aluSrcB(aluSrcB),
      .aluOP(aluOP),
      .pcSrc(pcSrc),
      .regWrite(regWrite),
      .regTrackSelect(regTrackSelect)
  );

  assign pcWriteCombo = pcWrite || (pcWriteCond && alu_pcWriteCombo);


  //RAM
  wire [WORD_SIZE-1:0] memDataOut;
  RAM ram (
      .address(memGetDatMux_memAddress),
      .isReading(memRead),
      .reset(reset),
      .debugAddress(debugAddress),
      .debugOut(debugMemOut),
      .dataIn(regBusB_memData),
      .dataOut(memDataOut)
  );
  // 32 bit aligned 0 padded to the left 20 bit big endian instructions
  assign mem_ir  = memDataOut[WORD_SIZE-1-12:WORD_SIZE-WORD_SIZE/2];
  assign mem_mdr = memDataOut;

  // Instruction Register 

  wire [INSTRUCTION_SIZE-1:0] ir_out;
  GenReg #(
      .WIDTH(INSTRUCTION_SIZE)
  ) instructionRegister (
      .clk(clk),
      .reset(reset),
      .resetData({INSTRUCTION_SIZE{1'b0}}),
      .isWriting(irWrite),
      .dataIn(mem_ir),
      .dataOut(ir_out)
  );


  assign ir_control = ir_out[INSTRUCTION_SIZE-1:OP_LSB];  //for opcode
  assign ir_leftShiftAddress = {2'b0, ir_out[OP_LSB-1:OP_LSB-JUMP_ADDRESS_SIZE]};
  assign ir_regTSAlpha = ir_out[REG_MSB:REG_MSB-1];
  assign ir_regTSBeta = ir_out[REG_MSB-2:REG_MSB-3];
  assign ir_regTSGamma = ir_out[REG_MSB-4:REG_MSB-5];
  assign ir_signExtendBig = ir_out[BIG_IMMEDIATE_SIZE-1:0];
  assign ir_signExtendOffset = ir_out[SMALL_IMMEDIATE_SIZE-1:0];


  //   assign controlState = {irWrite, pcWrite, 1'b1, 1'b0};
  //Memory Destination Register

  GenReg #(
      .WIDTH(64)
  ) memoryDestinationRegister (
      .clk(clk),
      .reset(reset),
      .resetData({64{1'b0}}),
      .isWriting(1'b1),
      .dataIn(mem_mdr),
      .dataOut(mdr_regWriteDataMux)
  );

  //Register Track Selector

  regTS registerTrackSelector (
      .trackSelect(regTrackSelect),
      .rAlpha(ir_regTSAlpha),
      .rBeta(ir_regTSBeta),
      .rGamma(ir_regTSGamma),
      .R1(regTS_regSelA),
      .R2(regTS_regSelB),
      .RW(regTS_regSelWrite)
  );

  //Register Write Data Mux

  Mux4 #(
      .BUS_BITS(64)
  ) regWriteDataMux (
      .in1(mdr_regWriteDataMux),
      .in2(aluOut_regWriteDataMux),
      .in3(signExtendBig_regWriteDataMux),
      .in4(64'b0),  // not used
      .sel(regWriteDataSelect),
      .out(regWriteDataMux_regBusWriteData)
  );

  //Register File

  wire [WORD_SIZE-1:0] regBusBOut;

  RegisterFile registerFile (
      .selA(regTS_regSelA),
      .selB(regTS_regSelB),
      .selWrite(regTS_regSelWrite),
      .writeIn(regWriteDataMux_regBusWriteData),
      .isReading(~regWrite),  //note the bitwise negation 
      .clk(clk),
      .reset(reset),
      .outA(regBusA_aluSrcAMux),
      .outB(regBusBOut)
  );

  assign regBusB_aluSrcBMux = regBusBOut;
  assign regBusB_memData = regBusBOut;

  // signExtendOffset 
  wire [WORD_SIZE-1:0] signExtendOffsetOut;
  SignExtender #(
      .NUM_IN_BITS (SMALL_IMMEDIATE_SIZE),
      .NUM_OUT_BITS(WORD_SIZE)
  ) signExtendOffset (
      .in (ir_signExtendOffset),
      .out(signExtendOffsetOut)
  );
  assign signExtendOffset_aluSrcBMux = signExtendOffsetOut;
  assign signExtendOffset_leftShiftOffset = signExtendOffsetOut;

  // signExtendBig 
  SignExtender #(
      .NUM_IN_BITS (BIG_IMMEDIATE_SIZE),
      .NUM_OUT_BITS(WORD_SIZE)
  ) signExtendBig (
      .in (ir_signExtendBig),
      .out(signExtendBig_regWriteDataMux)
  );

  // leftShiftOffset 
  LeftShift #(
      .NUM_BITS(WORD_SIZE)
  ) leftShiftOffset (
      .in (signExtendOffset_leftShiftOffset),
      .out(leftShiftOffset_aluSrcBMux)
  );

  // aluSrcAMux 

  Mux2 #(
      .BUS_BITS(64)
  ) aluSrcAMux (
      .in1(pc_aluSrcA),
      .in2(regBusA_aluSrcAMux),
      .sel(aluSrcA),
      .out(aluSrcAMux_AluA)
  );

  // aluSrcBMux 

  Mux4 #(
      .BUS_BITS(64)
  ) aluSrcBMux (
      .in1(64'd4),  // for PC+4
      .in2(regBusB_aluSrcBMux),
      .in3(leftShiftOffset_aluSrcBMux),
      .in4(signExtendOffset_aluSrcBMux),
      .sel(aluSrcB),
      .out(aluSrcBMux_AluB)
  );
  // alu 
  wire [WORD_SIZE-1:0] aluOutWire;
  ALU alu (
      .A  (aluSrcAMux_AluA),
      .B  (aluSrcBMux_AluB),
      .op (aluOP),
      .out(aluOutWire)
  );

  assign alu_aluOut = aluOutWire;
  assign alu_pcWriteCombo = aluOutWire[0];  //take LSB of ALU as comparison result
  assign alu_pcSrcMux = aluOutWire[ADDRESS_SIZE-1:0];

  // aluOut 
  wire [WORD_SIZE-1:0] aluOut_dataOut;

  GenReg #(
      .WIDTH(64)
  ) aluOut (
      .clk(clk),
      .reset(reset),
      .resetData({64{1'b0}}),
      .isWriting(1'b1),
      .dataIn(alu_aluOut),
      .dataOut(aluOut_dataOut)
  );
  assign aluOut_memGetDataMux = aluOut_dataOut[ADDRESS_SIZE-1:0];
  assign aluOut_pcSrcMux = aluOut_dataOut[ADDRESS_SIZE-1:0];
  assign aluOut_regWriteDataMux = aluOut_dataOut;

  // leftShiftAddress 

  LeftShift #(
      .NUM_BITS(ADDRESS_SIZE)
  ) leftShiftAddress (
      .in (ir_leftShiftAddress),
      .out(leftShiftAddress_pcSrcMux)
  );

  // pcSrcMux
  Mux4 #(
      .BUS_BITS(ADDRESS_SIZE)
  ) pcSrcMux (
      .in1(aluOut_pcSrcMux),
      .in2(leftShiftAddress_pcSrcMux),
      .in3(alu_pcSrcMux),
      .in4({ADDRESS_SIZE{1'b0}}),  //not used
      .sel(pcSrc),
      .out(pcSrcMux_pc)
  );
  // pc

  wire [ADDRESS_SIZE-1:0] pc_out;


  GenReg #(
      .WIDTH(ADDRESS_SIZE)
  ) pc (
      .clk(clk),
      .reset(reset),
      .resetData(PC_START),
      .isWriting(pcWriteCombo),
      .dataIn(pcSrcMux_pc),
      .dataOut(pc_out)
  );

  //   assign controlState = pc_out[3:0];
  assign pc_aluSrcA = {44'b0, pc_out};
  assign pc_memGetDataMux = pc_out;

  // memGetDataMux

  Mux2 #(
      .BUS_BITS(ADDRESS_SIZE)
  ) memGetDataMux (
      .in1(pc_memGetDataMux),
      .in2(aluOut_memGetDataMux),
      .sel(memGetData),
      .out(memGetDatMux_memAddress)
  );


endmodule
