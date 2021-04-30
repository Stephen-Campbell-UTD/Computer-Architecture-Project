`include "opcodes.vh"

module ALU (
    input [WORD_SIZE-1:0] A,
    input [WORD_SIZE-1:0] B,
    input [3:0] op,
    output reg [WORD_SIZE-1:0] out
);
  parameter WORD_SIZE = 64;

  always @* begin
    case (op)
      //arithmetic
      `ALU_ADD: out <= A + B;
      `ALU_SUB: out <= A - B;
      `ALU_MUL: out <= A * B;
      `ALU_SL:  out <= A << B;
      `ALU_DIV: out <= A / B;
      `ALU_MOD: out <= A % B;
      //logical operations 
      `ALU_NOT: out <= ~A;
      `ALU_OR:  out <= A | B;
      `ALU_AND: out <= A & B;
      `ALU_XOR: out <= A ^ B;
      `ALU_EQ:  out <= A == B;
      `ALU_NEQ: out <= A == B;
      `ALU_LT:  out <= A < B;
      `ALU_LE:  out <= A <= B;
      `ALU_GT:  out <= A > B;
      `ALU_GE:  out <= A >= B;
    endcase

  end
endmodule
