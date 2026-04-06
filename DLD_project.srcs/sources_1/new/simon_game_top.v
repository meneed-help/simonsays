`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/06/2026
// Module Name: simon_game_top
// Description: Simon game top module with integrated game timer and human-perceived timing.
//              Correct pattern: all LEDs ON for 1.5s, then a short pause before next pattern.
//              Timeout: flashes last LED in the pattern.
// 
//////////////////////////////////////////////////////////////////////////////////

module simon_game_top(
    input clk,
    input reset,
    input [8:0] touch,
    output reg [8:0] led
);

// ---------------------------------------------------------
// STATE MACHINE DEFINITIONS
// Added CORRECT_WAIT state for delay between patterns
// ---------------------------------------------------------
parameter IDLE=0, GEN=1, SHOW=2, USER_INPUT=3, WAIT_RELEASE=4, CORRECT=5, CORRECT_WAIT=6, WRONG=7, TIMEOUT=8;

// ---------------------------------------------------------
// 1. DEBOUNCERS
// ---------------------------------------------------------
wire [8:0] touch_pulse;
wire [8:0] touch_level;

genvar i;
generate
    for (i = 0; i < 9; i = i + 1) begin : debounce_block
        debouncer db (
            .clk(clk), 
            .btn_in(touch[i]), 
            .btn_pulse(touch_pulse[i]), 
            .btn_level(touch_level[i])
        );
    end
endgenerate

wire touch_edge = |touch_pulse;

// ---------------------------------------------------------
// 2. SYSTEM UTILITIES
// ---------------------------------------------------------
wire tick; // slow clock for human-perceived timing
clock_divider #(50_000_000) clk_div (.clk(clk), .reset(reset), .tick(tick)); // e.g., 1Hz tick

wire [3:0] rand_val;
reg gen_en;
lfsr_random rand_gen (.clk(clk), .reset(reset), .enable(gen_en), .rand_out(rand_val));

// 15-Second Game Timer
wire timeout_signal;
game_timer u_timer (
    .clk(clk),
    .reset(reset),
    .enable(state == USER_INPUT),
    .timeout(timeout_signal)
);

// Flash logic for timeout last LED
reg flash_state;
always @(posedge clk) begin
    if (reset || state != TIMEOUT) flash_state <= 0;
    else if (tick) flash_state <= ~flash_state; // toggle slowly for human eye
end

// ---------------------------------------------------------
// 3. MEMORY AND PLAYBACK
// ---------------------------------------------------------
reg write_en, read_en;
reg [3:0] user_read_index;
wire [3:0] pc_read_index;
reg [3:0] read_index_mux;
wire [3:0] mem_out;
wire [3:0] length;

pattern_memory mem (
    .clk(clk), .reset(reset), .new_value(rand_val),
    .write_en(write_en), .read_en(read_en),
    .read_index(read_index_mux), .out_value(mem_out), .length(length)
);

reg start_show;
wire done_show;

pattern_controller pc (
    .clk(clk), .reset(reset), .start(start_show), .tick(tick),
    .length(length), .mem_value(mem_out), .read_index(pc_read_index),
    .led(), .done(done_show)
);

// ---------------------------------------------------------
// 4. FSM VARIABLES
// ---------------------------------------------------------
reg [2:0] state;
reg [3:0] user_index;
reg [3:0] user_input;

// Store last LED in pattern for flashing on timeout
reg [3:0] last_pattern_led;

// Counter for correct pattern display using tick (human-perceived)
reg [3:0] correct_tick_counter; 
localparam CORRECT_TICKS = 3; // 1 tick = ~0.5s, so 3 ticks = 1.5s for human

// Counter for short pause between patterns
reg [3:0] correct_wait_counter; 
localparam CORRECT_WAIT_TICKS = 1; // 1 tick pause

// Map touch input to user_input index
always @(*) begin
    case (touch_level)
        9'b000000001: user_input = 4'd0;
        9'b000000010: user_input = 4'd1;
        9'b000000100: user_input = 4'd2;
        9'b000001000: user_input = 4'd3;
        9'b000010000: user_input = 4'd4;
        9'b000100000: user_input = 4'd5;
        9'b001000000: user_input = 4'd6;
        9'b010000000: user_input = 4'd7;
        9'b100000000: user_input = 4'd8;
        default:      user_input = 4'd15;
    endcase
end

// Select read index for memory
always @(*) begin
    if (state == SHOW) read_index_mux = pc_read_index;
    else               read_index_mux = user_read_index;
end

// ---------------------------------------------------------
// 5. FSM LOGIC
// ---------------------------------------------------------
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
        last_pattern_led <= 0;
        correct_tick_counter <= 0;
        correct_wait_counter <= 0;
    end else begin
        case (state)
            IDLE: begin
                led <= 0;
                user_index <= 0;
                user_read_index <= 0;
                correct_tick_counter <= 0;
                correct_wait_counter <= 0;
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
                led <= (9'b000000001 << mem_out); // show current pattern LED
                
                if (done_show) begin
                    start_show <= 0;
                    user_index <= 0;
                    user_read_index <= 0;
                    last_pattern_led <= mem_out; // store last LED for timeout
                    state <= USER_INPUT;
                end
            end

            USER_INPUT: begin
                read_en <= 1;
                led <= touch_level;

                if (timeout_signal) state <= TIMEOUT;

                if (touch_edge && !timeout_signal) begin
                    if (user_input == mem_out) begin
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
                led <= touch_level;
                if (!( |touch_level )) state <= USER_INPUT;
            end

            // ---------------------
            // CORRECT: all LEDs ON for 1.5s (human-perceived)
            // ---------------------
            CORRECT: begin
                led <= 9'b111111111; // all LEDs ON
                if (tick) correct_tick_counter <= correct_tick_counter + 1;
                if (correct_tick_counter >= CORRECT_TICKS) begin
                    correct_tick_counter <= 0;
                    state <= CORRECT_WAIT; // move to short pause before next pattern
                end
            end

            // ---------------------
            // CORRECT_WAIT: short delay before generating next pattern
            // ---------------------
            CORRECT_WAIT: begin
                led <= 9'b111111111; // keep LEDs ON during pause
                if (tick) correct_wait_counter <= correct_wait_counter + 1;
                if (correct_wait_counter >= CORRECT_WAIT_TICKS) begin
                    correct_wait_counter <= 0;
                    state <= GEN; // go to next pattern
                end
            end

            WRONG: begin
                if (tick) led <= ~led;
                else if (led == 0) led <= 9'b101010101;
            end

            TIMEOUT: begin
                if (flash_state) led <= (9'b000000001 << last_pattern_led);
                else led <= 9'b000000000;
            end

            default: state <= IDLE;
        endcase
    end
end

endmodule