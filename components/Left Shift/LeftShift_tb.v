`timescale 1ns / 1ps
`include "./LeftShift.v"
module testbench ();

  reg [63:0]in;
  wire [63:0]out;


  LeftShift #(.NUM_BITS(64)) uut (.in(in), .out(out));


  initial begin
    $dumpfile("./build/main.vcd");
    $dumpvars(0, testbench);
  end


  initial begin
    in <= 3;
    #10
    in <= -5;
    #10
    $finish;
  end


endmodule