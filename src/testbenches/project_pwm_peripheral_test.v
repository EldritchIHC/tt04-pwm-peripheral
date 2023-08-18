`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06.07.2023 21:32:19
// Design Name: 
// Module Name: project_pwm_peripheral_test
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


module project_pwm_peripheral_test(
    input i_clk,
    input i_reset,
    input i_en,
    input [1:0] i_mode,
    //output db_sync1,
    //output db_sync2,
    output o_pwm1,
    output o_pwm2,
    output o_pwm3
    );
    wire [15:0] w_period1;
    wire [15:0] w_period2;
    wire [15:0] w_period3;
    wire [15:0] w_period_next1;
    wire [15:0] w_period_next2;
    wire [15:0] w_period_next3;
    wire w_pwm1;
    wire w_pwm2;
    wire w_pwm3;
    wire w_sync1;
    wire w_sync2;
    
    project_period_counter_master master_counter(
        .i_clk(i_clk),
        .i_reset(i_reset),
        .i_en(i_en),
        .i_sync_en(1'b1),
        .i_sync_sel(2'b00),
        .i_compare_b(16'h000),
        .i_mode(i_mode),
        .i_period(16'h003c),
        .o_sync(w_sync1),
        .o_period_next(w_period_next1),
        .o_period(w_period1)
    );
    
    project_period_counter_slave slave_counter1(
        .i_clk(i_clk),
        .i_reset(i_reset),
        .i_en(i_en),
        .i_sync_en(1'b1),
        .i_sync_sel(2'b00),
        .i_compare_b(16'h000),
        .i_phase_en(w_sync1),
        .i_phase_direction(1'b0),
        .i_mode(i_mode),
        .i_phase(16'h0014),
        .i_period(16'h003c),
        .o_sync(w_sync2),
        .o_period_next(w_period_next2),
        .o_period(w_period2)
    );
    
        project_period_counter_slave slave_counter2(
        .i_clk(i_clk),
        .i_reset(i_reset),
        .i_en(i_en),
        .i_sync_en(1'b0),
        .i_sync_sel(2'b00),
        .i_compare_b(16'h000),
        .i_phase_en(w_sync2),
        .i_phase_direction(1'b0),
        .i_mode(i_mode),
        .i_phase(16'h0014),
        .i_period(16'h003c),
        .o_sync(),
        .o_period_next(w_period_next3),
        .o_period(w_period3)
    );
    
    project_pwm_peripheral_comparator comparator1(
        .i_clk(i_clk),
        .i_reset(i_reset),
        .i_period(16'h0011),
        .i_counter(w_period1),
        .i_counter_next(w_period_next1),
        .i_compare_a(16'h001d),
        .i_compare_b(16'h000),
        .i_action_zero(2'b00),
        .i_action_period(2'b01),
        .i_action_compare_a(2'b10),
        .i_action_compare_b(2'b00),
        .o_pwm(w_pwm1),
        .db_pwm()
    );
    
    project_pwm_peripheral_comparator comparator2(
        .i_clk(i_clk),
        .i_reset(i_reset),
        .i_period(16'h0011),
        .i_counter(w_period2),
        .i_counter_next(w_period_next2),
        .i_compare_a(16'h001d),
        .i_compare_b(16'h000),
        .i_action_zero(2'b00),
        .i_action_period(2'b01),
        .i_action_compare_a(2'b10),
        .i_action_compare_b(2'b00),
        .o_pwm(w_pwm2),
        .db_pwm()
    );
    
    project_pwm_peripheral_comparator comparator3(
        .i_clk(i_clk),
        .i_reset(i_reset),
        .i_period(16'h0011),
        .i_counter(w_period3),
        .i_counter_next(w_period_next3),
        .i_compare_a(16'h001d),
        .i_compare_b(16'h000),
        .i_action_zero(2'b00),
        .i_action_period(2'b01),
        .i_action_compare_a(2'b10),
        .i_action_compare_b(2'b00),
        .o_pwm(w_pwm3),
        .db_pwm()
    );
    
    project_pwm_peripheral_deadband deadband1(
        .i_clk(i_clk),
        .i_reset(i_reset),
        .i_pwm(w_pwm1),
        .i_red(4'h0),
        .i_fed(4'h0),
        .o_pwm(o_pwm1)
    );
    
    project_pwm_peripheral_deadband deadband2(
        .i_clk(i_clk),
        .i_reset(i_reset),
        .i_pwm(w_pwm2),
        .i_red(4'h0),
        .i_fed(4'h0),
        .o_pwm(o_pwm2)
    );
    
        project_pwm_peripheral_deadband deadband3(
        .i_clk(i_clk),
        .i_reset(i_reset),
        .i_pwm(w_pwm3),
        .i_red(4'h0),
        .i_fed(4'h0),
        .o_pwm(o_pwm3)
    );
    assign db_sync1 = w_sync1;
    assign db_sync2 = w_sync2;
endmodule
