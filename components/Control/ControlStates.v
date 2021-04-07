`ifndef CONTROL_STATES_V
`define CONTROL_STATES_V 
module CS ();
  //12 states -> 4 bits
  parameter INSTRUCTION_FETCH = 4'd0;
  parameter REGISTER_FETCH = 4'd1;
  parameter IMMEDIATE_INJECTION3 = 4'd2;
  parameter ALU_R3 = 4'd3;
  parameter ALU_RI3 = 4'd4;
  parameter ALU4 = 4'd5;
  parameter BRANCH3 = 4'd6;
  parameter MEMORY_REF3 = 4'd7;
  parameter LOAD4 = 4'd8;
  parameter STORE4 = 4'd9;
  parameter LOAD5 = 4'd10;
  parameter JUMP3 = 4'd11;
endmodule
`endif
