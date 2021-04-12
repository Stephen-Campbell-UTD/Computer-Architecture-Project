`ifndef OPCODES_V
`define OPCODES_V 
module OP ();

  //ALU ops
  // ALU has 4 bit opcode
  parameter ALU_ADD = 0;
  parameter ALU_SUB = 1;
  parameter ALU_MUL = 2;
  parameter ALU_SL = 3;
  parameter ALU_DIV = 4;
  parameter ALU_MOD = 5;
  parameter ALU_NOT = 6;
  parameter ALU_OR = 7;
  parameter ALU_AND = 8;
  parameter ALU_XOR = 9;
  parameter ALU_EQ = 10;
  parameter ALU_NEQ = 11;
  parameter ALU_LT = 12;
  parameter ALU_LE = 13;
  parameter ALU_GT = 14;
  parameter ALU_GE = 15;


  parameter [1:0] ALU_R_HEADER = 2'b00;
  parameter [1:0] ALU_RI_HEADER = 2'b01;
  parameter [2:0] BRANCH_HEADER = 3'b100;
  parameter [2:0] MEMORY_REF_HEADER = 3'b101;

  //one off instructions
  parameter [5:0] LDI = 6'b111111;
  parameter [5:0] JUMP = 6'b110000;

  //ALU R Type instructions
  parameter [5:0] ADD = {ALU_R_HEADER, ALU_ADD};
  parameter [5:0] SUB = {ALU_R_HEADER, ALU_SUB};
  parameter [5:0] MUL = {ALU_R_HEADER, ALU_MUL};
  parameter [5:0] DIV = {ALU_R_HEADER, ALU_DIV};
  parameter [5:0] MOD = {ALU_R_HEADER, ALU_MOD};
  parameter [5:0] AND = {ALU_R_HEADER, ALU_AND};
  parameter [5:0] OR = {ALU_R_HEADER, ALU_OR};
  parameter [5:0] NOT = {ALU_R_HEADER, ALU_NOT};
  parameter [5:0] XOR = {ALU_R_HEADER, ALU_XOR};
  parameter [5:0] SL = {ALU_R_HEADER, ALU_SL};

  //ALU RI Type instructions
  parameter [5:0] ADDI = {ALU_RI_HEADER, ALU_ADD};
  parameter [5:0] SUBI = {ALU_RI_HEADER, ALU_SUB};
  parameter [5:0] MULI = {ALU_RI_HEADER, ALU_MUL};
  parameter [5:0] DIVI = {ALU_RI_HEADER, ALU_DIV};
  parameter [5:0] MODI = {ALU_RI_HEADER, ALU_MOD};
  parameter [5:0] ANDI = {ALU_RI_HEADER, ALU_AND};
  parameter [5:0] ORI = {ALU_RI_HEADER, ALU_OR};
  parameter [5:0] NOTI = {ALU_RI_HEADER, ALU_NOT};
  parameter [5:0] XORI = {ALU_RI_HEADER, ALU_XOR};
  parameter [5:0] SLI = {ALU_RI_HEADER, ALU_SL};

  //Branch instructions
  parameter [5:0] BEQ = {BRANCH_HEADER, ALU_EQ[2:0]};
  parameter [5:0] BNEQ = {BRANCH_HEADER, ALU_NEQ[2:0]};
  parameter [5:0] BLT = {BRANCH_HEADER, ALU_LT[2:0]};
  parameter [5:0] BLEQ = {BRANCH_HEADER, ALU_LE[2:0]};
  parameter [5:0] BGT = {BRANCH_HEADER, ALU_GT[2:0]};
  parameter [5:0] BGEQ = {BRANCH_HEADER, ALU_GE[2:0]};

  //Memory Reference Instructions
  parameter [5:0] LD = {MEMORY_REF_HEADER, 3'b000};
  parameter [5:0] STR = {MEMORY_REF_HEADER, 3'b100};




endmodule

`endif
