// Decodes command registers into drive signals and enforces hardware safety interlocks:
// - emergency or door-not-closed forces the motor off
// - the door can only be commanded open while the motor is off
module elevator_control (
    input [1:0] motor_cmd,
    input        door_cmd, door_closed, emergency,
    output       motor_up, motor_down, motor_stop, door_open, door_close
);
    wire safe = ~emergency & door_closed;
    assign motor_up   = (motor_cmd == 2'b01) & safe;
    assign motor_down = (motor_cmd == 2'b10) & safe;
    assign motor_stop = ~(motor_up | motor_down);
    assign door_open = door_cmd & motor_stop;
    assign door_close = ~door_open;
endmodule
