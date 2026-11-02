v
// Instruction memory: 128 x 16-bit ROM, program assembled from the elevator controller source.
module instruction_memory (
    input [15:0] pc,
    output [15:0] instr
);
    reg [15:0] mem [0:127];
    integer i;
    initial begin
        for (i = 0; i < 128; i = i + 1) mem[i] = 16'hF000; // NOP
        mem[0] = 16'h6806; // 00: LW    R4, R0, 6
        mem[1] = 16'h980C; // 02: BNE R4, R0, hold
        mem[2] = 16'h6604; // 04: LW    R3, R0, 4
        mem[3] = 16'h860A; // 06: BEQ R3, R0, hold
        mem[4] = 16'h6200; // 08: LW    R1, R0, 0
        mem[5] = 16'h6402; // 0A: LW    R2, R0, 2
        mem[6] = 16'h8289; // 0C: BEQ R1, R2, arrive
        mem[7] = 16'hA283; // 0E: BLT R1, R2, up
        mem[8] = 16'h5A02; // 10: ADDI R5, R0, 2
        mem[9] = 16'h7A08; // 12: SW    R5, R0, 8
        mem[10] = 16'hB000; // 14: JMP start
        mem[11] = 16'h5A01; // 16: ADDI R5, R0, 1
        mem[12] = 16'h7A08; // 18: SW    R5, R0, 8
        mem[13] = 16'hB000; // 1A: JMP start
        mem[14] = 16'h7008; // 1C: SW    R0, R0, 8
        mem[15] = 16'hB000; // 1E: JMP start
        mem[16] = 16'h7008; // 20: SW    R0, R0, 8
        mem[17] = 16'h5A01; // 22: ADDI R5, R0, 1
        mem[18] = 16'h7A0A; // 24: SW    R5, R0, 10
        mem[19] = 16'h5C1E; // 26: ADDI R6, R0, 30
        mem[20] = 16'h5DBF; // 28: ADDI R6, R6, -1
        mem[21] = 16'h9C3E; // 2A: BNE R6, R0, dwell
        mem[22] = 16'h700A; // 2C: SW    R0, R0, 10
        mem[23] = 16'h6402; // 2E: LW    R2, R0, 2
        mem[24] = 16'h82BE; // 30: BEQ R1, R2, idle
        mem[25] = 16'hB000; // 32: JMP start
    end
    assign instr = mem[pc[7:1]];
endmodule
