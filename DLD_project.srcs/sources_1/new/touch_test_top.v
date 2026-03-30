`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/25/2026 11:15:13 AM
// Design Name: 
// Module Name: touch_test_top
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


module touch_test_top(
    input clk,
    input reset,
    input touch_in,
    output reg led
);

reg touch_prev;

always @(posedge clk) begin
    if (reset) begin
        touch_prev <= 0;
        led <= 0;
    end else begin
        touch_prev <= touch_in;

        // Rising edge detection
        if (touch_in && !touch_prev) begin
            led <= ~led;  // toggle LED on each touch
        end
    end
end

endmodule
