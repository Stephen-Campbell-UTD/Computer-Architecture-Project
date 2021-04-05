`timescale 1ns / 1ps
`include "./ControlDecode.v"
`include "../Control/ControlStates.v"
`include "../../multicycle/opcodes.v"
module testbench ();

  reg [3:0] state;
  reg [5:0] opcode;

  ControlDecode uut (
      .state (state),
      .opcode(opcode)
  );


  initial begin
    $dumpfile("./build/main.vcd");
    $dumpvars(0, testbench);
  end


  initial begin
    //Instruction Fetch
    state <= CS.INSTRUCTION_FETCH;
    opcode <= OP.ADD;
    #10
    //Register Fetch
    state <= CS.REGISTER_FETCH;
    opcode <= OP.ADD;
    #10
    //Immediate Injection 2
    state <= CS.IMMEDIATE_INJECTION2;
    opcode <= OP.LDI;
    #10
    //ALU R 3
    state <= CS.ALU_R3;
    opcode <= OP.ADD;
    #10
    //ALU RI 3
    state <= CS.ALU_RI3;
    opcode <= OP.ADDI;
    #10
    //ALU 4 
    state <= CS.ALU4;
    opcode <= OP.ADD;
    #10
    //Branch 3 
    state <= CS.BRANCH3;
    opcode <= OP.BEQ;
    #10
    //Mem Ref 3 
    state <= CS.MEMORY_REF3;
    opcode <= OP.LD;
    #10
    //Load 4 
    state <= CS.LOAD4;
    opcode <= OP.LD;
    #10
    //Store 4
    state <= CS.STORE4;
    opcode <= OP.STR;
    #10
    //Load 5
    state <= CS.LOAD5;
    opcode <= OP.LD;
    #10
    //Jump 3
    state <= CS.JUMP3;
    opcode <= OP.JUMP;
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


