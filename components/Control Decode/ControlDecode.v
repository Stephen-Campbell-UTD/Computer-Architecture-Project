`include "../Control/ControlStates.v"
`include "../../multicycle/opcodes.v"
module ControlDecode (
    input [3:0] state,
    input [5:0] opcode,
    output reg pcWrite,
    output reg pcWriteCond,
    output reg memGetData,  //(I or D)
    output reg memRead,
    output reg [1:0] regWriteDataSelect,  //(memToReg)
    output reg irWrite,
    output reg regWrite,
    output reg aluSrcA,
    output reg [1:0] aluSrcB,
    output reg [3:0] aluOP,
    output reg [1:0] pcSrc
);

  //mux selection parameters
  parameter regWriteDataSelect_MDR = 0;
  parameter regWriteDataSelect_ALUOUT = 1;
  parameter regWriteDataSelect_SE_IMM_BIG = 2;
  parameter regWriteDataSelect_D = 0;

  parameter aluSrcA_PC = 0;
  parameter aluSrcA_BUSA = 1;
  parameter aluSrcA_D = 0;

  parameter aluSrcB_4 = 0;
  parameter aluSrcB_BUSB = 1;
  parameter aluSrcB_SE_LS_OFFSET = 2;
  parameter aluSrcB_SE_OFFSET = 3;
  parameter aluSrcB_D = 0;

  parameter pcSrc_ALUOUT = 0;
  parameter pcSrc_JUMP_ADDRESS = 1;
  parameter pcSrc_ALU_DIRECT = 2;
  parameter pcSrc_D = 0;
  // parameter pcSrc_XXX = 3;

  //Instruction Fetch
  always @* begin
    if (state == CS.INSTRUCTION_FETCH) begin
      pcWrite <= 1;
      pcWriteCond <= 0;
      memGetData <= 1;
      memRead <= 1;
      regWriteDataSelect <= regWriteDataSelect_D;
      irWrite <= 1;
      regWrite <= 0;
      aluSrcA <= aluSrcA_PC;
      aluSrcB <= aluSrcB_4;
      aluOP <= OP.ALU_ADD;
      pcSrc <= pcSrc_ALU_DIRECT;
    end
  end

  //Register Fetch

  always @* begin
    if (state == CS.REGISTER_FETCH) begin
      pcWrite <= 0;
      pcWriteCond <= 0;
      memGetData <= 0;
      memRead <= 1;
      regWriteDataSelect <= regWriteDataSelect_D;
      irWrite <= 0;
      regWrite <= 0;
      aluSrcA <= aluSrcA_PC;
      aluSrcB <= aluSrcB_SE_LS_OFFSET;
      aluOP <= OP.ALU_ADD;
      pcSrc <= pcSrc_D;
    end
  end
  //Immediate Injection 2
  always @* begin
    if (state == CS.IMMEDIATE_INJECTION2) begin
      pcWrite <= 0;
      pcWriteCond <= 0;
      memGetData <= 0;  //dont care
      memRead <= 1;
      regWriteDataSelect <= regWriteDataSelect_SE_IMM_BIG;
      irWrite <= 0;
      regWrite <= 1;
      aluSrcA <= aluSrcA_D;
      aluSrcB <= aluSrcB_D;
      aluOP <= 0;  //dont care
      pcSrc <= pcSrc_D;
    end
  end

  //ALU R Type Step 3 

  always @* begin
    if (state == CS.ALU_R3) begin
      pcWrite <= 0;
      pcWriteCond <= 0;
      memGetData <= 0;  //dont care
      memRead <= 1;
      regWriteDataSelect <= regWriteDataSelect_D;
      irWrite <= 0;
      regWrite <= 0;
      aluSrcA <= aluSrcA_BUSA;
      aluSrcB <= aluSrcB_BUSB;
      aluOP <= opcode[3:0];
      pcSrc <= pcSrc_D;
    end
  end
  //ALU RI Type Step 3 
  always @* begin
    if (state == CS.ALU_RI3) begin
      pcWrite <= 0;
      pcWriteCond <= 0;
      memGetData <= 0;  //dont care
      memRead <= 1;
      regWriteDataSelect <= regWriteDataSelect_D;
      irWrite <= 0;
      regWrite <= 0;
      aluSrcA <= aluSrcA_BUSA;
      aluSrcB <= aluSrcB_SE_OFFSET;
      aluOP <= opcode[3:0];
      pcSrc <= pcSrc_D;
    end
  end
  //ALU Step 4
  always @* begin
    if (state == CS.ALU4) begin
      pcWrite <= 0;
      pcWriteCond <= 0;
      memGetData <= 0;  //dont care
      memRead <= 1;
      regWriteDataSelect <= regWriteDataSelect_ALUOUT;
      irWrite <= 0;
      regWrite <= 1;
      aluSrcA <= aluSrcA_D;
      aluSrcB <= aluSrcB_D;
      aluOP <= 0;  //dont care
      pcSrc <= pcSrc_D;
    end
  end
  //Branch Step 3
  always @* begin
    if (state == CS.BRANCH3) begin
      pcWrite <= 0;
      pcWriteCond <= 1;
      memGetData <= 0;  //dont care
      memRead <= 1;
      regWriteDataSelect <= regWriteDataSelect_D;
      irWrite <= 0;  //dont care
      regWrite <= 0;
      aluSrcA <= aluSrcA_BUSA;
      aluSrcB <= aluSrcB_BUSB;
      aluOP <= {1'b1, opcode[2:0]};
      pcSrc <= pcSrc_D;
    end
  end

  //Memory Ref Step 3
  always @* begin
    if (state == CS.MEMORY_REF3) begin
      pcWrite <= 0;
      pcWriteCond <= 0;
      memGetData <= 0;  //dont care
      memRead <= 1;
      regWriteDataSelect <= regWriteDataSelect_D;
      irWrite <= 0;  //dont care
      regWrite <= 0;
      aluSrcA <= aluSrcA_BUSA;
      aluSrcB <= aluSrcB_SE_OFFSET;
      aluOP <= OP.ALU_ADD;  //dont care
      pcSrc <= pcSrc_D;
    end
  end
  //Load Step 4
  always @* begin
    if (state == CS.LOAD4) begin
      pcWrite <= 0;
      pcWriteCond <= 0;
      memGetData <= 0;  //get the data!
      memRead <= 1;
      regWriteDataSelect <= regWriteDataSelect_D;
      irWrite <= 0;  //dont care
      regWrite <= 0;
      aluSrcA <= aluSrcA_D;
      aluSrcB <= aluSrcB_D;
      aluOP <= OP.ALU_ADD;  //dont care
      pcSrc <= pcSrc_D;
    end
  end
  //Store Step 4
  always @* begin
    if (state == CS.STORE4) begin
      pcWrite <= 0;
      pcWriteCond <= 0;
      memGetData <= 0;  //dont care
      memRead <= 0;  //writing!
      regWriteDataSelect <= regWriteDataSelect_D;
      irWrite <= 0;  //dont care
      regWrite <= 0;
      aluSrcA <= aluSrcA_D;
      aluSrcB <= aluSrcB_D;
      aluOP <= 0;  // dont care (4 bits)
      pcSrc <= pcSrc_D;
    end
  end
  //Load Step 5
  always @* begin
    if (state == CS.LOAD5) begin
      pcWrite <= 0;
      pcWriteCond <= 0;
      memGetData <= 0;  //dont care
      memRead <= 1;  // dont want to overwrite
      regWriteDataSelect <= regWriteDataSelect_MDR;
      irWrite <= 0;  //dont care
      regWrite <= 1;
      aluSrcA <= aluSrcA_D;
      aluSrcB <= aluSrcB_D;
      aluOP <= 0;  // dont care (4 bits)
      pcSrc <= pcSrc_D;
    end
  end
  //Jump Step 3
  always @* begin
    if (state == CS.JUMP3) begin
      pcWrite <= 1;
      pcWriteCond <= 0;
      memGetData <= 0;  //dont care
      memRead <= 1;  // dont want to overwrite
      regWriteDataSelect <= regWriteDataSelect_D;
      irWrite <= 0;  //dont care
      regWrite <= 0;
      aluSrcA <= aluSrcA_D;
      aluSrcB <= aluSrcB_D;
      aluOP <= 0;  // dont care (4 bits)
      pcSrc <= pcSrc_JUMP_ADDRESS;
    end
  end

endmodule
