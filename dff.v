module dff (
  input d,
  input clk,
  input reset,
  output reg q
);

always @ (posedge clk) begin
  if(!reset)
    q <= 0;
  else
    q <= d; 
end

  
endmodule