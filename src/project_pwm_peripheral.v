`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Universitatea Politehnica din Timisoara
// Engineer: Medinceanu Paul-Catalin
// 
// Create Date: 08.07.2023 15:39:01
// Create Date: 06.07.2023 21:57:57
// Design Name: Slave Counter
// Module Name: project_period_counter_slave
// Project Name: Opensource Advanced PWM Peripheral
//////////////////////////////////////////////////////////////////////////////////


module tt_um_eldritch_pwm_peripheral(
    input  wire       ena,      // will go high when the design is enabled
    input  wire       clk,      // clock
    input  wire       rst_n,     // reset_n - low to reset
    input  wire [7:0] ui_in,    // Dedicated inputs
    input  wire [7:0] uio_in,   // IOs: Input path
    output wire [7:0] uio_out,  // IOs: Output path
    output wire [7:0] uio_oe,   // IOs: Enable path (active high: 0=input, 1=output)
    output wire [7:0] uo_out   // Dedicated outputs
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
        .i_clk(clk),
        .i_reset(~rst_n),
        .i_write_en(ui_in[0]),
        .i_address(ui_in[7:2]),
        .i_data(uio_in),
        .o_data(uio_out),
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
        .i_clk(clk),
        .i_reset(~rst_n),
        .i_en(w_pwm1_control_register[0]),
        .i_sync_en(w_pwm1_control_register[1]),
        .i_sync_sel(w_pwm1_control_register[5:4]),
        .i_compare_b({w_pwm1A_msb_compb,w_pwm1A_lsb_compb}),//Value B of Comp A used to generate sync
        .i_mode(w_pwm1_control_register[3:2]),
        .i_period({w_pwm1_msb_period,w_pwm1_lsb_period}),
        .o_sync(w_sync1),
        .o_period_next(w_period_next1),
        .o_period(w_period1)
    );
    
    project_period_counter_slave counter2_slave(
        .i_clk(clk),
        .i_reset(~rst_n),
        .i_en(w_pwm2_control_register[0]),
        .i_sync_en(w_pwm2_control_register[1]),
        .i_sync_sel(w_pwm2_control_register[5:4]),
        .i_compare_b({w_pwm2A_msb_compb,w_pwm2A_lsb_compb}),//Value B of Comp A used to generate sync
        .i_phase_en(w_sync1),
        .i_phase_direction(w_pwm2_control_register[6]),
        .i_mode(w_pwm2_control_register[3:2]),
        .i_phase({w_pwm2_msb_phase,w_pwm2_lsb_phase}),
        .i_period({w_pwm2_msb_period,w_pwm2_lsb_period}),
        .o_sync(w_sync2),
        .o_period_next(w_period_next2),
        .o_period(w_period2)
    );
    
    project_period_counter_slave counter3_slave(
        .i_clk(clk),
        .i_reset(~rst_n),
        .i_en(w_pwm3_control_register[0]),
        .i_sync_en(w_pwm3_control_register[1]),
        .i_sync_sel(w_pwm3_control_register[5:4]),
        .i_compare_b({w_pwm3A_msb_compb,w_pwm3A_lsb_compb}),//Value B of Comp A used to generate sync
        .i_phase_en(w_sync2),
        .i_phase_direction(w_pwm3_control_register[6]),
        .i_mode(w_pwm3_control_register[3:2]),
        .i_phase({w_pwm3_msb_phase,w_pwm3_lsb_phase}),
        .i_period({w_pwm3_msb_period,w_pwm3_lsb_period}),
        .o_sync(),
        .o_period_next(w_period_next3),
        .o_period(w_period3)
    );
    //Comparators
    project_pwm_peripheral_comparator comparator1A(
        .i_clk(clk),
        .i_reset(~rst_n),
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
        .i_clk(clk),
        .i_reset(~rst_n),
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
        .i_clk(clk),
        .i_reset(~rst_n),
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
        .i_clk(clk),
        .i_reset(~rst_n),
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
        .i_clk(clk),
        .i_reset(~rst_n),
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
        .i_clk(clk),
        .i_reset(~rst_n),
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
        .i_clk(clk),
        .i_reset(~rst_n),
        .i_pwm(w_pwm1A),
        .i_red(w_pwm1A_deadband_register[7:4]),
        .i_fed(w_pwm1A_deadband_register[3:0]),
        .o_pwm(uo_out[0])
    );
    
    project_pwm_peripheral_deadband deadband1B(
        .i_clk(clk),
        .i_reset(~rst_n),
        .i_pwm(w_pwm1B),
        .i_red(w_pwm1B_deadband_register[7:4]),
        .i_fed(w_pwm1B_deadband_register[3:0]),
        .o_pwm(uo_out[1])
    );
    
    project_pwm_peripheral_deadband deadband2A(
        .i_clk(clk),
        .i_reset(~rst_n),
        .i_pwm(w_pwm2A),
        .i_red(w_pwm2A_deadband_register[7:4]),
        .i_fed(w_pwm2A_deadband_register[3:0]),
        .o_pwm(uo_out[2])
    );
    
    project_pwm_peripheral_deadband deadband2B(
        .i_clk(clk),
        .i_reset(~rst_n),
        .i_pwm(w_pwm2B),
        .i_red(w_pwm2B_deadband_register[7:4]),
        .i_fed(w_pwm2B_deadband_register[3:0]),
        .o_pwm(uo_out[3])
    );
    
    project_pwm_peripheral_deadband deadband3A(
        .i_clk(clk),
        .i_reset(~rst_n),
        .i_pwm(w_pwm3A),
        .i_red(w_pwm3A_deadband_register[7:4]),
        .i_fed(w_pwm3A_deadband_register[3:0]),
        .o_pwm(uo_out[4])
    );
    
    project_pwm_peripheral_deadband deadband3B(
        .i_clk(clk),
        .i_reset(~rst_n),
        .i_pwm(w_pwm3B),
        .i_red(w_pwm3B_deadband_register[7:4]),
        .i_fed(w_pwm3B_deadband_register[3:0]),
        .o_pwm(uo_out[5])
    );
    assign uo_out[7:6] = 2'b00;//tie unused outputs
    assign uio_oe = ( ui_in[0] ) ? 8'h00 : 8'hff;//if write_en = 1, io is input, else io is output
endmodule
