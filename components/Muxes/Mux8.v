module Mux8 #(
    parameter BUS_BITS = 64
) (
    input [BUS_BITS-1:0] in1,
    input [BUS_BITS-1:0] in2,
    input [BUS_BITS-1:0] in3,
    input [BUS_BITS-1:0] in4,
    input [BUS_BITS-1:0] in5,
    input [BUS_BITS-1:0] in6,
    input [BUS_BITS-1:0] in7,
    input [BUS_BITS-1:0] in8,
    input [2:0] sel,
    output reg [BUS_BITS-1:0] out
);


  always @* begin
    case (sel)
      0: out <= in1;
      1: out <= in2;
      2: out <= in3;
      3: out <= in4;
      4: out <= in5;
      5: out <= in6;
      6: out <= in7;
      7: out <= in8;
    endcase
  end

endmodule