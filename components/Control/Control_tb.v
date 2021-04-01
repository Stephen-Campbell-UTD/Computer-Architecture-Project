`timescale 1ns / 1ps
`include "./Control.v"
`include "../../multicycle/opcodes.v"
module testbench ();


  reg [5:0] opcode;
  reg clk;

  initial clk <= 0;
  always #5 clk <= ~clk;

  Control uut (
      .opcode(opcode),
      .clk(clk)
      // pcWrite,
      // pcWriteCond,
      // memGetData,  //(I or D)
      // memRead,
      // regWriteDataSelect,  //(memToReg)
      // irWrite,
      // regWrite,
      // aluSrcA,
      // aluSrcB,
      // pcSrc
  );

  initial begin
    $dumpfile("./build/main.vcd");
    $dumpvars(0, testbench);
  end


  initial begin
    //ALU R route

    // fist clock ticks at 5ns
    //ALU R takes 4 clocks = 10ns * 4 = 40ns
    // control will be in IF between the beginning of 
    // the 4th clock and end of next clock (35ns to 45ns)
    // IF (0)-> RF (1)-> ALU_R3 (3) -> ALU_4  (5) 
    opcode <= OP.ADD;
    #40;

    //ALU RI route

    // fist clock ticks at 45ns
    // ALU RI takes 4 clocks = 10ns * 4 = 40ns
    // control will be in IF between the beginning of 
    // the 4th clock and end of next clock (75ns to 85ns)
    // IF (0)-> RF (1)-> ALU_RI3 (4) -> ALU_4  (5) 

    opcode <= OP.ADDI;
    #40;  //80ns

    //Branch route

    // fist clock ticks at 85ns
    // ALU RI takes 3 clocks = 10ns * 3 = 30ns
    // control will be in IF between the beginning of 
    // the 3th clock and end of next clock (105ns to 115ns)
    // IF (0)-> RF (1)-> BRANCH3 (6)

    opcode <= OP.BEQ;
    #30;  //110ns

    //Load route

    // fist clock ticks at 115ns
    // Load takes 5 clocks = 10ns * 5 = 50ns
    // control will be in IF between the beginning of 
    // the 5th clock and end of next clock (155ns to 165ns)
    // IF (0)-> RF (1)-> MEMORY_REF3 (7) -> LOAD4 (8) -> LOAD5 (10)

    opcode <= OP.LD;
    #50;  //160ns

    //Store route

    // fist clock ticks at 165ns
    // Store takes 4 clocks = 10ns * 4 = 40ns
    // control will be in IF between the beginning of 
    // the 4th clock and end of next clock (195ns to 205ns)
    // IF (0)-> RF (1)-> MEMORY_REF3 (7) -> STORE4 (9)
    opcode <= OP.STR;
    #40;  //200ns

    //Jump route

    // fist clock ticks at 205ns
    // Jump takes 3 clocks = 10ns * 3 = 30ns
    // control will be in IF between the beginning of 
    // the 3th clock and end of next clock (225ns to 235ns)
    // IF (0)-> RF (1)-> JUMP3 (11)
    opcode <= OP.JUMP;
    #30;  //230ns

    //Immediate Injection route

    // fist clock ticks at 235ns
    // Imm Injection takes 2 clocks = 10ns * 2 = 20ns
    // control will be in IF between the beginning of 
    // the 2nd clock and end of next clock (255ns to 265ns)
    // IF (0)->  IMMEDIATE_INJECTION2 (2)
    opcode <= OP.LDI;
    #20;  //250ns
    $finish;
  end


endmodule
