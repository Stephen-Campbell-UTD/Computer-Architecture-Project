module dff (
  input d,
  input clk,
  input reset,
  output reg q
);

always @ (posedge clk or posedge reset) begin
  if(!reset)
    q <= d;
  else
    q <= 0; 
end

  
endmodule