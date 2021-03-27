module ram (
    input [10:0] address,
    input isReading,
    input clk,
    inout [0:63] data
);
  integer i;

  // NUM_ADDRESS x DATA_BUS_WIDTH bits 
  reg [0:63] ram_memory[2047:0];
  reg [0:63] data_private;

  initial begin
    for (i = 0; i < 2048; i = i + 1) begin
      ram_memory[i] = 64'b0;
    end
    data_private = 64'b0;
  end

  always @(posedge clk) begin
    if (isReading) data_private <= ram_memory[address];
    else ram_memory[address] <= data;
  end

  assign data = (isReading ? data_private : 64'bZ);

endmodule
