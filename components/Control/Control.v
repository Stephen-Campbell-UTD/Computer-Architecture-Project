module Control (
    input [6:0] opcode,
    input clk,
    output reg pcWrite,
    output reg pcWriteCond,
    output reg memGetData,  //(I or D)
    output reg memRead,
    output reg regWriteDataSelect,  //(memToReg)
    output reg irWrite,
    output reg regWrite,
    output reg aluSrcA,
    output reg [1:0] aluSrcB,
    output reg [1:0] pcSrc
);

  //12 states -> 4 bits
  parameter INSTRUCTION_FETCH = 4'd0;
  parameter REGISTER_FETCH = 4'd1;
  parameter IMMEDIATE_INJECTION2 = 4'd2;
  parameter ALU_R_3 = 4'd3;
  parameter ALU_RI_3 = 4'd4;
  parameter ALU_4 = 4'd5;
  parameter BRANCH3 = 4'd6;
  parameter MEMORY_REF3 = 4'd7;
  parameter LOAD4 = 4'd8;
  parameter STORE4 = 4'd9;
  parameter LOAD5 = 4'd10;
  parameter JUMP3 = 4'd11;


endmodule
