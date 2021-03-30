module Mux2 #(
    parameter BUS_BITS = 64
) (
    input [BUS_BITS-1:0] in1,
    input [BUS_BITS-1:0] in2,
    input sel,
    output reg [BUS_BITS-1:0] out
);


  always @* begin
    case (sel)
      0: out <= in1;
      1: out <= in2;
    endcase
  end

endmodule
