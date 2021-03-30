`timescale 1ns / 1ps
`include "./RegisterFile.v"

module testbench ();

  reg clk;
  reg [1:0] selA;
  reg [1:0] selB;
  reg [1:0] selWrite;
  reg [63:0] writeIn;
  reg isReading;
  wire [63:0] outA;
  wire [63:0] outB;

  RegisterFile uut (
      .clk(clk),
      .selA(selA),
      .selB(selB),
      .selWrite(selWrite),
      .writeIn(writeIn),
      .isReading(isReading),
      .outA(outA),
      .outB(outB)
  );

  initial begin
    $dumpfile("./build/main.vcd");
    $dumpvars(0, testbench);
  end

  always #5 clk <= ~clk;
  // always #5 selA <= {1'b0,~clk}; //for varying stimulus on selA

  initial begin : stimulus
    integer i;
    //global reset
    clk <= 0;
    selA <= 2'b00;
    selB <= 2'b00;
    selWrite <= 2'b00;
    writeIn <= 64'b0;
    isReading <= 1'b1;

    #4;
    //write to R1
    isReading <= 1'b0;
    selWrite  <= 2'b01;
    writeIn   <= {4{16'hAFED}};
    #10;
    //write to R2
    isReading <= 1'b0;
    selWrite  <= 2'b10;
    writeIn   <= {4{16'h0777}};
    #10;
    //read
    isReading <= 1'b1;
    selA <= 2'b01;
    selB <= 2'b10;
    #20;
    $finish;
  end
endmodule
