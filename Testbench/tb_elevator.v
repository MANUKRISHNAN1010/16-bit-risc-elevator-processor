`timescale 1ns/1ps
// Testbench with a simple elevator plant model (4 floors, 20 clock cycles of travel per floor).
module tb_elevator;
    reg clk = 0, rst = 1;
    reg [2:0] floor_request = 3'd1;
    reg emergency = 0;
    reg [2:0] current_floor = 3'd1;
    reg door_state = 0;                  // 1 = door physically open
    reg [4:0] cnt = 0;
    wire door_closed = ~door_state;
    wire motor_up, motor_down, motor_stop, door_open, door_close;
    wire [15:0] pc_out;
    integer errors = 0;
    elevator_processor_top dut
(.clk(clk), .rst(rst), .current_floor(current_floor), .floor_request(floor_request),
        .door_closed(door_closed), .emergency(emergency), .motor_up(motor_up), .motor_down(motor_down),
        .motor_stop(motor_stop), .door_open(door_open), .door_close(door_close), .pc_out(pc_out));
      always #5 clk = ~clk;
      // Plant model
      always @(posedge clk) begin
          door_state <= door_open;
          if (motor_up) begin
              if (cnt == 19) begin cnt <= 0; if (current_floor < 4) current_floor <= current_floor + 1; end
                else cnt <= cnt + 1;
            end else if (motor_down) begin
                if (cnt == 19) begin cnt <= 0; if (current_floor > 1) current_floor <= current_floor - 1; end
                else cnt <= cnt + 1;
            end else cnt <= 0;
      end
    always @(posedge clk) if (!rst) begin
        if (motor_up && motor_down) begin $display("ERROR: motor up and down together"); errors = errors + 1; end
        if ((motor_up || motor_down) && door_state) begin $display("ERROR: moving with door open");
errors = errors + 1; end
    end
      always @(motor_up or motor_down or door_open or current_floor)
        $display("t=%0t floor=%0d req=%0d UP=%b DOWN=%b STOP=%b DOOR_OPEN=%b", $time, current_floor,
floor_request, motor_up, motor_down, motor_stop, door_open);
    task goto_floor(input [2:0] f);
        begin
            floor_request = f;
            wait (current_floor == f && door_state == 1'b1);
            if (!motor_stop) begin $display("FAIL: motor not stopped at floor %0d", f); errors = errors + 1; end
            else $display("PASS: arrived at floor %0d, motor STOP, door OPEN", f);
            wait (door_state == 1'b0);
            repeat (3) @(posedge clk);
        end
    endtask
    initial begin
        $dumpfile("elevator.vcd"); $dumpvars(0, tb_elevator);
        repeat (3) @(posedge clk); #1 rst = 0;
        $display("--- TC1: same floor (1 -> 1)");   goto_floor(3'd1);
        $display("--- TC2: move up (1 -> 4)");      goto_floor(3'd4);
        $display("--- TC3: move down (4 -> 2)");    goto_floor(3'd2);
        $display("--- TC4: emergency while moving up (2 -> 4)");
        floor_request = 3'd4;
        wait (motor_up == 1'b1);
        wait (current_floor == 3'd3);
        emergency = 1'b1; @(posedge clk); #1;
        if (motor_up || motor_down) begin $display("FAIL: motor running during emergency"); errors = errors + 1; end
        else $display("PASS: emergency forces motor STOP");
        repeat (80) @(posedge clk);
        if (current_floor != 3'd3 || motor_up) begin $display("FAIL: moved during emergency"); errors = errors + 1; end
        emergency = 1'b0;
        wait (current_floor == 3'd4 && door_state == 1'b1);
        $display("PASS: resumed after emergency and arrived at floor 4");
        repeat (60) @(posedge clk);
        if (errors == 0) $display("ALL TESTS PASSED"); else $display("%0d ERRORS", errors);
        $finish;
    end
    initial begin #200000; $display("TIMEOUT"); $finish; end
endmodule
