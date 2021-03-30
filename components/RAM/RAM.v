module RAM (
  input [ADDRESS_SIZE-1:0] address,
  input isReading,
  input clk,
  inout [MEM_WORD_SIZE-1:0] data
);
  parameter ADDRESS_SIZE = 11;
  parameter MEM_DEPTH = 2 ** ADDRESS_SIZE;
  parameter MEM_WORD_SIZE = 63;


  reg [MEM_WORD_SIZE-1:0] ram_memory[MEM_DEPTH-1:0];
  reg [MEM_WORD_SIZE-1:0] data_private;

  assign data = (isReading ? data_private : {MEM_WORD_SIZE{1'bZ}});
  always @(posedge clk) begin
    if (isReading) data_private <= ram_memory[address];
    else ram_memory[address] <= data;
  end

  initial begin : mem_initialization
    integer i;
    for (i = 0; i < MEM_DEPTH; i = i + 1) begin
      ram_memory[i] = {MEM_WORD_SIZE{1'b0}};
    end
    data_private = {MEM_WORD_SIZE{1'b0}};
  end

endmodule
