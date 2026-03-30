`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/25/2026 12:25:53 PM
// Design Name: 
// Module Name: lfsr_test_top
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

module lfsr_test_top(
    input clk,
    input reset,
    output reg [3:0] led
);

wire [1:0] rand_out;

reg enable;

// simple slow enable using a counter
reg [25:0] counter;

always @(posedge clk) begin
    if (reset) begin
        counter <= 0;
        enable <= 0;
    end else begin
        counter <= counter + 1;

        // generate enable pulse periodically
        if (counter == 50_000_000) begin
            counter <= 0;
            enable <= 1;
        end else begin
            enable <= 0;
        end
    end
end

lfsr_random lfsr_inst (
    .clk(clk),
    .reset(reset),
    .enable(enable),
    .rand_out(rand_out)
);

// display random value on LEDs
always @(posedge clk) begin
    led[1:0] <= rand_out;
end

endmodule

