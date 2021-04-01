`include "../../multicycle/opcodes.v"
module Control (
    input [5:0] opcode,
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
  parameter ALU_R3 = 4'd3;
  parameter ALU_RI3 = 4'd4;
  parameter ALU4 = 4'd5;
  parameter BRANCH3 = 4'd6;
  parameter MEMORY_REF3 = 4'd7;
  parameter LOAD4 = 4'd8;
  parameter STORE4 = 4'd9;
  parameter LOAD5 = 4'd10;
  parameter JUMP3 = 4'd11;

  reg [3:0] state;
  initial begin
    state <= INSTRUCTION_FETCH;
  end

  always @(posedge clk) begin
    case (state)
      INSTRUCTION_FETCH: begin
        case (opcode)
          OP.LDI:  state <= IMMEDIATE_INJECTION2;
          default: state <= REGISTER_FETCH;
        endcase
      end
      REGISTER_FETCH: begin
        casez (opcode[5:3])
          {OP.ALU_R_HEADER, 1'b?} : state <= ALU_R3;
          {OP.ALU_RI_HEADER, 1'b?} : state <= ALU_RI3;
          OP.BRANCH_HEADER: state <= BRANCH3;
          OP.MEMORY_REF_HEADER: state <= MEMORY_REF3;
          OP.JUMP[5:3]: state <= JUMP3;
          default: begin
            $display("Somehow ended up at Register Fetch with bad opcode header");
          end
        endcase
      end
      IMMEDIATE_INJECTION2: state <= INSTRUCTION_FETCH;
      ALU_R3: state <= ALU4;
      ALU_RI3: state <= ALU4;
      ALU4: state <= INSTRUCTION_FETCH;
      BRANCH3: state <= INSTRUCTION_FETCH;
      MEMORY_REF3: begin
        case (opcode[2])
          OP.LD[2]:  state <= LOAD4;
          OP.STR[2]: state <= STORE4;
          default: begin
            $display("Somehow ended up at Register Fetch with bad opcode header");
          end
        endcase
      end
      LOAD4: state <= LOAD5;
      STORE4: state <= INSTRUCTION_FETCH;
      LOAD5: state <= INSTRUCTION_FETCH;
      JUMP3: state <= INSTRUCTION_FETCH;
      default: begin
        $display("Somehow arrived at invalid control state");
      end
    endcase
  end



endmodule
