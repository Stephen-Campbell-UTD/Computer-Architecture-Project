module RegisterFile (
    selA,
    selB,
    selWrite,
    writeIn,
    isReading,
    clk,
    outA,
    outB
);

  //Parameters and Ports
  parameter REG_ADDRESS_SIZE = 2;
  parameter NUM_REG = 2 ** REG_ADDRESS_SIZE;
  parameter MEM_WORD_SIZE = 64;

  input [REG_ADDRESS_SIZE-1:0] selA;
  input [REG_ADDRESS_SIZE-1:0] selB;
  input [REG_ADDRESS_SIZE-1:0] selWrite;
  input [MEM_WORD_SIZE-1:0] writeIn;
  input isReading;
  input clk;
  output [MEM_WORD_SIZE-1:0] outA;
  output [MEM_WORD_SIZE-1:0] outB;

  //Logic

  reg [MEM_WORD_SIZE-1:0] registers[NUM_REG-1:0];
  assign outA = registers[selA];

  initial begin : initialization
  integer i;
    for(i = 0; i < NUM_REG; i = i+1) begin
      registers[i] = {MEM_WORD_SIZE{1'b0}};
    end
    registers[2'b00] = {32{2'b10}};
  end




endmodule
