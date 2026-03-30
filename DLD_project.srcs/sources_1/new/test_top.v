`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/25/2026 11:02:04 AM
// Design Name: 
// Module Name: test_top
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


module test_top(
    input clk,
    input reset,
    output reg led
    );
    wire tick;

clock_divider #(
    .COUNT_MAX(50_000_000) // ~0.5 sec toggle
) clk_div (
    .clk(clk),
    .reset(reset),
    .tick(tick)
);

always @(posedge clk) begin
    if (reset)
        led <= 0;
    else if (tick)
        led <= ~led;
end
endmodule
