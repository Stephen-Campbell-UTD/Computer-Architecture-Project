`timescale 1ns / 1ps
`include "./multicycle.v"
module testbench ();

  reg clk;

  Multicycle mc(clk);


  parameter programMemStart = 'h400;  //1024;
  parameter dataMemStart = 'h000;  //1024;


  initial begin : simSetup
    integer c;

    $dumpfile("./build/main.vcd");
    $dumpvars(0, testbench);
    //dump data memory
    for (c = dataMemStart; c < dataMemStart + 24; c = c + 1) begin
      $dumpvars(0, mc.ram.ram_memory[c]);
    end
    //dump program memory
    for (c = programMemStart; c < programMemStart + 24; c = c + 1) begin
      $dumpvars(0, mc.ram.ram_memory[c]);
    end
    //dump register
    for (c = 0; c < 4; c = c + 1) begin
      $dumpvars(0, mc.registerFile.registers[c]);
    end
  end





    initial begin : add_sim
    integer c;
      integer i;
      clk <= 0;
      mc.pc.dataOut <= programMemStart;
      mc.control.state <= CS.INSTRUCTION_FETCH;
      //clear registers
    for (c = 0; c < 4; c = c + 1) begin
      mc.registerFile.registers[c] <= 0;
    end
      

      $readmemh("./memory/add_program.mem", mc.ram.ram_memory, programMemStart, programMemStart + 5 * 4 - 1);
      $readmemh("./memory/add_data.mem", mc.ram.ram_memory, dataMemStart, dataMemStart + 2 * 8 - 1);
      #5;

      // load + load + add + store + 1
      // 5 + 5 + 3 + 4 + 1
      for (i = 0; i < 18; i = i + 1) begin
        clk <= 1;
        #5;
        clk <= 0;
        #5;
      end

      $finish;
    end

  // initial begin : loop_sum_sim
  //   integer i;
  //   clk <= 0;
  //   mc.pc.dataOut <= programMemStart;
  //   mc.control.state <= CS.INSTRUCTION_FETCH;

  //   $readmemh("./memory/loop_sum_program.mem", mc.ram.ram_memory, programMemStart,
  //             programMemStart + 8 * 4 - 1);
  //   // $readmemh("./memory/loop_sum_data.mem", ram.ram_memory, dataMemStart, dataMemStart + 2 * 8 - 1);
  //   #5;

  //   // (starts at IF ) 3*loadi + branch + add + addi + jump
  //   // 3*3  + 3 + 4 + 4 + 3 -> 23
  //   for (i = 0; i < 170; i = i + 1) begin
  //     clk <= 1;
  //     #5;
  //     clk <= 0;
  //     #5;
  //   end

  //   $finish;
  // end




endmodule
