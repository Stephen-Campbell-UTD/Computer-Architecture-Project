`include "./opcodes.v"
`include "../components/RAM/RAM.v"
`include "../components/Control/Control.v"
`include "../components/Control Decode/ControlDecode.v"
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

  //additional params
  parameter ADDRESS_SIZE = 20;
  parameter WORD_SIZE = 64;

  wire [ADDRESS_SIZE-1:0] pc_pcWriteMux;
  wire [WORD_SIZE-1:0] pc_aluSRCA;

  wire [WORD_SIZE-1:0] mem_ir;
  wire [WORD_SIZE-1:0] mem_mdr;

  wire [OP_SIZE-1:0] ir_control;  //for opcode
  wire [JUMP_ADDRESS_SIZE-1:0] ir_leftShiftAddress;
  wire [REG_ADDRESS_SIZE-1:0] ir_regSelA;
  wire [REG_ADDRESS_SIZE-1:0] ir_regSelB;
  wire [REG_ADDRESS_SIZE-1:0] ir_regSelWrite;
  wire [BIG_IMMEDIATE_SIZE-1:0] ir_signExtendBig;
  wire [SMALL_IMMEDIATE_SIZE-1:0] ir_signExtendOffset;

  wire [WORD_SIZE-1:0] mdr_regWriteDestMux;

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
  wire [WORD_SIZE-1:0] aluOut_regWriteDestMux;

  wire [WORD_SIZE-1:0] signExtendBig_regWriteDestMux;

  wire [ADDRESS_SIZE-1:0] pcSrcMux_pc;
  wire [ADDRESS_SIZE-1:0] memGetDatMux_memAddress;
  wire [ADDRESS_SIZE-1:0] pc_memGetDataMux;

  wire pcWrite;
  wire pcWriteCond;
  wire memGetData;
  wire memRead;
  wire [1:0] regWriteDataSel;
  wire irWrite;
  wire regWrite;
  wire aluSrcA;
  wire [1:0] aluSrcB;
  wire [3:0] aluOP;
  wire [1:0] pcSrc;


  wire [1:0] pcWriteCombo;

  //CONTROL
  // Control control(.clk(clk) );



  //RAM TO INSTRUCTION REGISTER AND MDR


  //INSTRUCITON REGISTER  and MDR  to CONTROL, muxes and Sign Extender

  //Register File to muxes and 



endmodule
