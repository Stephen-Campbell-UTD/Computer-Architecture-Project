`include "params.v"

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
  // ASSEMBLY: add rAlpha, rBeta imm  ; rAlpha = rBeta + SignExtended(imm) ;
  // ASSEMBLY: branch  rAlpha == rBeta  offset  ; 
  // A==B ->PC=PC+SignExtended(offset2 << 2) ;
  // ASSEMBLY: load rAlpha, rBeta[imm]  ; R[rAlpha] = MEM[R[rBeta] + SignExtended(imm)]
  // ASSEMBLY: store rBeta, rAlpha[imm]  ; MEM[R[rAlpha] + SignExtended(imm)] = R[rBeta]
  // opcode | rAlpha  | rBeta  | immediate/offset (small)  
  //   6    |    2    |    2   |   10     

  // Instruction format 3: Single Register Selection -> Immediate Injection
  // ASSEMBLY:  loadi rAlpha, imm  ; R[rAlpha] = SignExtended(imm);
  // opcode | rAlpha  | immediate/offset (big)  
  //   6    |    2    |   12     

  // Instruction format 3: No Register Selection -> Jump
  // ASSEMBLY: jump addr;
  // opcode |  jumpAddress | unused
  //   6    |       9      |    3


  //ADD Program
  //32 bit aligned left 0 padded instructions

  // program A + B -> C
  // assuming all registers start cleared

  // load R0 <= R3(0)
  // 1010 00 | 00 | 11 | 00 0000 0000 
  // opcode  | RD | RA | offset (10 bits)
  // 000 A0440

  //load R1 <= R3(8)
  // 1010 00 | 01 | 11 | 00 0000 1000 
  // opcode  | RD | RA | offset (10 bits)
  // 000 A1804

  //add R0 R1 ->R2

  // 000000  | 10 | 00 | 01 | 0000 0000 
  // opcode  | RD | RA | RB | unused
  // 000 02100

  //store R2 => R3(0)

  // 101100  | 11 | 10 | 00 0001 0000 
  // opcode  | RA | RT | offset
  // 000 B3810


  //Loop Sum Program
  //32 bit aligned left 0 padded instructions

  // program loop sum
  // int sum = 0;
  // for(int i = 0; i <=10 ; i++){
  //   sum +=i;
  // }
  /*
          loadi R0 <= 0 //sum 
          loadi R1 <= 0 //i 
          loadi R2 <= 10 //for test expression 
.loop     bgt R1 > R2 to .finish(pc + 4 + 12 (bytes))
          add R0+R1 -> R0 
          addi R1+1 -> R1
          jump .loop (pc + 4 - 16 (bytes)) 
.finish   store R0 -> R3(0)
*/
  // assuming all registers start cleared

  // loadi R0 <= 0
  // 1111 11 | 00 | 0000 0000 0000 
  // opcode  | RD | immediate
  // 000 FC000

  // loadi R1 <= 0
  // 1111 11 | 01 | 0000 0000 0000 
  // opcode  | RD | immediate
  // 000 FD000

  // loadi R2 <= 10
  // 1111 11 | 10 | 0000 0000 1010 
  // opcode  | RD | immediate
  // 000 FE00A

  // bgt R1 R2 to pc + 1*4 + 3*4 (0x41C)
  // 100110  | 01 | 10 | 00 0000 0003 
  // opcode  | R1 | R2 | offset
  // 000 99803


  // add R0+R1 -> R0 
  // 000000  | 00 | 00 | 01 | 0000 0000 
  // opcode  | RD | RA | RB | unused
  // 000 00100


  // addi R1+1 -> R1
  // 010000  | 01 | 01 | 00 0000 0001 
  // opcode  | RD | RA | immediate
  // 000 41401


  // jump .loop (0x40C)
  // 110000  | 10 0000 011 | 0 0000
  // opcode  | address     | unused
  // 000 C2060


  // store R0 -> R3(0)
  // 101100  | 11 | 00 | 00 0000 0000 
  // opcode  | RA | RT | offset
  //000 B3000





endmodule
