// 16-bit ALU: ADD, SUB, AND, OR, XOR. Zero and signed-less-than flags feed the branch logic.
module alu (
    input [15:0] a, b,
    input [2:0] alu_ctrl,
    output reg [15:0] result,
    output         zero,
    output         lt
);
    always @(*) begin
        case (alu_ctrl)
             3'b000: result = a + b;
             3'b001: result = a - b;
             3'b010: result = a & b;
             3'b011: result = a | b;
             3'b100: result = a ^ b;
             default: result = 16'h0000;
        endcase
    end
    assign zero = (result == 16'h0000);
    assign lt    = ($signed(a) < $signed(b));
endmodule
