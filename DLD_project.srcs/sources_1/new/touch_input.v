`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/25/2026 11:11:39 AM
// Design Name: 
// Module Name: touch_input
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module touch_input(
    input clk,
    input reset,
    input touch_in,     // raw TTP223 output
    output reg touch_pulse
);

reg touch_prev;

always @(posedge clk) begin
    if (reset) begin
        touch_prev <= 0;
        touch_pulse <= 0;
    end else begin
        touch_prev <= touch_in;

        // Rising edge detection
        if (touch_in && !touch_prev)
            touch_pulse <= 1;
        else
            touch_pulse <= 0;
    end
end

endmodule
