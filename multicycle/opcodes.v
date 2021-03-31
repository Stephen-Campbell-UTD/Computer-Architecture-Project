module OP ();
  parameter [1:0] ALU_R_HEADER = 2'b00;
  parameter [1:0] ALU_RI_HEADER = 2'b00;
  parameter [2:0] BRANCH_HEADER = 3'b100;
  parameter [2:0] MEMORY_REF_HEADER = 3'b101;

  //one off instructions
  parameter [5:0] LDI = 6'b111111;
  parameter [5:0] JUMP = 6'b110000;

  //ALU R Type instructions
  parameter [5:0] ADD = {ALU_R_HEADER, 4'd0};
  parameter [5:0] SUB = {ALU_R_HEADER, 4'd1};
  parameter [5:0] MUL = {ALU_R_HEADER, 4'd2};
  parameter [5:0] DIV = {ALU_R_HEADER, 4'd3};
  parameter [5:0] MOD = {ALU_R_HEADER, 4'd4};
  parameter [5:0] AND = {ALU_R_HEADER, 4'd5};
  parameter [5:0] OR = {ALU_R_HEADER, 4'd6};
  parameter [5:0] NOT = {ALU_R_HEADER, 4'd7};
  parameter [5:0] XOR = {ALU_R_HEADER, 4'd8};
  parameter [5:0] SL = {ALU_R_HEADER, 4'd9};
  parameter [5:0] NOR = {ALU_R_HEADER, 4'd10};

  //ALU RI Type instructions
  parameter [5:0] ADDI = {ALU_RI_HEADER, 4'd0};
  parameter [5:0] SUBI = {ALU_RI_HEADER, 4'd1};
  parameter [5:0] MULI = {ALU_RI_HEADER, 4'd2};
  parameter [5:0] DIVI = {ALU_RI_HEADER, 4'd3};
  parameter [5:0] MODI = {ALU_RI_HEADER, 4'd4};
  parameter [5:0] ANDI = {ALU_RI_HEADER, 4'd5};
  parameter [5:0] ORI = {ALU_RI_HEADER, 4'd6};
  parameter [5:0] NOTI = {ALU_RI_HEADER, 4'd7};
  parameter [5:0] XORI = {ALU_RI_HEADER, 4'd8};
  parameter [5:0] SLI = {ALU_RI_HEADER, 4'd9};
  parameter [5:0] NORI = {ALU_RI_HEADER, 4'd10};

  //Branch instructions
  parameter [5:0] BEQ = {BRANCH_HEADER, 3'd0};
  parameter [5:0] BLEQ = {BRANCH_HEADER, 3'd1};
  parameter [5:0] BGEQ = {BRANCH_HEADER, 3'd2};
  parameter [5:0] BG = {BRANCH_HEADER, 3'd3};
  parameter [5:0] BL = {BRANCH_HEADER, 3'd4};
  parameter [5:0] BNEQ = {BRANCH_HEADER, 3'd5};

  //Memory Reference Instructions
  parameter [5:0] LD = {MEMORY_REF_HEADER, 3'b000};
  parameter [5:0] STR = {MEMORY_REF_HEADER, 3'b100};




endmodule
