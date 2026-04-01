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

module simon_game_top(
    input clk,
    input reset,
    input [8:0] touch,       // changed from [3:0] to [8:0]
    output reg [8:0] led     // changed from [3:0] to [8:0]
);

// DEBOUNCERS
wire [8:0] touch_pulse;
wire [8:0] touch_level;

debouncer db0 (.clk(clk), .btn_in(touch[0]), .btn_pulse(touch_pulse[0]), .btn_level(touch_level[0]));
debouncer db1 (.clk(clk), .btn_in(touch[1]), .btn_pulse(touch_pulse[1]), .btn_level(touch_level[1]));
debouncer db2 (.clk(clk), .btn_in(touch[2]), .btn_pulse(touch_pulse[2]), .btn_level(touch_level[2]));
debouncer db3 (.clk(clk), .btn_in(touch[3]), .btn_pulse(touch_pulse[3]), .btn_level(touch_level[3]));
debouncer db4 (.clk(clk), .btn_in(touch[4]), .btn_pulse(touch_pulse[4]), .btn_level(touch_level[4]));
debouncer db5 (.clk(clk), .btn_in(touch[5]), .btn_pulse(touch_pulse[5]), .btn_level(touch_level[5]));
debouncer db6 (.clk(clk), .btn_in(touch[6]), .btn_pulse(touch_pulse[6]), .btn_level(touch_level[6]));
debouncer db7 (.clk(clk), .btn_in(touch[7]), .btn_pulse(touch_pulse[7]), .btn_level(touch_level[7]));
debouncer db8 (.clk(clk), .btn_in(touch[8]), .btn_pulse(touch_pulse[8]), .btn_level(touch_level[8]));

// SYSTEM UTILITIES
wire tick;
clock_divider #(50_000_000) clk_div (.clk(clk), .reset(reset), .tick(tick));

wire [3:0] rand_val;   // changed width from [1:0] to [3:0]
reg gen_en;
lfsr_random rand_gen (.clk(clk), .reset(reset), .enable(gen_en), .rand_out(rand_val));

// MEMORY AND PLAYBACK CONTROLLER
reg write_en, read_en;
reg [3:0] user_read_index;
wire [3:0] pc_read_index;
reg [3:0] read_index_mux;
wire [3:0] mem_out;
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
    .led(),  // internal LED handled here
    .done(done_show)
);

// TOUCH LOGIC
reg [2:0] state;
parameter IDLE=0, GEN=1, SHOW=2, INPUT=3, WAIT_RELEASE=4, CORRECT=5, WRONG=6;

wire touch_edge;
reg [3:0] user_index;    // keep for indexing
reg [3:0] user_input;    // changed from [2:0] to [3:0] to handle 9 buttons

assign touch_edge = |touch_pulse;

// Map 9-bit clean level to 0-8
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
        default: user_input = 4'd15;
    endcase
end

// Memory multiplexer
always @(*) begin
    if (state == SHOW) read_index_mux = pc_read_index;
    else read_index_mux = user_read_index;
end

// MAIN GAME FSM
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

                // LED mapping
                case(mem_out)
                    4'd0: led <= 9'b000000001;
                    4'd1: led <= 9'b000000010;
                    4'd2: led <= 9'b000000100;
                    4'd3: led <= 9'b000001000;
                    4'd4: led <= 9'b000010000;
                    4'd5: led <= 9'b000100000;
                    4'd6: led <= 9'b001000000;
                    4'd7: led <= 9'b010000000;
                    4'd8: led <= 9'b100000000;
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
                led <= touch_level; // feedback LEDs
                if (touch_edge) begin
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
                led <= touch_level;
                if (!(|touch_level)) state <= INPUT;
            end
            CORRECT: begin
                led <= 9'b111111111;
                if (tick) state <= GEN;
            end
            WRONG: begin
                if (tick) led <= ~led;
                else if (led == 0) led <= 9'b101010101;
            end
            default: state <= IDLE;
        endcase
    end
end

endmodule