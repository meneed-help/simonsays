`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/25/2026 12:38:57 PM
// Design Name: 
// Module Name: pattern_memory
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

module pattern_memory #(
    parameter MAX_LEN = 32   
)(
    input clk,
    input reset,

    input [3:0] new_value,      // 0-8
    input write_en,

    input read_en,
    input [4:0] read_index,     // 5 bits for MAX_LEN 32

    output reg [3:0] out_value,
    output reg [4:0] length      // 5 bits for max 32
);

reg [3:0] memory [0:MAX_LEN-1];
integer i;

always @(posedge clk) begin
    if (reset) begin
        length <= 0;
        out_value <= 0;
        for (i=0;i<MAX_LEN;i=i+1) memory[i]<=0;
    end else begin
        // Write new value
        if (write_en && length < MAX_LEN) begin
            memory[length] <= new_value;
            length <= length + 1;
        end

        // Read value
        if (read_en) begin
            out_value <= memory[read_index];
        end
    end
end

endmodule