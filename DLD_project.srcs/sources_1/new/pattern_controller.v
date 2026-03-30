`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/25/2026 02:49:16 PM
// Design Name: 
// Module Name: pattern_controller
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


module pattern_controller(
    input clk,
    input reset,
    input start,                 // start displaying pattern
    input tick,                  // slow timing signal
    input [3:0] length,          // pattern length from memory
    input [1:0] mem_value,       // value read from memory

    output reg [3:0] read_index, // index to read from memory
    output reg [3:0] led,        // LED output
    output reg done              // finished displaying pattern
);

reg [3:0] state;
parameter IDLE  = 0,
          SHOW  = 1,
          WAIT  = 2,
          NEXT  = 3;

always @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        read_index <= 0;
        led <= 0;
        done <= 0;
    end else begin

        case (state)

        IDLE: begin
            led <= 0;
            done <= 0;
            read_index <= 0;

            if (start)
                state <= SHOW;
        end

        SHOW: begin
            // Display current pattern value on LEDs
            case (mem_value)
                2'd0: led <= 4'b0001;
                2'd1: led <= 4'b0010;
                2'd2: led <= 4'b0100;
                2'd3: led <= 4'b1000;
            endcase

            state <= WAIT;
        end

        WAIT: begin
            // Wait for slow tick before moving to next
            if (tick) begin
                state <= NEXT;
            end
        end

        NEXT: begin
            if (read_index < length - 1) begin
                read_index <= read_index + 1;
                state <= SHOW;
            end else begin
                done <= 1;
                state <= IDLE;
            end
        end

        endcase
    end
end

endmodule
