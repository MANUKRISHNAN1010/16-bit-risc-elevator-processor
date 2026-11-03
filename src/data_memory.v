// 64 x 16-bit data RAM (word addressed via address bits [6:1]).
module data_memory (
    input         clk, we,
    input [15:0] addr, wdata,
    output [15:0] rdata
);
    reg [15:0] mem [0:63];
    integer i;
    initial for (i = 0; i < 64; i = i + 1) mem[i] = 16'h0000;
    assign rdata = mem[addr[6:1]];
    always @(posedge clk) if (we) mem[addr[6:1]] <= wdata;
endmodule
