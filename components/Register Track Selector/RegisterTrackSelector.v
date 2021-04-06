module regTS (
    input trackSelect,
    input rAlpha,
    input rBeta,
    input rGamma,
    output reg R1,
    output reg R2,
    output reg RW
);

  always @* begin
    if(trackSelect) begin
      R1 <= rBeta;
      R2 <= rGamma;
      RW <= rAlpha;
    end else begin
      R1 <= rAlpha;
      R2 <= rBeta;
      RW <= 0;// dont care
    end
  end

endmodule
