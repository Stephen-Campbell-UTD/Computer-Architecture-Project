`include "./opcodes.v"
`include "../components/RAM/RAM.v"
`include "../components/Control/Control.v"
`include "../components/Misc Registers/GeneralRegister.v"
`include "../components/Control Decode/ControlDecode.v"
`include "../components/Control Decode/ControlDecode.v"
`include "../components/Muxes/Mux4.v"

module Multicycle (
    input clk
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
  parameter ADDRESS_SIZE = 20;
  parameter WORD_SIZE = 64;

  wire [ADDRESS_SIZE-1:0] pc_pcWriteMux;
  wire [WORD_SIZE-1:0] pc_aluSRCA;

  wire [WORD_SIZE-1:0] mem_ir;
  wire [WORD_SIZE-1:0] mem_mdr;

  wire [OP_SIZE-1:0] ir_control;  //for opcode
  wire [JUMP_ADDRESS_SIZE-1:0] ir_leftShiftAddress;
  wire [REG_ADDRESS_SIZE-1:0] ir_regTSAlpha;
  wire [REG_ADDRESS_SIZE-1:0] ir_regTSBeta;
  wire [REG_ADDRESS_SIZE-1:0] ir_regTSGamma; 
  wire [BIG_IMMEDIATE_SIZE-1:0] ir_signExtendBig;
  wire [SMALL_IMMEDIATE_SIZE-1:0] ir_signExtendOffset;

  wire [WORD_SIZE-1:0] mdr_regWriteDestMux;

  wire [WORD_SIZE-1:0] signExtendOffset_aluSrcBMux;
  wire [WORD_SIZE-1:0] signExtendOffset_leftShiftOffset;

  wire [WORD_SIZE-1:0] regBusA_aluSrcAMux;
  wire [WORD_SIZE-1:0] regBusA_memData;
  wire [WORD_SIZE-1:0] regBusB_aluSrcBMux;

  wire [WORD_SIZE-1:0] leftShiftOffset_aluSrcBMux;

  wire [WORD_SIZE-1:0] aluSrcAMux_AluA;
  wire [WORD_SIZE-1:0] aluSrcBMux_AluB;

  wire [WORD_SIZE-1:0] alu_aluOut;
  wire alu_pcWriteCombo;
  wire [ADDRESS_SIZE-1:0] alu_pcSrcMux;

  wire [ADDRESS_SIZE-1:0] leftShiftAddress_pcSrcMux;

  wire [ADDRESS_SIZE-1:0] aluOut_pcSrcMux;
  wire [ADDRESS_SIZE-1:0] aluOut_memGetDataMux;
  wire [WORD_SIZE-1:0] aluOut_regWriteDestMux;

  wire [WORD_SIZE-1:0] signExtendBig_regWriteDestMux;

  wire [ADDRESS_SIZE-1:0] pcSrcMux_pc;
  wire [ADDRESS_SIZE-1:0] memGetDatMux_memAddress;
  wire [ADDRESS_SIZE-1:0] pc_memGetDataMux;

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

  wire [1:0] pcWriteCombo;

  wire [REG_ADDRESS_SIZE-1:0] regTS_regBusA; 
  wire [REG_ADDRESS_SIZE-1:0] regTS_regBusB; 
  wire [REG_ADDRESS_SIZE-1:0] regTS_regBusWriteSelect; 
  
  wire [WORD_SIZE-1:0] regWriteDataMux_regBusWriteData; 


  //CONTROL


  wire [3:0] controlFSM_controlDecode
  Control control(
    .opcode(ir_control),
    .clk(clk), 
    .state(controlFSM_controlDecode) );
  ControlDecode control(
    .state(controlFSM_controlDecode),
    .opcode(ir_control),
    .pcWrite(pcWrite)
    .pcWriteCond(pcWriteCond)
    .memGetData(memGetData)
    .memRead(memRead)
    .regWriteDataSelect(regWriteDataSelect)
    .irWrite(irWrite)
    .aluSrcA(aluSrcA)
    .aluSrcB(aluSrcB)
    .aluOP(aluOP)
    .pcSrc(pcSrc)
    .regTrackSelect(regTrackSelect)
     );

  assign pcWriteCombo = pcWrite || (pcWriteCond && alu_pcWriteCombo);


  //RAM
  wire memDataOut;
  RAM ram (
    .address(memGetDatMux_memAddress),
    .isReading(memRead)),
    .clk(clk),
    .dataIn(regBusB_memData),
    .dataOut(memDataOut),
  );
  assign mem_ir = memDataOut;
  assign mem_mdr = memDataOut;

  // Instruction Register 

  wire ir_out;
  GenReg #(.WIDTH(64)) instructionRegister (
    .clk(clk),
    .dataIn(mem_ir),
    .dataOut(ir_out)
    );


  assign ir_control = ir_out[INSTRUCTION_SIZE-1:OP_LSB]; //for opcode
  assign ir_leftShiftAddress = ir_out[OP_LSB-1:OP_LSB-JUMP_ADDRESS_SIZE]
  assign ir_regTSAlpha = ir_out[REG_MSB: REG_MSB-1];
  assign ir_regTSBeta= ir_out[REG_MSB-2: REG_MSB-3];
  assign ir_regTSGamma = ir_out[REG_MSB-4: REG_MSB-5];
  assign ir_signExtendBig = ir_out[BIG_IMMEDIATE_SIZE-1:0];
  assign ir_signExtendOffset = ir_out[SMALL_IMMEDIATE_SIZE-1:0];


  //Memory Destination Register

  GenReg #(.WIDTH(64)) memoryDestinationRegister (
    .clk(clk),
    .dataIn(mem_mdr),
    .dataOut(mdr_regWriteDestMux)
    );

  //Register Track Selector
  regTS registerTrackSelector(
    .trackSelect(regTrackSelect),
    .rAlpha(ir_regTSAlpha),
    .rBeta(ir_regTSBeta),
    .rGamma(ir_regTSGamma),
    .R1(regTS_regBusA),
    .R2(regTS_regBusB),
    .RW(regTS_regBusWriteSelect)
  ); 

  //Register Write Data Mux

  Mux4 #(.BUS_BITS(64)) regWriteDataMux(
    .in1(mdr_regWriteDestMux),
    .in2(aluOut_regWriteDestMux),
    .in3(signExtendBig_regWriteDestMux),
    .in4(0),// not used
    .sel(regWriteDataSelect)
    .out(regWriteDataMux_regBusWriteData)
  );

  //Register File



endmodule
