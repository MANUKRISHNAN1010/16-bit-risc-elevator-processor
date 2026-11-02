// Main decoder: opcode -> datapath control signals.
module control_unit (
    input [3:0] opcode,
    output reg   reg_write, alu_src, mem_read, mem_write,
    output reg   branch_eq, branch_ne, branch_lt, jump, wb_sel,
    output reg [2:0] alu_ctrl
);
    always @(*) begin
        reg_write = 0; alu_src = 0; mem_read = 0; mem_write = 0;
        branch_eq = 0; branch_ne = 0; branch_lt = 0; jump = 0;
        wb_sel = 0; alu_ctrl = 3'b000;
        case (opcode)
            4'h0: begin reg_write = 1; alu_ctrl = 3'b000; end                       // ADD
            4'h1: begin reg_write = 1; alu_ctrl = 3'b001; end                       // SUB
            4'h2: begin reg_write = 1; alu_ctrl = 3'b010; end                       // AND
            4'h3: begin reg_write = 1; alu_ctrl = 3'b011; end                       // OR
            4'h4: begin reg_write = 1; alu_ctrl = 3'b100; end                       // XOR
            4'h5: begin reg_write = 1; alu_src = 1; end                             // ADDI
            4'h6: begin reg_write = 1; alu_src = 1; mem_read = 1; wb_sel = 1; end   // LW
            4'h7: begin alu_src = 1; mem_write = 1; end                             // SW
            4'h8: begin branch_eq = 1; alu_ctrl = 3'b001; end                       // BEQ
            4'h9: begin branch_ne = 1; alu_ctrl = 3'b001; end                       // BNE
            4'hA: begin branch_lt = 1; alu_ctrl = 3'b001; end                       // BLT
            4'hB: begin jump = 1; end                                               // JMP
            default: ;                                                              // NOP
        endcase
    end
endmodule
