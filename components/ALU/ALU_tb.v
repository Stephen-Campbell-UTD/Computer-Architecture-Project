`timescale 1ns / 1ps
`include "./ALU.v"

module testbench ();

  reg  [63:0] A;
  reg  [63:0] B;
  reg  [ 3:0] op;
  wire [63:0] out;

  ALU uut (
      .A  (A),
      .B  (B),
      .op (op),
      .out(out)
  );

  initial begin
    $dumpfile("./build/main.vcd");
    $dumpvars(0, testbench);
  end


  initial begin : initialization
    //global reset
    A  <= 0;
    B  <= 0;
    op <= 0;
    #10;
    //base case add
    A  <= 1;
    B  <= 4;
    op <= 0;
    #10;
    //add negative
    A  <= 2;
    B  <= {64{1'b1}};  //-1
    op <= 0;
    #10;
    //subtract
    A  <= 2;
    B  <= 3;
    op <= 1;
    #10;
    //equality case equal
    A  <= 2;
    B  <= 2;
    op <= 4;
    #10;
    //equality case not equal
    A  <= 2;
    B  <= 3;
    op <= 4;
    #10;

    $finish;

  end

endmodule

