`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/25/2026 11:49:36 AM
// Design Name: 
// Module Name: four_sensor_test
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


module four_sensor_test(
    input clk,
    input reset,
    input [3:0] touch_in,
    output reg [3:0] led
);

reg [3:0] touch_prev;

integer i;

always @(posedge clk) begin
    if (reset) begin
        touch_prev <= 0;
        led <= 0;
    end else begin
        touch_prev <= touch_in;

        for (i = 0; i < 4; i = i + 1) begin
            // rising edge detection per sensor
            if (touch_in[i] && !touch_prev[i]) begin
                led[i] <= ~led[i];
            end
        end
    end
end

endmodule
