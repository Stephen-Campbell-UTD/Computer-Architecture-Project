`timescale 1ns / 1ps
`include "./Mux2.v"
module testbench ();

  reg [63:0] in1;
  reg [63:0] in2;
  reg sel;
  wire [63:0] out;

  Mux2 #(
      .BUS_BITS(64)
  ) uut (
      .in1(in1),
      .in2(in2),
      .sel(sel),
      .out(out)
  );

  initial begin
    $dumpfile("./build/main.vcd");
    $dumpvars(0, testbench);
  end


  initial begin
    sel <= 0;
    in1 <= 0;
    in2 <= 0;
    #10;
    in1 <= 64;
    in2 <= 45;
    sel <= 0;
    #10;
    sel <= 1;
    #10;
    $finish;
  end


endmodule
