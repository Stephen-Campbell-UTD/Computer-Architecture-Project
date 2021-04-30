`include "opcodes.vh"
`include "ControlStates.vh"

module Control (
    input [5:0] opcode,
    input clk,
    //12 states -> 4 bits
    output reg [3:0] state
);


  initial begin
    state <= `INSTRUCTION_FETCH;
  end

  always @(posedge clk) begin
    case (state)
      `INSTRUCTION_FETCH: state <= `REGISTER_FETCH;
      `REGISTER_FETCH: begin
        casez (opcode)
          {`ALU_R_HEADER, 4'b????} : state <= `ALU_R3;
          {`ALU_RI_HEADER, 4'b????} : state <= `ALU_RI3;
          {`BRANCH_HEADER, 3'b???} : state <= `BRANCH3;
          {`MEMORY_REF_HEADER, 3'b???} : state <= `MEMORY_REF3;
          `JUMP: state <= `JUMP3;
          `LDI: state <= `IMMEDIATE_INJECTION3;
          default: begin
            $display("Somehow ended up at Register Fetch with bad opcode header");
          end
        endcase
      end
      `IMMEDIATE_INJECTION3: state <= `INSTRUCTION_FETCH;
      `ALU_R3: state <= `ALU4;
      `ALU_RI3: state <= `ALU4;
      `ALU4: state <= `INSTRUCTION_FETCH;
      `BRANCH3: state <= `INSTRUCTION_FETCH;
      `MEMORY_REF3: begin
        case (opcode)
          `LD:  state <= `LOAD4;
          `STR: state <= `STORE4;
          default: begin
            $display("Somehow ended up at Memory Ref with bad opcode header");
          end
        endcase
      end
      `LOAD4: state <= `LOAD5;
      `STORE4: state <= `INSTRUCTION_FETCH;
      `LOAD5: state <= `INSTRUCTION_FETCH;
      `JUMP3: state <= `INSTRUCTION_FETCH;
      default: begin
        $display("Somehow arrived at invalid control state");
      end
    endcase
  end

endmodule
