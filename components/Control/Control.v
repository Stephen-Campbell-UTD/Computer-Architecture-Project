`ifndef MULTICYCLE
`include "./ControlStates.v"
`include "../../multicycle/opcodes.v"
`endif

module Control (
    input [5:0] opcode,
    input clk,
    //12 states -> 4 bits
    output reg [3:0] state
);


  initial begin
    state <= CS.INSTRUCTION_FETCH;
  end

  always @(posedge clk) begin
    case (state)
      CS.INSTRUCTION_FETCH: begin
        case (opcode)
          OP.LDI:  state <= CS.IMMEDIATE_INJECTION2;
          default: state <= CS.REGISTER_FETCH;
        endcase
      end
      CS.REGISTER_FETCH: begin
        casez (opcode[5:3])
          {OP.ALU_R_HEADER, 1'b?} : state <= CS.ALU_R3;
          {OP.ALU_RI_HEADER, 1'b?} : state <= CS.ALU_RI3;
          OP.BRANCH_HEADER: state <= CS.BRANCH3;
          OP.MEMORY_REF_HEADER: state <= CS.MEMORY_REF3;
          OP.JUMP[5:3]: state <= CS.JUMP3;
          default: begin
            $display("Somehow ended up at Register Fetch with bad opcode header");
          end
        endcase
      end
      CS.IMMEDIATE_INJECTION2: state <= CS.INSTRUCTION_FETCH;
      CS.ALU_R3: state <= CS.ALU4;
      CS.ALU_RI3: state <= CS.ALU4;
      CS.ALU4: state <= CS.INSTRUCTION_FETCH;
      CS.BRANCH3: state <= CS.INSTRUCTION_FETCH;
      CS.MEMORY_REF3: begin
        case (opcode[2])
          OP.LD[2]:  state <= CS.LOAD4;
          OP.STR[2]: state <= CS.STORE4;
          default: begin
            $display("Somehow ended up at Register Fetch with bad opcode header");
          end
        endcase
      end
      CS.LOAD4: state <= CS.LOAD5;
      CS.STORE4: state <= CS.INSTRUCTION_FETCH;
      CS.LOAD5: state <= CS.INSTRUCTION_FETCH;
      CS.JUMP3: state <= CS.INSTRUCTION_FETCH;
      default: begin
        $display("Somehow arrived at invalid control state");
      end
    endcase
  end

endmodule
