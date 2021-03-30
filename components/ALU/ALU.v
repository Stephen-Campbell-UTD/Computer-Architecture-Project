module ALU (
    input [WORD_SIZE-1:0] A,
    input [WORD_SIZE-1:0] B,
    input [3:0] op,
    output reg [WORD_SIZE-1:0] out,
    // output reg carry,
    output reg zero
);
  parameter WORD_SIZE = 64;

  parameter ADD = 0;
  parameter SUB = 1;
  parameter AND = 2;
  parameter OR = 3;
  parameter EQ = 4;
  parameter XOR = 5;
  parameter LT = 6;
  parameter LE = 7;
  parameter GT = 8;
  parameter GE = 9;
  parameter NOT = 10;

  always @* begin
    zero <= 0;

    case (op)
      ADD: out <= A + B;
      SUB: out <= A - B;
      //logical operations 
      AND: out <= A & B;
      OR:  out <= A | B;
      EQ:  out <= A == B;
      XOR: out <= A ^ B;
      LT:  out <= A < B;
      LE:  out <= A <= B;
      GT:  out <= A > B;
      GE:  out <= A >= B;
      NOT: out <= ~A;
    endcase

    if (out == 0) zero <= 1;

  end
endmodule
