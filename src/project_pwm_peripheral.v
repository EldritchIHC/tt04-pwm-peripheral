`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08.07.2023 15:39:01
// Design Name: 
// Module Name: project_pwm_peripheral
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


module tt_um_project_pwm_peripheral(
    input i_clk,
    input i_reset,
    input i_write_en,
    input i_read_en,
    input [5:0] i_address,
    inout [7:0] io_data,
    output o_pwm1A,
    output o_pwm1B,
    output o_pwm2A,
    output o_pwm2B,
    output o_pwm3A,
    output o_pwm3B
    );
    wire w_sync1;
    wire w_sync2;
    wire [15:0] w_period1;
    wire [15:0] w_period_next1;
    wire [15:0] w_period2;
    wire [15:0] w_period_next2;
    wire [15:0] w_period3;
    wire [15:0] w_period_next3;
    wire w_pwm1A;
    wire w_pwm1B;
    wire w_pwm2A;
    wire w_pwm2B;
    wire w_pwm3A;
    wire w_pwm3B;
    //PWM1 
    wire [7:0] w_pwm1_control_register;
    wire [7:0] w_pwm1_msb_period;
    wire [7:0] w_pwm1_lsb_period;
    wire [7:0] w_pwm1A_action_register;
    wire [7:0] w_pwm1A_msb_compa;
    wire [7:0] w_pwm1A_lsb_compa;
    wire [7:0] w_pwm1A_msb_compb;
    wire [7:0] w_pwm1A_lsb_compb;
    wire [7:0] w_pwm1A_deadband_register;
    wire [7:0] w_pwm1B_action_register;
    wire [7:0] w_pwm1B_msb_compa;
    wire [7:0] w_pwm1B_lsb_compa;
    wire [7:0] w_pwm1B_msb_compb;
    wire [7:0] w_pwm1B_lsb_compb;
    wire [7:0] w_pwm1B_deadband_register;
    //PWM2 
    wire [7:0] w_pwm2_control_register;
    wire [7:0] w_pwm2_msb_period;
    wire [7:0] w_pwm2_lsb_period;
    wire [7:0] w_pwm2_msb_phase;
    wire [7:0] w_pwm2_lsb_phase;
    wire [7:0] w_pwm2A_action_register;
    wire [7:0] w_pwm2A_msb_compa;
    wire [7:0] w_pwm2A_lsb_compa;
    wire [7:0] w_pwm2A_msb_compb;
    wire [7:0] w_pwm2A_lsb_compb;
    wire [7:0] w_pwm2A_deadband_register;
    wire [7:0] w_pwm2B_action_register;
    wire [7:0] w_pwm2B_msb_compa;
    wire [7:0] w_pwm2B_lsb_compa;
    wire [7:0] w_pwm2B_msb_compb;
    wire [7:0] w_pwm2B_lsb_compb;
    wire [7:0] w_pwm2B_deadband_register;
    //PWM3
    wire [7:0] w_pwm3_control_register;
    wire [7:0] w_pwm3_msb_period;
    wire [7:0] w_pwm3_lsb_period;
    wire [7:0] w_pwm3_msb_phase;
    wire [7:0] w_pwm3_lsb_phase;
    wire [7:0] w_pwm3A_action_register;
    wire [7:0] w_pwm3A_msb_compa;
    wire [7:0] w_pwm3A_lsb_compa;
    wire [7:0] w_pwm3A_msb_compb;
    wire [7:0] w_pwm3A_lsb_compb;
    wire [7:0] w_pwm3A_deadband_register;
    wire [7:0] w_pwm3B_action_register;
    wire [7:0] w_pwm3B_msb_compa;
    wire [7:0] w_pwm3B_lsb_compa;
    wire [7:0] w_pwm3B_msb_compb;
    wire [7:0] w_pwm3B_lsb_compb;
    wire [7:0] w_pwm3B_deadband_register;
    
    //Register File
    project_register_file #(.ADDRESS_WIDTH(6)) register_file
    (
        .i_clk(i_clk),
        .i_reset(i_reset),
        .i_write_en(i_write_en),
        .i_read_en(i_read_en),
        .i_address(i_address),
        .io_data(io_data),
        //PWM1 registers
        .o_pwm1_control_register(w_pwm1_control_register),
        .o_pwm1_msb_period(w_pwm1_msb_period),
        .o_pwm1_lsb_period(w_pwm1_lsb_period),
        .o_pwm1A_action_register(w_pwm1A_action_register),
        .o_pwm1A_msb_compa(w_pwm1A_msb_compa),
        .o_pwm1A_lsb_compa(w_pwm1A_lsb_compa),
        .o_pwm1A_msb_compb(w_pwm1A_msb_compb),
        .o_pwm1A_lsb_compb(w_pwm1A_lsb_compb),
        .o_pwm1A_deadband_register(w_pwm1A_deadband_register),
        .o_pwm1B_action_register(w_pwm1B_action_register),
        .o_pwm1B_msb_compa(w_pwm1B_msb_compa),
        .o_pwm1B_lsb_compa(w_pwm1B_lsb_compa),
        .o_pwm1B_msb_compb(w_pwm1B_msb_compb),
        .o_pwm1B_lsb_compb(w_pwm1B_lsb_compb),
        .o_pwm1B_deadband_register(w_pwm1B_deadband_register),
        //PWM2 registers
        .o_pwm2_control_register(w_pwm2_control_register),
        .o_pwm2_msb_period(w_pwm2_msb_period),
        .o_pwm2_lsb_period(w_pwm2_lsb_period),
        .o_pwm2_msb_phase(w_pwm2_msb_phase),
        .o_pwm2_lsb_phase(w_pwm2_lsb_phase),
        .o_pwm2A_action_register(w_pwm2A_action_register),
        .o_pwm2A_msb_compa(w_pwm2A_msb_compa),
        .o_pwm2A_lsb_compa(w_pwm2A_lsb_compa),
        .o_pwm2A_msb_compb(w_pwm2A_msb_compb),
        .o_pwm2A_lsb_compb(w_pwm2A_lsb_compb),
        .o_pwm2A_deadband_register(w_pwm2A_deadband_register),
        .o_pwm2B_action_register(w_pwm2B_action_register),
        .o_pwm2B_msb_compa(w_pwm2B_msb_compa),
        .o_pwm2B_lsb_compa(w_pwm2B_lsb_compa),
        .o_pwm2B_msb_compb(w_pwm2B_msb_compb),
        .o_pwm2B_lsb_compb(w_pwm2B_lsb_compb),
        .o_pwm2B_deadband_register(w_pwm2B_deadband_register),
        //PWM3 registers
        .o_pwm3_control_register(w_pwm3_control_register),
        .o_pwm3_msb_period(w_pwm3_msb_period),
        .o_pwm3_lsb_period(w_pwm3_lsb_period),
        .o_pwm3_msb_phase(w_pwm3_msb_phase),
        .o_pwm3_lsb_phase(w_pwm3_lsb_phase),
        .o_pwm3A_action_register(w_pwm3A_action_register),
        .o_pwm3A_msb_compa(w_pwm3A_msb_compa),
        .o_pwm3A_lsb_compa(w_pwm3A_lsb_compa),
        .o_pwm3A_msb_compb(w_pwm3A_msb_compb),
        .o_pwm3A_lsb_compb(w_pwm3A_lsb_compb),
        .o_pwm3A_deadband_register(w_pwm3A_deadband_register),
        .o_pwm3B_action_register(w_pwm3B_action_register),
        .o_pwm3B_msb_compa(w_pwm3B_msb_compa),
        .o_pwm3B_lsb_compa(w_pwm3B_lsb_compa),
        .o_pwm3B_msb_compb(w_pwm3B_msb_compb),
        .o_pwm3B_lsb_compb(w_pwm3B_lsb_compb),
        .o_pwm3B_deadband_register(w_pwm3B_deadband_register)
    );
    //Counters
    project_period_counter_master counter1_master(
        .i_clk(i_clk),
        .i_reset(i_reset),
        .i_en(w_pwm1_control_register[0]),
        .i_sync_en(w_pwm1_control_register[1]),
        .i_mode(w_pwm1_control_register[3:2]),
        .i_period({w_pwm1_msb_period,w_pwm1_lsb_period}),
        .o_sync(w_sync1),
        .o_period_next(w_period_next1),
        .o_period(w_period1)
    );
    
    project_period_counter_slave counter2_slave(
        .i_clk(i_clk),
        .i_reset(i_reset),
        .i_en(w_pwm2_control_register[0]),
        .i_sync_en(w_pwm2_control_register[1]),
        .i_phase_en(w_sync1),
        .i_mode(w_pwm2_control_register[3:2]),
        .i_phase({w_pwm2_msb_phase,w_pwm2_lsb_phase}),
        .i_period({w_pwm2_msb_period,w_pwm2_lsb_period}),
        .o_sync(w_sync2),
        .o_period_next(w_period_next2),
        .o_period(w_period2)
    );
    
    project_period_counter_slave counter3_slave(
        .i_clk(i_clk),
        .i_reset(i_reset),
        .i_en(w_pwm3_control_register[0]),
        .i_sync_en(w_pwm3_control_register[1]),
        .i_phase_en(w_sync2),
        .i_mode(w_pwm3_control_register[3:2]),
        .i_phase({w_pwm3_msb_phase,w_pwm3_lsb_phase}),
        .i_period({w_pwm3_msb_period,w_pwm3_lsb_period}),
        .o_sync(),
        .o_period_next(w_period_next3),
        .o_period(w_period3)
    );
    //Comparators
    project_pwm_peripheral_comparator comparator1A(
        .i_clk(i_clk),
        .i_reset(i_reset),
        .i_period({w_pwm1_msb_period,w_pwm1_lsb_period}),
        .i_counter(w_period1),
        .i_counter_next(w_period_next1),
        .i_compare_a({w_pwm1A_msb_compa,w_pwm1A_lsb_compa}),
        .i_compare_b({w_pwm1A_msb_compb,w_pwm1A_lsb_compb}),
        .i_action_zero(w_pwm1A_action_register[1:0]),
        .i_action_period(w_pwm1A_action_register[3:2]),
        .i_action_compare_a(w_pwm1A_action_register[5:4]),
        .i_action_compare_b(w_pwm1A_action_register[7:6]),
        .o_pwm(w_pwm1A),
        .db_pwm()
    );
    
    project_pwm_peripheral_comparator comparator1B(
        .i_clk(i_clk),
        .i_reset(i_reset),
        .i_period({w_pwm1_msb_period,w_pwm1_lsb_period}),
        .i_counter(w_period1),
        .i_counter_next(w_period_next1),
        .i_compare_a({w_pwm1B_msb_compa,w_pwm1B_lsb_compa}),
        .i_compare_b({w_pwm1B_msb_compb,w_pwm1B_lsb_compb}),
        .i_action_zero(w_pwm1B_action_register[1:0]),
        .i_action_period(w_pwm1B_action_register[3:2]),
        .i_action_compare_a(w_pwm1B_action_register[5:4]),
        .i_action_compare_b(w_pwm1B_action_register[7:6]),
        .o_pwm(w_pwm1B),
        .db_pwm()
    );
    
    project_pwm_peripheral_comparator comparator2A(
        .i_clk(i_clk),
        .i_reset(i_reset),
        .i_period({w_pwm2_msb_period,w_pwm2_lsb_period}),
        .i_counter(w_period2),
        .i_counter_next(w_period_next2),
        .i_compare_a({w_pwm2A_msb_compa,w_pwm2A_lsb_compa}),
        .i_compare_b({w_pwm2A_msb_compb,w_pwm2A_lsb_compb}),
        .i_action_zero(w_pwm2A_action_register[1:0]),
        .i_action_period(w_pwm2A_action_register[3:2]),
        .i_action_compare_a(w_pwm2A_action_register[5:4]),
        .i_action_compare_b(w_pwm2A_action_register[7:6]),
        .o_pwm(w_pwm2A),
        .db_pwm()
    );
    
    project_pwm_peripheral_comparator comparator2B(
        .i_clk(i_clk),
        .i_reset(i_reset),
        .i_period({w_pwm2_msb_period,w_pwm2_lsb_period}),
        .i_counter(w_period2),
        .i_counter_next(w_period_next2),
        .i_compare_a({w_pwm2B_msb_compa,w_pwm2B_lsb_compa}),
        .i_compare_b({w_pwm2B_msb_compb,w_pwm2B_lsb_compb}),
        .i_action_zero(w_pwm2B_action_register[1:0]),
        .i_action_period(w_pwm2B_action_register[3:2]),
        .i_action_compare_a(w_pwm2B_action_register[5:4]),
        .i_action_compare_b(w_pwm2B_action_register[7:6]),
        .o_pwm(w_pwm2B),
        .db_pwm()
    );
    
    project_pwm_peripheral_comparator comparator3A(
        .i_clk(i_clk),
        .i_reset(i_reset),
        .i_period({w_pwm3_msb_period,w_pwm3_lsb_period}),
        .i_counter(w_period3),
        .i_counter_next(w_period_next3),
        .i_compare_a({w_pwm3A_msb_compa,w_pwm3A_lsb_compa}),
        .i_compare_b({w_pwm3A_msb_compb,w_pwm3A_lsb_compb}),
        .i_action_zero(w_pwm3A_action_register[1:0]),
        .i_action_period(w_pwm3A_action_register[3:2]),
        .i_action_compare_a(w_pwm3A_action_register[5:4]),
        .i_action_compare_b(w_pwm3A_action_register[7:6]),
        .o_pwm(w_pwm3A),
        .db_pwm()
    );
    
    project_pwm_peripheral_comparator comparator3B(
        .i_clk(i_clk),
        .i_reset(i_reset),
        .i_period({w_pwm3_msb_period,w_pwm3_lsb_period}),
        .i_counter(w_period3),
        .i_counter_next(w_period_next3),
        .i_compare_a({w_pwm3B_msb_compa,w_pwm3B_lsb_compa}),
        .i_compare_b({w_pwm3B_msb_compb,w_pwm3B_lsb_compb}),
        .i_action_zero(w_pwm3B_action_register[1:0]),
        .i_action_period(w_pwm3B_action_register[3:2]),
        .i_action_compare_a(w_pwm3B_action_register[5:4]),
        .i_action_compare_b(w_pwm3B_action_register[7:6]),
        .o_pwm(w_pwm3B),
        .db_pwm()
    );
    //Deadband
    project_pwm_peripheral_deadband deadband1A(
        .i_clk(i_clk),
        .i_reset(i_reset),
        .i_pwm(w_pwm1A),
        .i_red(w_pwm1A_deadband_register[7:4]),
        .i_fed(w_pwm1A_deadband_register[3:0]),
        .o_pwm(o_pwm1A)
    );
    
    project_pwm_peripheral_deadband deadband1B(
        .i_clk(i_clk),
        .i_reset(i_reset),
        .i_pwm(w_pwm1B),
        .i_red(w_pwm1B_deadband_register[7:4]),
        .i_fed(w_pwm1B_deadband_register[3:0]),
        .o_pwm(o_pwm1B)
    );
    
    project_pwm_peripheral_deadband deadband2A(
        .i_clk(i_clk),
        .i_reset(i_reset),
        .i_pwm(w_pwm2A),
        .i_red(w_pwm2A_deadband_register[7:4]),
        .i_fed(w_pwm2A_deadband_register[3:0]),
        .o_pwm(o_pwm2A)
    );
    
    project_pwm_peripheral_deadband deadband2B(
        .i_clk(i_clk),
        .i_reset(i_reset),
        .i_pwm(w_pwm2B),
        .i_red(w_pwm2B_deadband_register[7:4]),
        .i_fed(w_pwm2B_deadband_register[3:0]),
        .o_pwm(o_pwm2B)
    );
    
    project_pwm_peripheral_deadband deadband3A(
        .i_clk(i_clk),
        .i_reset(i_reset),
        .i_pwm(w_pwm3A),
        .i_red(w_pwm3A_deadband_register[7:4]),
        .i_fed(w_pwm3A_deadband_register[3:0]),
        .o_pwm(o_pwm3A)
    );
    
    project_pwm_peripheral_deadband deadband3B(
        .i_clk(i_clk),
        .i_reset(i_reset),
        .i_pwm(w_pwm3B),
        .i_red(w_pwm3B_deadband_register[7:4]),
        .i_fed(w_pwm3B_deadband_register[3:0]),
        .o_pwm(o_pwm3B)
    );
endmodule
