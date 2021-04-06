module GenReg #(
    parameter WIDTH = 64
) (
    input clk,
    input [WIDTH-1:0] dataIn,
    output reg [WIDTH-1:0] dataOut
);

  always @(posedge clk) begin
    dataOut <= dataIn;
  end

endmodule
