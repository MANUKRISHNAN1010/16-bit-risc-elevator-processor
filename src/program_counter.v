module program_counter (
    input         clk, rst,
    input [15:0] pc_next,
    output reg [15:0] pc
);
    always @(posedge clk) begin
        if (rst) pc <= 16'h0000;
        else     pc <= pc_next;
    end
endmodule
