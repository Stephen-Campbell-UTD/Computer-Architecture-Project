`timescale 1ns / 1ps
`include "./ram.v"
module testbench ();

  reg clk;
  wire [0:63] data;
  reg [0:63] driver;
  reg isReading;
  reg [10:0] address;

  integer c;

  assign data = isReading ? 64'bZ : driver;

  initial begin
    $dumpfile("./build/main.vcd");
    $dumpvars(0, testbench);
    for (c = 0; c < 2047; c = c + 1) begin
      $dumpvars(0, mem.ram_memory[c]);
    end
  end
  initial begin
    // Initialize Inputs
    address   = 0;
    isReading = 0;
    clk       = 0;
    driver    = 0;
    // Wait 100 ns for global reset to finish
    #100;

    // Now perform a write at address
    for (c = 0; c <= 1; c = c + 1) begin
      clk     <= c;
      address <= 11'd1024;
      driver  <= 64'hff04;
      isReading = 0;
      #100;
    end

    isReading = 1;

    // Reads Data from the address right before the one we want
    for (c = 0; c <= 5; c = c + 1) begin
      clk     <= c;
      address <= 11'd1023;
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
  ram mem (
      .address(address),
      .isReading(isReading),
      .clk(clk),
      .data(data)
  );

endmodule
