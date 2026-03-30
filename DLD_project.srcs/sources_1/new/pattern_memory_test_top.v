`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/25/2026 12:50:40 PM
// Design Name: 
// Module Name: pattern_memory_test_top
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


module pattern_memory_test_top(
    input clk,
    input reset,
    input btn_add,      // add new value
    input btn_next,     // read next index
    output reg [3:0] led
);

wire [1:0] rand_out;
reg write_en;
reg read_en;

reg [3:0] read_index;

// Instantiate LFSR
lfsr_random lfsr_inst (
    .clk(clk),
    .reset(reset),
    .enable(write_en),   // generate new number when writing
    .rand_out(rand_out)
);

// Instantiate memory
wire [1:0] mem_out;
wire [3:0] length;

pattern_memory mem_inst (
    .clk(clk),
    .reset(reset),
    .new_value(rand_out),
    .write_en(write_en),
    .read_en(read_en),
    .read_index(read_index),
    .out_value(mem_out),
    .length(length)
);

// Simple button handling (no debounce for now)

always @(posedge clk) begin
    if (reset) begin
        write_en <= 0;
        read_en <= 0;
        read_index <= 0;
    end else begin

        // Add new value
        if (btn_add) begin
            write_en <= 1;
        end else begin
            write_en <= 0;
        end

        // Cycle through memory
        if (btn_next) begin
            read_index <= read_index + 1;
            if (read_index >= length)
                read_index <= 0;
        end

        read_en <= 1; // always reading current index

        // Display memory output on LEDs
        led[1:0] <= mem_out;
        led[3:2] <= read_index[1:0];

    end
end

endmodule
