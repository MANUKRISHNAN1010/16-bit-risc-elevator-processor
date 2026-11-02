// 8 x 16-bit register file, R0 hard-wired to zero, two asynchronous read ports, one synchronous write port.
module register_file (
    input         clk, rst, we,
    input [2:0] ra1, ra2, wa,
     input [15:0] wd,
     output [15:0] rd1, rd2
);
    reg [15:0] regs [1:7];
    integer i;
    assign rd1 = (ra1 == 3'd0) ? 16'h0000 : regs[ra1];
    assign rd2 = (ra2 == 3'd0) ? 16'h0000 : regs[ra2];
    always @(posedge clk) begin
        if (rst) begin
            for (i = 1; i < 8; i = i + 1) regs[i] <= 16'h0000;
        end else if (we && wa != 3'd0)
            regs[wa] <= wd;
    end
endmodule
