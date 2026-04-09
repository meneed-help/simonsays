`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Simon Game Top Module
// Fixes:
// 1. Timer resets ONLY when entering SHOW (new pattern)
// 2. Timeout handled properly
// 3. Removed incorrect timer resets
// 4. Fixed 7-seg digit index overflow
//////////////////////////////////////////////////////////////////////////////////

module simon_game_top(
    input clk,
    input reset,
    input [8:0] touch,
    output reg [8:0] led,
    output reg [3:0] anode,
    output reg [6:0] seg
);

// ---------------------------------------------------------
parameter IDLE=0, GEN=1, SHOW=2, USER_INPUT=3, WAIT_RELEASE=4,
          CORRECT=5, CORRECT_WAIT=6, WRONG=7, TIMEOUT=8, GET_LAST=9;

// ---------------------------------------------------------
// DEBOUNCERS
// ---------------------------------------------------------
wire [8:0] touch_pulse, touch_level;

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
// CLOCK (1 SECOND TICK)
// ---------------------------------------------------------
wire tick;
clock_divider #(100_000_000) clk_div (
    .clk(clk),
    .reset(reset),
    .tick(tick)
);

// ---------------------------------------------------------
// RANDOM
// ---------------------------------------------------------
wire [3:0] rand_val;
reg gen_en;

lfsr_random rand_gen (
    .clk(clk),
    .reset(reset),
    .enable(gen_en),
    .rand_out(rand_val)
);

// ---------------------------------------------------------
// TIMER
// ---------------------------------------------------------
wire timeout_signal;
reg timeout_latched;
reg [3:0] timer_sec;

game_timer u_timer (
    .clk(clk),
    .reset(reset),
    .enable(state == USER_INPUT),
    .tick(tick),
    .timeout(timeout_signal)
);

always @(posedge clk) begin
    if (reset || state != USER_INPUT)
        timeout_latched <= 0;
    else if (timeout_signal)
        timeout_latched <= 1;
end

// ---------------------------------------------------------
// FLASH (TIMEOUT BLINK)
// ---------------------------------------------------------
reg flash_state;
always @(posedge clk) begin
    if (reset || state != TIMEOUT)
        flash_state <= 0;
    else if (tick)
        flash_state <= ~flash_state;
end

// ---------------------------------------------------------
// MEMORY
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
    .read_index(read_index_mux),
    .out_value(mem_out), .length(length)
);

reg start_show;
wire done_show;

pattern_controller pc (
    .clk(clk), .reset(reset), .start(start_show), .tick(tick),
    .length(length), .mem_value(mem_out),
    .read_index(pc_read_index),
    .led(), 
    .done(done_show)
);

// ---------------------------------------------------------
// FSM
// ---------------------------------------------------------
reg [3:0] state, prev_state;
reg [3:0] user_index, user_input;
reg [3:0] last_pattern_led;

reg [3:0] correct_tick_counter, correct_wait_counter;
localparam CORRECT_TICKS = 3;
localparam CORRECT_WAIT_TICKS = 1;

// ---------------------------------------------------------
// INPUT MAP
// ---------------------------------------------------------
always @(*) begin
    case (touch_level)
        9'b000000001: user_input = 0;
        9'b000000010: user_input = 1;
        9'b000000100: user_input = 2;
        9'b000001000: user_input = 3;
        9'b000010000: user_input = 4;
        9'b000100000: user_input = 5;
        9'b001000000: user_input = 6;
        9'b010000000: user_input = 7;
        9'b100000000: user_input = 8;
        default: user_input = 15;
    endcase
end

always @(*) begin
    if (state == SHOW)
        read_index_mux = pc_read_index;
    else
        read_index_mux = user_read_index;
end

// ---------------------------------------------------------
// MAIN FSM
// ---------------------------------------------------------
always @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        prev_state <= IDLE;
        led <= 0;
        timer_sec <= 15;
        user_index <= 0;
        user_read_index <= 0;

        gen_en <= 0;
        write_en <= 0;
        start_show <= 0;
        read_en <= 0;

    end else begin
        prev_state <= state;

        if (prev_state != SHOW && state == SHOW)
            timer_sec <= 15;

        case (state)

            IDLE: begin
                led <= 0;
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

                led <= (9'b1 << mem_out);

                if (done_show) begin
                    start_show <= 0;
                    user_read_index <= length - 1;
                    state <= GET_LAST;
                end
            end

            GET_LAST: begin
                last_pattern_led <= mem_out;
                user_index <= 0;
                user_read_index <= 0;
                state <= USER_INPUT;
            end

            USER_INPUT: begin
                led <= touch_level;

                if (tick && timer_sec > 0)
                    timer_sec <= timer_sec - 1;

                if (timeout_latched)
                    state <= TIMEOUT;

                if (touch_edge && !timeout_latched) begin
                    if (user_input == mem_out) begin
                        if (user_index == length - 1)
                            state <= CORRECT;
                        else begin
                            user_index <= user_index + 1;
                            user_read_index <= user_read_index + 1;
                            state <= WAIT_RELEASE;
                        end
                    end else state <= WRONG;
                end
            end

            WAIT_RELEASE: begin
                if (!(|touch_level)) state <= USER_INPUT;
            end

            CORRECT: begin
                led <= 9'b111111111;
                if (tick) correct_tick_counter <= correct_tick_counter + 1;
                if (correct_tick_counter >= CORRECT_TICKS) begin
                    correct_tick_counter <= 0;
                    state <= CORRECT_WAIT;
                end
            end

            CORRECT_WAIT: begin
                led <= 9'b111111111;
                if (tick) correct_wait_counter <= correct_wait_counter + 1;
                if (correct_wait_counter >= CORRECT_WAIT_TICKS) begin
                    correct_wait_counter <= 0;
                    state <= GEN;
                end
            end

            WRONG: begin
                if (tick) led <= ~led;
            end

            TIMEOUT: begin
                if (flash_state)
                    led <= (9'b1 << last_pattern_led);
                else
                    led <= 0;

                if (touch_edge) begin
                    state <= IDLE;
                    timer_sec <= 15;
                end
            end

        endcase
    end
end

// ---------------------------------------------------------
// 7-SEGMENT DISPLAY
// ---------------------------------------------------------
reg [3:0] digit_val;
reg [1:0] digit_index;
reg [15:0] refresh_counter;

always @(posedge clk) begin
    refresh_counter <= refresh_counter + 1;
    if (refresh_counter == 5000) begin
        refresh_counter <= 0;
        digit_index <= digit_index + 1;
    end
end

always @(*) begin
    case(digit_index)
        0: digit_val = timer_sec / 10;
        1: digit_val = timer_sec % 10;
        2: digit_val = length / 10;
        3: digit_val = length % 10;
    endcase
end

always @(*) begin
    anode = 4'b1111;
    anode[digit_index] = 0;

    case(digit_val)
        0: seg = 7'b1000000;
        1: seg = 7'b1111001;
        2: seg = 7'b0100100;
        3: seg = 7'b0110000;
        4: seg = 7'b0011001;
        5: seg = 7'b0010010;
        6: seg = 7'b0000010;
        7: seg = 7'b1111000;
        8: seg = 7'b0000000;
        9: seg = 7'b0010000;
        default: seg = 7'b1111111;
    endcase
end

endmodule