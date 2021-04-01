`timescale 1ns / 1ps
`include "./opcodes.v"
module testbench ();

  reg [5:0] myreg;
  initial begin
    $dumpfile("./build/main.vcd");
    $dumpvars(0, testbench);
  end


  initial begin
    myreg <= 0;
    #10 myreg <= OP.LDI;
    #10 $finish;
  end


endmodule
