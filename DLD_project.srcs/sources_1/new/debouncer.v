`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/30/2026 10:08:10 PM
// Design Name: 
// Module Name: debouncer
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

module debouncer (
    input clk,
    input btn_in,
    output reg btn_level, // Is it held down signal
    output reg btn_pulse  // Did it just get pressed signal
);

reg [21:0] count;
reg state;
reg state_prev;

always @(posedge clk) begin
    if (btn_in != state) begin
        count <= count + 1;
        if (count == 22'd2_000_000) begin
            state <= btn_in;
            count <= 0;
        end
    end else begin
        count <= 0;
    end

    state_prev <= state;
    btn_level <= state;
    btn_pulse <= state & ~state_prev; // Creates 1 clock-cycle pulse
end
endmodule
