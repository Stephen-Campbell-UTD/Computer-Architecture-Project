module SignExtender #(
    parameter NUM_IN_BITS  = 0,
    parameter NUM_OUT_BITS = 64
) (
    input [NUM_IN_BITS-1:0] in,
    output reg [NUM_OUT_BITS-1:0] out
);

  parameter extraBits = NUM_OUT_BITS - NUM_IN_BITS;
  always @* begin
    out <= {{extraBits{in[NUM_IN_BITS-1]}}, in};
  end
endmodule
