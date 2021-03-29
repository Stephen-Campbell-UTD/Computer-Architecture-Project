`timescale 1ns / 1ps
`include "./RegisterFile.v"

module testbench ();

  reg clk;
  wire [63:0] outA;
  wire [63:0] outB;

  RegisterFile mem (
      .clk(clk),
      .selA(2'b00),
      .selB(2'b00),
      .selWrite(2'b00),
      .writeIn(64'b0),
      .isReading(1'b1),
      .outA(outA),
      .outB(outB)
  );

  initial begin
    $dumpfile("./build/main.vcd");
    $dumpvars(0, testbench);
  end

  initial begin : initialization
    integer i;
    for( i = 0; i <= 10; i = i + 1) begin
      clk <= i;
      #10;
    end
    $finish;
  end



endmodule
