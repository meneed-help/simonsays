`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/25/2026 04:18:13 PM
// Design Name: 
// Module Name: simon_game_top
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
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/25/2026 04:18:13 PM
// Design Name: 
// Module Name: simon_game_top
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

module simon_game_top(
    input clk,
    input reset,
    input [3:0] touch,
    output reg [3:0] led
);

// --- 1. UTILITY MODULES (CLOCK, RANDOM, MEMORY) ---
wire tick;
clock_divider #(50_000_000) clk_div (
    .clk(clk),
    .reset(reset),
    .tick(tick)
);

wire [1:0] rand_val;
reg gen_en;
lfsr_random rand_gen (
    .clk(clk),
    .reset(reset),
    .enable(gen_en),
    .rand_out(rand_val)
);

reg write_en, read_en;
reg [3:0] user_read_index;
wire [3:0] pc_read_index;
reg [3:0] read_index_mux;
wire [1:0] mem_out;
wire [3:0] length;

pattern_memory mem (
    .clk(clk),
    .reset(reset),
    .new_value(rand_val),
    .write_en(write_en),
    .read_en(read_en),
    .read_index(read_index_mux),
    .out_value(mem_out),
    .length(length)
);

reg start_show;
wire done_show;
pattern_controller pc (
    .clk(clk),
    .reset(reset),
    .start(start_show),
    .tick(tick),
    .length(length),
    .mem_value(mem_out),
    .read_index(pc_read_index),
    .led(), 
    .done(done_show)
);

// --- 2. NEW TEST MODULES (Placed OUTSIDE the always block) ---
wire [3:0] sensor_test_leds;
wire touch_pulse_signal;
wire touch_test_led_toggle;

four_sensor_test u_four_sensor (
    .clk(clk),
    .reset(reset),
    .touch_in(touch),
    .led(sensor_test_leds)
);

touch_input u_touch_in (
    .clk(clk),
    .reset(reset),
    .touch_in(touch[0]),    
    .touch_pulse(touch_pulse_signal)
);

touch_test_top u_touch_test (
    .clk(clk),
    .reset(reset),
    .touch_in(touch[0]),
    .led(touch_test_led_toggle)
);

// --- 3. STATE MACHINE & LOGIC ---
reg [2:0] state;
parameter IDLE=0, GEN=1, SHOW=2, INPUT=3, WAIT_RELEASE=4, CORRECT=5, WRONG=6;

reg touch_prev;
wire touch_now;
wire touch_edge;
reg [3:0] user_index;
reg [2:0] user_input; 

assign touch_now = |touch;

always @(posedge clk) begin
    if (reset) touch_prev <= 0;
    else touch_prev <= touch_now;
end

assign touch_edge = touch_now & ~touch_prev; 

always @(*) begin
    case (touch)
        4'b0001: user_input = 3'd0;
        4'b0010: user_input = 3'd1;
        4'b0100: user_input = 3'd2;
        4'b1000: user_input = 3'd3;
        default: user_input = 3'd7;
    endcase
end

always @(*) begin
    if (state == SHOW) read_index_mux = pc_read_index;
    else read_index_mux = user_read_index;
end

always @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        led <= 0;
        user_index <= 0;
        user_read_index <= 0;
        gen_en <= 0;
        write_en <= 0;
        read_en <= 0;
        start_show <= 0;
    end else begin
        case (state)
            IDLE: begin
                led <= 0;
                user_index <= 0;
                user_read_index <= 0;
                if (touch_edge) state <= GEN;
            end

            GEN: begin
                gen_en <= 1;   
                write_en <= 1; 
                state <= SHOW;
            end

            SHOW: begin
                gen_en <= 0;
                write_en <= 0;
                start_show <= 1;
                read_en <= 1;
                case (mem_out)
                    2'd0: led <= 4'b0001;
                    2'd1: led <= 4'b0010;
                    2'd2: led <= 4'b0100;
                    2'd3: led <= 4'b1000;
                    default: led <= 0;
                endcase
                if (done_show) begin
                    start_show <= 0;
                    user_index <= 0;
                    user_read_index <= 0;
                    state <= INPUT;
                end
            end

            INPUT: begin
                read_en <= 1;
                led <= touch; 
                if (touch_edge) begin
                    if (user_input[1:0] == mem_out) begin
                        if (user_index == length - 1) state <= CORRECT;
                        else begin
                            user_index <= user_index + 1;
                            user_read_index <= user_read_index + 1;
                            state <= WAIT_RELEASE;
                        end
                    end else state <= WRONG;
                end
            end

            WAIT_RELEASE: begin
                led <= touch; 
                if (!touch_now) state <= INPUT; 
            end

            CORRECT: begin
                led <= 4'b1111; 
                if (tick) state <= GEN; 
            end

            WRONG: begin
                if (tick) led <= ~led;
                else if (led == 0) led <= 4'b1010;
            end

            default: state <= IDLE;
        endcase
    end
end

endmodule