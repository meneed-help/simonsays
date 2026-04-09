`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/25/2026 10:57:51 AM
// Design Name: 
// Module Name: clock_divider
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


module clock_divider #(parameter MAX_COUNT = 100_000_000)(
    input clk,
    input reset,
    output reg tick
);

    reg [31:0] count = 0;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            count <= 0;
            tick <= 0;
        end else begin
            if (count == MAX_COUNT - 1) begin
                count <= 0;
                tick <= 1;   // 1second pulse
            end else begin
                count <= count + 1;
                tick <= 0;
            end
        end
    end

endmodule

