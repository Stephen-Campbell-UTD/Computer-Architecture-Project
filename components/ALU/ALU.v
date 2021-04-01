`include "../../multicycle/opcodes.v"
module ALU (
    input [WORD_SIZE-1:0] A,
    input [WORD_SIZE-1:0] B,
    input [3:0] op,
    output reg [WORD_SIZE-1:0] out,
    // output reg carry,
    output reg zero
);
  parameter WORD_SIZE = 64;


  always @* begin
    zero <= 0;

    case (op)
      //aritmetic
      OP.ALU_ADD: out <= A + B;
      OP.ALU_SUB: out <= A - B;
      OP.ALU_MUL: out <= A * B;
      OP.ALU_SL:  out <= A << B;
      OP.ALU_DIV: out <= A / B;
      OP.ALU_MOD: out <= A % B;
      //logical operations 
      OP.ALU_NOT: out <= ~A;
      OP.ALU_OR:  out <= A | B;
      OP.ALU_AND: out <= A & B;
      OP.ALU_XOR: out <= A ^ B;
      OP.ALU_EQ:  out <= A == B;
      OP.ALU_NEQ: out <= A == B;
      OP.ALU_LT:  out <= A < B;
      OP.ALU_LE:  out <= A <= B;
      OP.ALU_GT:  out <= A > B;
      OP.ALU_GE:  out <= A >= B;
    endcase

    if (out == 0) zero <= 1;

  end
endmodule
