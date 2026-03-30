`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/25/2026 03:36:58 PM
// Design Name: 
// Module Name: pattern_controller_test
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


module pattern_controller_test(
    input clk,
    input reset,
    input start_btn,
    output [3:0] led
);

// slow tick
wire tick;

clock_divider #(
    .COUNT_MAX(50_000_000)
) clk_div (
    .clk(clk),
    .reset(reset),
    .tick(tick)
);

// fake pattern: [2, 0, 3, 1]
reg [1:0] mem_value;
wire [3:0] read_index;
wire done;

always @(*) begin
    case (read_index)
        0: mem_value = 2;
        1: mem_value = 0;
        2: mem_value = 3;
        3: mem_value = 1;
        default: mem_value = 0;
    endcase
end

pattern_controller pc (
    .clk(clk),
    .reset(reset),
    .start(start_btn),
    .tick(tick),
    .length(4),           // fixed length
    .mem_value(mem_value),

    .read_index(read_index),
    .led(led),
    .done(done)
);

endmodule
