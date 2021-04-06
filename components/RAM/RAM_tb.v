`timescale 1ns / 1ps
`include "./RAM.v"

module testbench ();

  wire [63:0] dataOut;
  reg [63:0] dataIn;
  reg isReading;
  reg [10:0] address;

  integer c;

  RAM mem (
      .address(address),
      .isReading(isReading),
      .dataIn(dataIn),
      .dataOut(dataOut)
  );


  initial begin
    $dumpfile("./build/main.vcd");
    $dumpvars(0, testbench);
    for (c = 1020; c < 1040; c = c + 1) begin
      $dumpvars(0, mem.ram_memory[c]);
    end
  end

  initial begin : mem_initialization
    integer i;
    for (i = 0; i < 2048; i = i + 1) begin
      mem.ram_memory[i] <= 0;
    end
    mem.dataOut <= 0;
  end
  initial begin
    // Initialize Inputs
    address   = 0;
    isReading = 0;
    dataIn    = 0;
    // Wait 100 ns for global reset to finish
    #100;

    // Now perform a write at address
    for (c = 0; c <= 1; c = c + 1) begin
      address <= 11'd1024;
      dataIn  <= 64'hff04;
      isReading = 0;
      #100;
    end

    isReading = 1;
    dataIn <= 0;

    // Reads Data from the address right before the one we want
    for (c = 0; c <= 5; c = c + 1) begin
      address <= 11'd1023;
      dataIn  <= 0;

      #100;
    end

    // Now perform a read on the address we wrote too
    for (c = 0; c <= 1; c = c + 1) begin
      address <= 11'd1024;
      #100;
    end

    $finish;
  end

  // always #5 clk = !clk;


endmodule
