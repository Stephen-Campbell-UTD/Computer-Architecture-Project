module regTS (
    input trackSelect,
    input [1:0] rAlpha,
    input [1:0] rBeta,
    input [1:0] rGamma,
    output reg [1:0] R1,
    output reg [1:0] R2,
    output reg [1:0] RW
);

  always @* begin
    if (trackSelect) begin
      R1 <= rAlpha;
      R2 <= rBeta;
      RW <= 0;  // dont care
    end else begin
      R1 <= rBeta;
      R2 <= rGamma;
      RW <= rAlpha;
    end
  end

endmodule
