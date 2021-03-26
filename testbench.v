`timescale 1ns/10ps
module testbench  ();

  reg clk;
  reg sig;
  wire qout;
  reg resetSIG;

  initial begin 
    $dumpfile("./build/main.vcd");
    $dumpvars(0,testbench);
    //Setup Clock
    clk = 0;
    resetSIG = 0;
    sig = 0;
    //Reset Signals
    #1 resetSIG = 1;
    #1 resetSIG = 0;
    #1;
    //
    sig = 1;
    #4;
    sig = 0;
    #20;
    $finish;
  end

  always #5 clk = !clk;
  // assign resetSIG = 0;

  dff flip (.d(sig),.clk(clk),.reset(resetSIG), .q(qout));

endmodule