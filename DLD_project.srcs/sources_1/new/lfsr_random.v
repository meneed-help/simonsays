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
    input enable,        // used to make the randomness less predictable
    output reg [1:0] rand_out
);

// 4-bit LFSR register
reg [3:0] lfsr;

always @(posedge clk) begin
    if (reset) begin
        lfsr <= 4'b0001;   // seed the 0th pattern generation is always at lsb
        rand_out <= 2'b00;
    end else if (enable) begin
        // XOR taps: bit 3 and bit 2
        lfsr <= {lfsr[2:0], lfsr[3] ^ lfsr[2]};

        // take lower 2 bits as output
        rand_out <= lfsr[1:0];
    end
end

endmodule
