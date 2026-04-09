`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/08/2026 03:37:51 PM
// Design Name: 
// Module Name: buzzer
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

module buzzer(
    input clk,
    input reset,
    input [3:0] tile_id,
    input enable,
    output reg buzzer_out
);

    reg [17:0] counter = 0;
    reg [17:0] target_count;

    always @(*) begin
        case(tile_id)
            4'd0: target_count = 18'd191110;
            4'd1: target_count = 18'd170262;
            4'd2: target_count = 18'd151710;
            4'd3: target_count = 18'd143172;
            4'd4: target_count = 18'd127551;
            4'd5: target_count = 18'd113636;
            4'd6: target_count = 18'd101214;
            4'd7: target_count = 18'd95556;
            4'd8: target_count = 18'd85131;
            default: target_count = 18'd200000;
        endcase
    end

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            counter <= 0;
            buzzer_out <= 0;
        end 
        else if (enable) begin
            if (counter >= target_count) begin
                counter <= 0;
                buzzer_out <= ~buzzer_out;
            end else begin
                counter <= counter + 1;
            end
        end 
        else begin
            buzzer_out <= 0;
            counter <= 0;
        end
    end

endmodule
