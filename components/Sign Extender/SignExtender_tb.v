`timescale 1ns / 1ps
`include "./SignExtender.v"
module testbench ();

  reg  [10:0] in;
  wire [63:0] out;
  SignExtender #(
      .NUM_IN_BITS (11),
      .NUM_OUT_BITS(64)
  ) uut (
      .in (in),
      .out(out)
  );

  initial begin
    $dumpfile("./build/main.vcd");
    $dumpvars(0, testbench);
  end

  initial begin
    in <= 0;  // 0 -> 0
    #10;
    in <= 11'h0FF;  // 255 -> 255
    #10;
    in <= 11'h7FF;  //-1 -> ALL Fs
    #10;
    $finish;
  end

endmodule
