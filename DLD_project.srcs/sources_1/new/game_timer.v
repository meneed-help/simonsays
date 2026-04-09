`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/06/2026 12:14:31 PM
// Design Name: 
// Module Name: game_timer
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: Timer for player's turn. Counts up to 15s for the whole pattern. 
//              If timeout occurs, signals last LED of the pattern to show missed input.
// 
// Dependencies: 
// 
// Revision:
// Revision 0.02 - Fixed timer logic to cover full pattern
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module game_timer(
    input clk,
    input reset,
    input enable,
    input tick,         //1 second tick to count to 15
    output reg timeout
);

    reg [4:0] seconds;

    always @(posedge clk) begin
        if (reset || !enable) begin
            seconds <= 0;
            timeout <= 0;
        end else begin
            if (tick) begin
                if (seconds >= 15) begin
                    timeout <= 1;
                    seconds <= 0;
                end else begin
                    seconds <= seconds + 1;
                    timeout <= 0;
                end
            end else begin
                timeout <= 0;
            end
        end
    end

endmodule