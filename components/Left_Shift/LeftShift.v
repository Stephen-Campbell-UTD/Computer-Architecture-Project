module LeftShift #(
    parameter NUM_BITS = 64
) (
    input  [NUM_BITS-1:0] in,
    output [NUM_BITS-1:0] out
);
  assign out = in << 2;

endmodule
