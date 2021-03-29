module RAM (
    address,
    isReading,
    clk,
    data
);
  parameter ADDRESS_SIZE = 11;
  parameter MEM_DEPTH = 2 ** ADDRESS_SIZE;
  parameter MEM_WORD_SIZE = 64;

  input [ADDRESS_SIZE-1:0] address;
  input isReading;
  input clk;
  inout [MEM_WORD_SIZE-1:0] data;

  // NUM_ADDRESS x DATA_BUS_WIDTH bits
  reg [MEM_WORD_SIZE-1:0] ram_memory[MEM_DEPTH-1:0];
  reg [MEM_WORD_SIZE-1:0] data_private;

  initial begin : mem_initialization
    integer i;
    for (i = 0; i < MEM_DEPTH; i = i + 1) begin
      ram_memory[i] = {MEM_WORD_SIZE{1'b0}};
    end
    data_private = {MEM_WORD_SIZE{1'b0}};
  end

  always @(posedge clk) begin
    if (isReading) data_private <= ram_memory[address];
    else ram_memory[address] <= data;
  end

  assign data = (isReading ? data_private : {MEM_WORD_SIZE{1'bZ}});

endmodule
