module GenReg #(
    parameter WIDTH = 64
) (
    input clk,
    input isWriting,
    input reset,
    input [WIDTH-1:0] resetData,
    input [WIDTH-1:0] dataIn,
    output reg [WIDTH-1:0] dataOut
);


  always @(posedge reset) begin
    dataOut <= resetData;
  end

  always @(posedge clk) begin
    if (isWriting) begin
      dataOut <= dataIn;
    end
  end

  // initial begin
  //   dataOut <= 0;
  // end

endmodule
