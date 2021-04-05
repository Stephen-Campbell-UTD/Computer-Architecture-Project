`timescale 1ns / 1ps
`include "./ID.v"
module testbench ();


  reg [19:0] in;

  InstructionDecode uut (.instruction(in));

  //specific to open source tools that I am using
  initial begin
    $dumpfile("./build/main.vcd");
    $dumpvars(0, testbench);
  end


  initial begin
    //ALU R Type
    // OP R2 R3 R1
    in <= {6'b0, 2'd2, 2'd3, 2'd1, 8'b0};
    #10;
    //ALU R I Type / Branch (small immediate) / Load /Store
    in <= {6'b010101, 2'd0, 2'd2, 10'h0A8};
    #10;
    //Immediate Injection (mov RD imm)
    in <= {6'b101010, 2'd2, 12'hFB8};
    #10;
    //Jump
    in <= {6'b100000, 11'h0C3, 3'b0};
    #10;
    $finish;
  end


endmodule
