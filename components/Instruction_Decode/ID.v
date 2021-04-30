module InstructionDecode (
    input [INSTRUCTION_SIZE-1:0] instruction,
    output [OP_SIZE-1:0] opcode,
    output [REG_ADDRESS_SIZE-1:0] rAlpha,
    output [REG_ADDRESS_SIZE-1:0] rBeta,
    output [REG_ADDRESS_SIZE-1:0] rGamma,
    output [SMALL_IMMEDIATE_SIZE-1:0] smImm,
    output [BIG_IMMEDIATE_SIZE-1:0] bgImm,
    output [JUMP_ADDRESS_SIZE-1:0] jumpAddress
);
  //must keep consistent with the multicycle
  parameter INSTRUCTION_SIZE = 20;
  parameter OP_SIZE = 6;
  parameter REG_ADDRESS_SIZE = 2;
  parameter SMALL_IMMEDIATE_SIZE = 10;
  parameter BIG_IMMEDIATE_SIZE = 12;
  parameter JUMP_ADDRESS_SIZE = 9;  //left shifted twice


  //opcode decode
  parameter OP_LSB = INSTRUCTION_SIZE - OP_SIZE;
  assign opcode = instruction[INSTRUCTION_SIZE-1:OP_LSB];

  //register decode
  parameter REG_MSB = OP_LSB - 1;
  assign rAlpha = instruction[REG_MSB:REG_MSB-1];
  assign rBeta = instruction[REG_MSB-2:REG_MSB-3];
  assign rGamma = instruction[REG_MSB-4:REG_MSB-5];

  //immediate decode
  assign smImm = instruction[SMALL_IMMEDIATE_SIZE-1:0];
  assign bgImm = instruction[BIG_IMMEDIATE_SIZE-1:0];
  assign jumpAddress = instruction[OP_LSB-1:OP_LSB-JUMP_ADDRESS_SIZE];


  // Instruction format 1: 3 Registers Selections -> Data computation 
  // ASSEMBLY: add  rAlpha, rBeta, rGamma  ; rAlpha = rBeta + rGamma ;
  // opcode | rAlpha  | rBeta  | rGamma  | unused  
  //   6    |    2    |    2   |   2     |   8 

  // Instruction format 2: 2 Register Selections -> 
  // ALU R I Type / Branch  / Load / Store
  // ASSEMBLY: add rAlpha, rBeta imm  ; rAlpha = rBeta + imm ;
  // ASSEMBLY: branch  rAlpha == rBeta  offset  ; 
  // A==B ->PC=PC+SignExtended(offset<<2) ;
  // ASSEMBLY: load rAlpha, rBeta[imm]  ; A = MEM[B + SignExtended(imm)]
  // ASSEMBLY: store rAlpha, rBeta[imm]  ; MEM[B + SignExtended(imm)] = A
  // opcode | rAlpha  | rBeta  | immediate/offset (small)  
  //   6    |    2    |    2   |   10     

  // Instruction format 3: Single Register Selection -> Immediate Injection
  // ASSEMBLY:  loadi rAlpha, imm  ; rAlpha = imm;
  // opcode | rAlpha  | immediate/offset (big)  
  //   6    |    2    |   12     

  // Instruction format 3: No Register Selection -> Jump
  // ASSEMBLY: jump addr;
  // opcode |  jumpAddress | unused
  //   6    |       9      |    3




endmodule
