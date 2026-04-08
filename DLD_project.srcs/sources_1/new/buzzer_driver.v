`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/08/2026 12:40:19 PM
// Design Name: 
// Module Name: buzzer_driver
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


module buzzer_driver(
    input clk,          // 100MHz Basys 3 clock
    input enable,       // Connect this to a switch or touch sensor
    output reg buzzer   // Connect this to Pmod Pin J1
    );

    reg [31:0] counter = 0;
    
    // 50,000 creates a 1kHz tone. 
    // Lower this number for a higher pitch, raise it for a lower pitch.
    parameter TONE_VALUE = 50000; 

    always @(posedge clk) begin
        if (enable) begin
            if (counter >= TONE_VALUE) begin
                counter <= 0;
                buzzer <= ~buzzer; // Toggle the pin
            end else begin
                counter <= counter + 1;
            end
        end else begin
            counter <= 0;
            buzzer <= 0; // Keep quiet if not enabled
        end
    end
endmodule
