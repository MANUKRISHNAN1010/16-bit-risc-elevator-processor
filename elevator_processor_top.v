// Top level: single-cycle 16-bit RISC processor + memory-mapped I/O + elevator control logic.
module elevator_processor_top (
    input        clk, rst,
    input [2:0] current_floor, floor_request,
    input        door_closed, emergency,
    output       motor_up, motor_down, motor_stop, door_open, door_close,
    output [15:0] pc_out
);
    wire [15:0] pc, pc_next, instr, rd1, rd2, alu_b, alu_result, dmem_rdata, ram_rdata, io_rdata, wd;
    wire [3:0] opcode = instr[15:12];
    wire        reg_write, alu_src, mem_read, mem_write, branch_eq, branch_ne, branch_lt, jump, wb_sel;
    wire [2:0] alu_ctrl;
    wire        zero, lt;
    wire [1:0] motor_cmd;
    wire        door_cmd;
   assign pc_out = pc;
   wire is_branch = branch_eq | branch_ne | branch_lt;
   wire [2:0] ra1 = is_branch ? instr[11:9] : instr[8:6];
   wire [2:0] ra2 = mem_write ? instr[11:9] : (is_branch ? instr[8:6] : instr[5:3]);
   wire [2:0] wa = instr[11:9];
   wire [15:0] imm = {{10{instr[5]}}, instr[5:0]};
    program_counter u_pc (.clk(clk), .rst(rst), .pc_next(pc_next), .pc(pc));
    instruction_memory u_im (.pc(pc), .instr(instr));
    control_unit     u_cu
(.opcode(opcode), .reg_write(reg_write), .alu_src(alu_src), .mem_read(mem_read),
                            .mem_write(mem_write), .branch_eq(branch_eq), .branch_ne(branch_ne),
                            .branch_lt(branch_lt), .jump(jump), .wb_sel(wb_sel), .alu_ctrl(alu_ctrl));
    register_file    u_rf (.clk(clk), .rst(rst), .we(reg_write), .ra1(ra1), .ra2(ra2), .wa(wa),
                            .wd(wd), .rd1(rd1), .rd2(rd2));
    assign alu_b = alu_src ? imm : rd2;
    alu              u_alu
(.a(rd1), .b(alu_b), .alu_ctrl(alu_ctrl), .result(alu_result), .zero(zero), .lt(lt));
    // Address decode: addresses below 0x20 are memory-mapped I/O, the rest is data RAM
    wire io_sel = (alu_result[15:5] == 11'b0);
    data_memory      u_dm (.clk(clk), .we(mem_write &
~io_sel), .addr(alu_result), .wdata(rd2), .rdata(ram_rdata));
    io_interface     u_io (.clk(clk), .rst(rst), .we(mem_write &
io_sel), .addr(alu_result), .wdata(rd2),
                            .current_floor(current_floor), .floor_request(floor_request),
                            .door_closed(door_closed), .emergency(emergency),
                            .rdata(io_rdata), .motor_cmd(motor_cmd), .door_cmd(door_cmd));
    assign dmem_rdata = io_sel ? io_rdata : ram_rdata;
    assign wd = wb_sel ? dmem_rdata : alu_result;
   elevator_control u_ec   (.motor_cmd(motor_cmd), .door_cmd(door_cmd), .door_closed(door_closed),
                            .emergency(emergency), .motor_up(motor_up), .motor_down(motor_down),
                            .motor_stop(motor_stop), .door_open(door_open), .door_close(door_close));
    // Next-PC logic
    wire branch_taken = (branch_eq & zero) | (branch_ne & ~zero) | (branch_lt & lt);
    wire [15:0] pc_plus2      = pc + 16'd2;
    wire [15:0] branch_target = pc_plus2 + {imm[14:0], 1'b0};
    wire [15:0] jump_target   = {3'b000, instr[11:0], 1'b0};
    assign pc_next = jump ? jump_target : (branch_taken ? branch_target : pc_plus2);
endmodule
