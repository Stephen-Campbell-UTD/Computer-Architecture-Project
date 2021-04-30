`timescale 1ns / 1ps
`include "opcodes.vh"
`include "ControlStates.vh"
`include "./ControlDecode.v"

module testbench ();

  reg [3:0] state;
  reg [5:0] opcode;

   wire pcWrite;
   wire pcWriteCond;
   wire memGetData;  //(I or D)
   wire memRead;
   wire [1:0] regWriteDataSelect;  //(memToReg)
   wire irWrite;
   wire regWrite;
   wire aluSrcA;
   wire [1:0] aluSrcB;
   wire [3:0] aluOP;
   wire [1:0] pcSrc;
   wire regTrackSelect;

  ControlDecode uut (
      .state (state),
      .opcode(opcode),
      .pcWrite(pcWrite),
      .pcWriteCond(pcWriteCond),
      .memGetData(memGetData),
      .memRead(memRead),
      .regWriteDataSelect(regWriteDataSelect),
      .irWrite(irWrite),
      .regWrite(regWrite),
      .aluSrcA(aluSrcA),
      .aluSrcB(aluSrcB),
      .aluOP(aluOP),
      .pcSrc(pcSrc),
      .regTrackSelect(regTrackSelect)
  );


  initial begin
    $dumpfile("./build/main.vcd");
    $dumpvars(0, testbench);
  end


  initial begin
    //Instruction Fetch
    state <= `INSTRUCTION_FETCH;
    opcode <= `ADD;
    #10
    //Register Fetch
    state <= `REGISTER_FETCH;
    opcode <= `ADD;
    #10
    //Immediate Injection 3
    state <= `IMMEDIATE_INJECTION3;
    opcode <= `LDI;
    #10
    //ALU R 3
    state <= `ALU_R3;
    opcode <= `ADD;
    #10
    //ALU RI 3
    state <= `ALU_RI3;
    opcode <= `ADDI;
    #10
    //ALU 4 
    state <= `ALU4;
    opcode <= `ADD;
    #10
    //Branch 3 
    state <= `BRANCH3;
    opcode <= `BEQ;
    #10
    //Mem Ref 3 
    state <= `MEMORY_REF3;
    opcode <= `LD;
    #10
    //Load 4 
    state <= `LOAD4;
    opcode <= `LD;
    #10
    //Store 4
    state <= `STORE4;
    opcode <= `STR;
    #10
    //Load 5
    state <= `LOAD5;
    opcode <= `LD;
    #10
    //Jump 3
    state <= `JUMP3;
    opcode <= `JUMP;
    #10
    $finish;
  end


endmodule


    //Instruction Fetch
    //Register Fetch
    //Immediate Inejction 2
    //ALU R 3
    //ALU RI 3
    //ALU 4 
    //Branch 3 
    //Mem Ref 3 
    //Load 4 
    //Store 4
    //Load 5
    //Jump 3


