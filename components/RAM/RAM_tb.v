`timescale 1ns / 1ps
`include "./RAM.v"

module testbench ();

  reg clk;
  wire [63:0] dataOut;
  reg [63:0] dataIn;
  reg isReading;
  reg [10:0] address;

  integer c;


  initial begin
    $dumpfile("./build/main.vcd");
    $dumpvars(0, testbench);
    for (c = 1020; c < 1040; c = c + 1) begin
      $dumpvars(0, mem.ram_memory[c]);
    end
  end
  initial begin
    // Initialize Inputs
    address   = 0;
    isReading = 0;
    clk       = 0;
    dataIn    = 0;
    // Wait 100 ns for global reset to finish
    #100;

    // Now perform a write at address
    for (c = 0; c <= 1; c = c + 1) begin
      clk     <= c;
      address <= 11'd1024;
      dataIn  <= 64'hff04;
      isReading = 0;
      #100;
    end

    isReading = 1;
    dataIn <= 0;

    // Reads Data from the address right before the one we want
    for (c = 0; c <= 5; c = c + 1) begin
      clk     <= c;
      address <= 11'd1023;
      dataIn  <= 0;

      #100;
    end

    // Now perform a read on the address we wrote too
    for (c = 0; c <= 1; c = c + 1) begin
      clk     <= c;
      address <= 11'd1024;
      #100;
    end

    $finish;
  end

  // always #5 clk = !clk;

  // dff flip (.d(sig),.clk(clk),.reset(resetSIG), .q(qout));
  RAM mem (
      .address(address),
      .isReading(isReading),
      .clk(clk),
      .dataIn(dataIn),
      .dataOut(dataOut)
  );

endmodule
