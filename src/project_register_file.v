`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07.07.2023 15:16:00
// Design Name: 
// Module Name: project_register_file
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


module project_register_file
    #(parameter ADDRESS_WIDTH = 6)
    (
    input i_clk,
    input i_reset,
    input i_write_en,
    //input i_read_en,
    input [ADDRESS_WIDTH - 1 : 0] i_address,
    input [7:0] i_data,
    output [7:0] o_data,
    //PWM1 registers
    output [7:0] o_pwm1_control_register,
    output [7:0] o_pwm1_msb_period,
    output [7:0] o_pwm1_lsb_period,
    output [7:0] o_pwm1A_action_register,
    output [7:0] o_pwm1A_msb_compa,
    output [7:0] o_pwm1A_lsb_compa,
    output [7:0] o_pwm1A_msb_compb,
    output [7:0] o_pwm1A_lsb_compb,
    output [7:0] o_pwm1A_deadband_register,
    output [7:0] o_pwm1B_action_register,
    output [7:0] o_pwm1B_msb_compa,
    output [7:0] o_pwm1B_lsb_compa,
    output [7:0] o_pwm1B_msb_compb,
    output [7:0] o_pwm1B_lsb_compb,
    output [7:0] o_pwm1B_deadband_register,
    //PWM2 registers
    output [7:0] o_pwm2_control_register,
    output [7:0] o_pwm2_msb_period,
    output [7:0] o_pwm2_lsb_period,
    output [7:0] o_pwm2_msb_phase,
    output [7:0] o_pwm2_lsb_phase,
    output [7:0] o_pwm2A_action_register,
    output [7:0] o_pwm2A_msb_compa,
    output [7:0] o_pwm2A_lsb_compa,
    output [7:0] o_pwm2A_msb_compb,
    output [7:0] o_pwm2A_lsb_compb,
    output [7:0] o_pwm2A_deadband_register,
    output [7:0] o_pwm2B_action_register,
    output [7:0] o_pwm2B_msb_compa,
    output [7:0] o_pwm2B_lsb_compa,
    output [7:0] o_pwm2B_msb_compb,
    output [7:0] o_pwm2B_lsb_compb,
    output [7:0] o_pwm2B_deadband_register,
    //PWM3 registers
    output [7:0] o_pwm3_control_register,
    output [7:0] o_pwm3_msb_period,
    output [7:0] o_pwm3_lsb_period,
    output [7:0] o_pwm3_msb_phase,
    output [7:0] o_pwm3_lsb_phase,
    output [7:0] o_pwm3A_action_register,
    output [7:0] o_pwm3A_msb_compa,
    output [7:0] o_pwm3A_lsb_compa,
    output [7:0] o_pwm3A_msb_compb,
    output [7:0] o_pwm3A_lsb_compb,
    output [7:0] o_pwm3A_deadband_register,
    output [7:0] o_pwm3B_action_register,
    output [7:0] o_pwm3B_msb_compa,
    output [7:0] o_pwm3B_lsb_compa,
    output [7:0] o_pwm3B_msb_compb,
    output [7:0] o_pwm3B_lsb_compb,
    output [7:0] o_pwm3B_deadband_register
    );
    
    //localparam ADDRESS_MAX = 2 ** ADDRESS_WIDTH - 1;
    localparam ADDRESS_MAX = 48;
    reg [7:0] r_register_file [ 0 : ADDRESS_MAX ];
    integer i;
    
    always@(posedge i_clk ,posedge i_reset)
        if(i_reset)
        begin
            for( i = 0; i <= ADDRESS_MAX; i = i + 1)
                r_register_file[i] <= 0; 
        end
        else if(i_write_en) 
            r_register_file[ i_address ] <= i_data; 
             
    assign o_data = r_register_file[ i_address ] ;   
    //PWM1 registers Assigns
    assign o_pwm1_control_register = r_register_file[6'h00] ;
    assign o_pwm1_msb_period = r_register_file[6'h01];
    assign o_pwm1_lsb_period = r_register_file[6'h02];
    assign o_pwm1A_action_register = r_register_file[6'h03];
    assign o_pwm1A_msb_compa = r_register_file[6'h04];
    assign o_pwm1A_lsb_compa = r_register_file[6'h05];
    assign o_pwm1A_msb_compb = r_register_file[6'h06];
    assign o_pwm1A_lsb_compb = r_register_file[6'h07];
    assign o_pwm1A_deadband_register = r_register_file[6'h08];
    assign o_pwm1B_action_register =r_register_file[6'h09];
    assign o_pwm1B_msb_compa = r_register_file[6'h0a];
    assign o_pwm1B_lsb_compa = r_register_file[6'h0b];
    assign o_pwm1B_msb_compb = r_register_file[6'h0c];
    assign o_pwm1B_lsb_compb = r_register_file[6'h0d];
    assign o_pwm1B_deadband_register = r_register_file[6'h0e];
    //PWM2 registers Assign
    assign o_pwm2_control_register = r_register_file[6'h0f] ;
    assign o_pwm2_msb_period = r_register_file[6'h10];
    assign o_pwm2_lsb_period = r_register_file[6'h11];
    assign o_pwm2_msb_phase = r_register_file[6'h12];
    assign o_pwm2_lsb_phase = r_register_file[6'h13];
    assign o_pwm2A_action_register = r_register_file[6'h14];
    assign o_pwm2A_msb_compa = r_register_file[6'h15];
    assign o_pwm2A_lsb_compa = r_register_file[6'h16];
    assign o_pwm2A_msb_compb = r_register_file[6'h17];
    assign o_pwm2A_lsb_compb = r_register_file[6'h18];
    assign o_pwm2A_deadband_register = r_register_file[6'h19];
    assign o_pwm2B_action_register =r_register_file[6'h1a];
    assign o_pwm2B_msb_compa = r_register_file[6'h1b];
    assign o_pwm2B_lsb_compa = r_register_file[6'h1c];
    assign o_pwm2B_msb_compb = r_register_file[6'h1d];
    assign o_pwm2B_lsb_compb = r_register_file[6'h1e];
    assign o_pwm2B_deadband_register = r_register_file[6'h1f];
    //PWM3 registers Assign
    assign o_pwm3_control_register = r_register_file[6'h20] ;
    assign o_pwm3_msb_period = r_register_file[6'h21];
    assign o_pwm3_lsb_period = r_register_file[6'h22];
    assign o_pwm3_msb_phase = r_register_file[6'h23];
    assign o_pwm3_lsb_phase = r_register_file[6'h24];
    assign o_pwm3A_action_register = r_register_file[6'h25];
    assign o_pwm3A_msb_compa = r_register_file[6'h26];
    assign o_pwm3A_lsb_compa = r_register_file[6'h27];
    assign o_pwm3A_msb_compb = r_register_file[6'h28];
    assign o_pwm3A_lsb_compb = r_register_file[6'h29];
    assign o_pwm3A_deadband_register = r_register_file[6'h2a];
    assign o_pwm3B_action_register =r_register_file[6'h2b];
    assign o_pwm3B_msb_compa = r_register_file[6'h2c];
    assign o_pwm3B_lsb_compa = r_register_file[6'h2d];
    assign o_pwm3B_msb_compb = r_register_file[6'h2e];
    assign o_pwm3B_lsb_compb = r_register_file[6'h2f];
    assign o_pwm3B_deadband_register = r_register_file[6'h30];
endmodule
