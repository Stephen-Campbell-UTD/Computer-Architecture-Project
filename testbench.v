`timescale 1ns/1ps
module testbench  ();

  reg clk;
  // reg sig;

  initial begin 
   $dumpfile("./build/main.vcd");
   $dumpvars(0,testbench);
   clk =0;
   #20; 
   $finish;
  end

  always #5 clk = !clk;
  // wire qout;
  // wire resetSIG;
  // assign resetSIG = 0;

  // dff flip (.d(sig),.clk(clk),.reset(resetSIG), .q(qout));

endmodule