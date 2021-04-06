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
  parameter BYTE = 8;

  //memory is byte addressed and comes out big endian
  reg [BYTE-1:0] ram_memory[MEM_DEPTH-1:0];

  // assign data = (isReading ? data_private : {MEM_WORD_SIZE{1'bZ}});
  always @(posedge clk) begin
    if (isReading) begin
      dataOut <= {
        ram_memory[address],
        ram_memory[address+1],
        ram_memory[address+2],
        ram_memory[address+3],
        ram_memory[address+4],
        ram_memory[address+5],
        ram_memory[address+6],
        ram_memory[address+7]
      };
    end else begin
      ram_memory[address]   <= dataIn[MEM_WORD_SIZE-1:MEM_WORD_SIZE-BYTE];
      ram_memory[address+1] <= dataIn[MEM_WORD_SIZE-BYTE-1:MEM_WORD_SIZE-2*BYTE];
      ram_memory[address+2] <= dataIn[MEM_WORD_SIZE-2*BYTE-1:MEM_WORD_SIZE-3*BYTE];
      ram_memory[address+3] <= dataIn[MEM_WORD_SIZE-3*BYTE-1:MEM_WORD_SIZE-4*BYTE];
      ram_memory[address+4] <= dataIn[MEM_WORD_SIZE-4*BYTE-1:MEM_WORD_SIZE-5*BYTE];
      ram_memory[address+5] <= dataIn[MEM_WORD_SIZE-5*BYTE-1:MEM_WORD_SIZE-6*BYTE];
      ram_memory[address+6] <= dataIn[MEM_WORD_SIZE-6*BYTE-1:MEM_WORD_SIZE-7*BYTE];
      ram_memory[address+7] <= dataIn[MEM_WORD_SIZE-7*BYTE-1:MEM_WORD_SIZE-8*BYTE];
    end
  end

  initial begin : mem_initialization
    integer i;
    for (i = 0; i < MEM_DEPTH; i = i + 1) begin
      ram_memory[i] <= 0;
    end
    dataOut <= 0;
  end

endmodule
