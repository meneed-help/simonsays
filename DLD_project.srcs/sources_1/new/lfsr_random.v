`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/25/2026 12:21:11 PM
// Design Name: 
// Module Name: lfsr_random
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

module lfsr_random(
    input clk,
    input reset,
    input enable,
    output reg [3:0] rand_out   // 0-8 for 9 LEDs
);

reg [3:0] lfsr;

always @(posedge clk) begin
    if (reset) begin
        lfsr <= 4'b0001;
        rand_out <= 4'b0000;
    end else if (enable) begin
        // 4-bit LFSR
        lfsr <= {lfsr[2:0], lfsr[3] ^ lfsr[2]};

        // Ensure output is 0-8
        if (lfsr > 4'd8)
            rand_out <= lfsr % 9; 
        else
            rand_out <= lfsr;
    end
end

endmodule