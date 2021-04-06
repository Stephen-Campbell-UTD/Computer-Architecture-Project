module RAM (
    input [ADDRESS_SIZE-1:0] address,
    input isReading,
    input clk,
    input [MEM_WORD_SIZE-1:0] dataIn,
    output reg [MEM_WORD_SIZE-1:0] dataOut
);
  parameter ADDRESS_SIZE = 11;
  parameter MEM_DEPTH = 2 ** ADDRESS_SIZE;
  parameter MEM_WORD_SIZE = 64;


  reg [MEM_WORD_SIZE-1:0] ram_memory[MEM_DEPTH-1:0];

  // assign data = (isReading ? data_private : {MEM_WORD_SIZE{1'bZ}});
  always @(posedge clk) begin
    if (isReading) begin
      dataOut <= ram_memory[address];
    end else begin
      ram_memory[address] <= dataIn;
    end
  end

  initial begin : mem_initialization
    integer i;
    for (i = 0; i < MEM_DEPTH; i = i + 1) begin
      ram_memory[i] = {MEM_WORD_SIZE{1'b0}};
    end
    dataOut <= 0;
  end

endmodule
