`timescale 1ns / 1ps
`define IMPL
`include "./top.v"
`include "../multicycle/opcodes.v"
module testbench ();


  initial begin
    $dumpfile("./build/main.vcd");
    $dumpvars(0, testbench);
  end

  reg reset;
  reg [7:0] debugAddress;

  wire [3:0] controlStateOutside;

  top tp (
      .PIN_13(reset),
      .PIN_1 (debugAddress[0]),
      .PIN_2 (debugAddress[1]),
      .PIN_3 (debugAddress[2]),
      .PIN_4 (debugAddress[3]),
      .PIN_5 (debugAddress[4]),
      .PIN_6 (debugAddress[5]),
      .PIN_7 (debugAddress[6]),
      .PIN_8 (debugAddress[7]),
      .PIN_9 (controlStateOutside[0]),
      .PIN_10(controlStateOutside[1]),
      .PIN_11(controlStateOutside[2]),
      .PIN_12(controlStateOutside[3])
  );


  initial begin : topSim
    integer i;
    reset <= 0;
    debugAddress <= 7;
    tp.clkCounter[22] <= 0;
    #5;
    reset <= 1;
    #5;
    reset <= 0;
    tp.clkCounter[22] <= 1;
    #10;
    for (i = 0; i < 18; i = i + 1) begin
      tp.clkCounter[22] <= 0;
      #10;
      tp.clkCounter[22] <= 1;
      #10;
    end

    $finish;
  end


endmodule
