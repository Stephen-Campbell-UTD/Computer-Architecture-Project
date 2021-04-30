`ifndef OPCODES_VH
`define OPCODES_VH 


//intermediate logic operation bits
`define EQ_FOOTER 3'd2
`define NEQ_FOOTER 3'd3 
`define LT_FOOTER 3'd4
`define LE_FOOTER 3'd5
`define GT_FOOTER 3'd6
`define GE_FOOTER 3'd7


// ALU has bit bit opcode
`define ALU_ADD 4'd0
`define ALU_SUB 4'd1
`define ALU_MUL 4'd2
`define ALU_SL 4'd3
`define ALU_DIV 4'd4
`define ALU_MOD 4'd5
`define ALU_NOT 4'd6
`define ALU_OR 4'd7
`define ALU_AND 4'd8
`define ALU_XOR 4'd9
`define ALU_EQ {1'b1, `EQ_FOOTER}
`define ALU_NEQ {1'b1, `NEQ_FOOTER}
`define ALU_LT {1'b1, `LT_FOOTER}
`define ALU_LE {1'b1, `LE_FOOTER}
`define ALU_GT {1'b1, `GT_FOOTER}
`define ALU_GE {1'b1, `GE_FOOTER}


`define ALU_R_HEADER 2'b00
`define ALU_RI_HEADER 2'b01
`define BRANCH_HEADER 3'b100
`define MEMORY_REF_HEADER 3'b101

//one off instructions
`define LDI 6'b111111
`define JUMP 6'b110000

//ALU R Type instructions
`define ADD {`ALU_R_HEADER, `ALU_ADD}
`define SUB {`ALU_R_HEADER, `ALU_SUB}
`define MUL {`ALU_R_HEADER, `ALU_MUL}
`define DIV {`ALU_R_HEADER, `ALU_DIV}
`define MOD {`ALU_R_HEADER, `ALU_MOD}
`define AND {`ALU_R_HEADER, `ALU_AND}
`define OR {`ALU_R_HEADER, `ALU_OR}
`define NOT {`ALU_R_HEADER, `ALU_NOT}
`define XOR {`ALU_R_HEADER, `ALU_XOR}
`define SL {`ALU_R_HEADER, `ALU_SL}

//ALU RI Type instructions
`define ADDI {`ALU_RI_HEADER, `ALU_ADD}
`define SUBI {`ALU_RI_HEADER, `ALU_SUB}
`define MULI {`ALU_RI_HEADER, `ALU_MUL}
`define DIVI {`ALU_RI_HEADER, `ALU_DIV}
`define MODI {`ALU_RI_HEADER, `ALU_MOD}
`define ANDI {`ALU_RI_HEADER, `ALU_AND}
`define ORI {`ALU_RI_HEADER, `ALU_OR}
`define NOTI {`ALU_RI_HEADER, `ALU_NOT}
`define XORI {`ALU_RI_HEADER, `ALU_XOR}
`define SLI {`ALU_RI_HEADER, `ALU_SL}

//Branch instructions
`define BEQ {`BRANCH_HEADER, `EQ_FOOTER }
`define BNEQ {`BRANCH_HEADER, `NEQ_FOOTER}
`define BLT {`BRANCH_HEADER, `LT_FOOTER }
`define BLEQ {`BRANCH_HEADER, `LE_FOOTER }
`define BGT {`BRANCH_HEADER, `GT_FOOTER }
`define BGEQ {`BRANCH_HEADER, `GE_FOOTER }

//Memory Reference Instructions
`define LD {`MEMORY_REF_HEADER, 3'b000}
`define STR {`MEMORY_REF_HEADER, 3'b100}


`endif
