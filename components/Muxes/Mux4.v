

module Mux4 #(
    parameter BUS_BITS = 64
) (
    input [BUS_BITS-1:0] in1,
    input [BUS_BITS-1:0] in2,
    input [BUS_BITS-1:0] in3,
    input [BUS_BITS-1:0] in4,
    input [1:0] sel,
    output reg [BUS_BITS-1:0] out
);


  always @* begin
    case (sel)
      0: out <= in1;
      1: out <= in2;
      2: out <= in3;
      3: out <= in4;
    endcase
  end

endmodule