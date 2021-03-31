`timescale 1ns / 1ps
`include "./Mux2.v"
`include "./Mux4.v"
module testbench ();

  reg [63:0] in1;
  reg [63:0] in2;
  reg [63:0] in3;
  reg [63:0] in4;
  reg [1:0] sel;
  wire [63:0] out;

  // Mux2 #(
  //     .BUS_BITS(64)
  // ) uut (
  //     .in1(in1),
  //     .in2(in2),
  //     .sel(sel),
  //     .out(out)
  // );
  Mux4 #(
      .BUS_BITS(64)
  ) uut (
      .in1(in1),
      .in2(in2),
      .in3(in3),
      .in4(in4),
      .sel(sel),
      .out(out)
  );

  initial begin
    $dumpfile("./build/main.vcd");
    $dumpvars(0, testbench);
  end


  initial begin
    sel <= 0;
    in1 <= 1;
    in2 <= 2;
    in3 <= 3;
    in4 <= 4;
    #10;
    sel <= 0;
    #10;
    sel <= 1;
    #10;
    sel <= 2;
    #10;
    sel <= 3;
    #10;
    $finish;
  end


endmodule
