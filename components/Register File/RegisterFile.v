module RegisterFile (
    input [REG_ADDRESS_SIZE-1:0] selA,
    input [REG_ADDRESS_SIZE-1:0] selB,
    input [REG_ADDRESS_SIZE-1:0] selWrite,
    input [MEM_WORD_SIZE-1:0] writeIn,
    input isReading,
    input clk,
    output reg [MEM_WORD_SIZE-1:0] outA,
    output reg [MEM_WORD_SIZE-1:0] outB
);

  //Parameters 
  parameter REG_ADDRESS_SIZE = 2;
  parameter NUM_REG = 2 ** REG_ADDRESS_SIZE;
  parameter MEM_WORD_SIZE = 64;


  //Logic

  reg [MEM_WORD_SIZE-1:0] registers[NUM_REG-1:0];

  always @(posedge clk) begin
    if (isReading) begin  
      outA <= registers[selA];
      outB <= registers[selB];
    end else begin //writing
      registers[selWrite] <= writeIn;
    end
  end



  //Sim
  initial begin : initialization
    integer i;
    for (i = 0; i < NUM_REG; i = i + 1) begin
      registers[i] = {MEM_WORD_SIZE{1'b0}};
    end
      outA <= {MEM_WORD_SIZE{1'b0}};
      outB <= {MEM_WORD_SIZE{1'b0}};
  end




endmodule
