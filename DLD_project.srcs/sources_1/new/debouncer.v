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
    output reg btn_pulse, // Clean ONE-CLOCK pulse for logic
    output reg btn_level  // High as long as button is held (for LEDs)
);

reg [19:0] count = 0;   
reg state = 0;
reg stable = 0;

always @(posedge clk) begin
    if (btn_in == state) begin
        count <= 0;  
    end else begin
        count <= count + 1;

        if (count == 20'd1_000_000) begin
            state <= btn_in;  
            count <= 0;
        end
    end
end

// Logic for the two different outputs
always @(posedge clk) begin
    btn_level <= state;              // Follows the stable state (LED stays on)
    btn_pulse <= (state & ~stable);  // Fires once (Logic triggers once)
    stable <= state;
end
endmodule
