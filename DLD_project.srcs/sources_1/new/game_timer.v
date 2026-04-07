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
    output reg timeout
);

    reg [30:0] count;
    localparam THRESHOLD = 31'd750_000_000; // 15s for 50MHz

    always @(posedge clk) begin
        if (reset || !enable) begin
            count <= 0;
            timeout <= 0;
        end else begin
            if (count >= THRESHOLD) begin
                timeout <= 1;     // ? 1-cycle pulse
                count <= 0;
            end else begin
                count <= count + 1;
                timeout <= 0;
            end
        end
    end

endmodule