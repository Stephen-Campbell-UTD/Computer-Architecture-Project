module RAM (
    input [ADDRESS_SIZE-1:0] address,
    input [ADDRESS_SIZE-1:0] debugAddress,
    output reg [7:0] debugOut,
    input isReading,
    input reset,
    input [MEM_WORD_SIZE-1:0] dataIn,
    output reg [MEM_WORD_SIZE-1:0] dataOut
);
  parameter ADDRESS_SIZE = 11;
  parameter MEM_DEPTH = 2 ** ADDRESS_SIZE;
  parameter MEM_WORD_SIZE = 64;
  parameter BYTE = 8;

  //memory is byte addressed and comes out big endian
  reg [BYTE-1:0] ram_memory[0:MEM_DEPTH-1];


  parameter programMemStart = 24;
  parameter dataMemStart = 0;
  always @(posedge reset) begin
    $readmemh("./memory/add_program.mem", ram_memory, programMemStart, programMemStart + 5 * 4 - 1);
    $readmemh("./memory/add_data.mem", ram_memory, dataMemStart, dataMemStart + 2 * 8 - 1);
    // $readmemh("./memory/debug.mem", ram_memory, 0, 10 * 8 - 1);
  end

  always @* begin
    debugOut <= ram_memory[debugAddress];
  end

  always @* begin
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


endmodule
