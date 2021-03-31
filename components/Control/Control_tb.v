`timescale 1ns / 1ps
`include "./Control.v"
module testbench ();


  initial begin,
    $dumpfile("./build/main.vcd");
    $dumpvars(0, testbench);
  end


  initial begin
    $finish;
  end


endmodule