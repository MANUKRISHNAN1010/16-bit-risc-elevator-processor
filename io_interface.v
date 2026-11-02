// Memory-mapped I/O block (addresses 0x00-0x1F).
// 0x00 current floor | 0x02 requested floor | 0x04 door sensor (1=closed) | 0x06 emergency
// 0x08 motor command (00 stop, 01 up, 10 down) | 0x0A door command (1 = open)
module io_interface (
    input         clk, rst, we,
    input [15:0] addr, wdata,
    input [2:0] current_floor, floor_request,
    input         door_closed, emergency,
    output reg [15:0] rdata,
    output reg [1:0] motor_cmd,
    output reg        door_cmd
);
    always @(*) begin
        case (addr[4:1])
            4'h0: rdata = {13'b0, current_floor};
            4'h1: rdata = {13'b0, floor_request};
            4'h2: rdata = {15'b0, door_closed};
            4'h3: rdata = {15'b0, emergency};
            4'h4: rdata = {14'b0, motor_cmd};
            4'h5: rdata = {15'b0, door_cmd};
            default: rdata = 16'h0000;
        endcase
    end
    always @(posedge clk) begin
        if (rst) begin motor_cmd <= 2'b00; door_cmd <= 1'b0; end
        else if (we) begin
            case (addr[4:1])
                4'h4: motor_cmd <= wdata[1:0];
                4'h5: door_cmd <= wdata[0];
                default: ;
            endcase
        end
    end
endmodule
