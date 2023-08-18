`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08.07.2023 17:03:54
// Design Name: 
// Module Name: tb_project_register_file2
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


module tb_project_register_file();
        reg tb_clk;
        reg tb_reset;
        reg tb_write_en;
        reg [5:0] tb_address;
        wire [7:0] tb_o_data;
        reg [7:0] tb_i_data;
        //PWM1 registers
        
        wire [7:0] tb_pwm1_control_register;
        wire [7:0] tb_pwm1_msb_period;
        wire [7:0] tb_pwm1_lsb_period;
        wire [7:0] tb_pwm1A_action_register;
        wire [7:0] tb_pwm1A_msb_compa;
        wire [7:0] tb_pwm1A_lsb_compa;
        wire [7:0] tb_pwm1A_msb_compb;
        wire [7:0] tb_pwm1A_lsb_compb;
        wire [7:0] tb_pwm1A_deadband_register;
        wire [7:0] tb_pwm1B_action_register;
        wire [7:0] tb_pwm1B_msb_compa;
        wire [7:0] tb_pwm1B_lsb_compa;
        wire [7:0] tb_pwm1B_msb_compb;
        wire [7:0] tb_pwm1B_lsb_compb;
        wire [7:0] tb_pwm1B_deadband_register;
    
    project_register_file  DUT
    (
        .i_clk(tb_clk),
        .i_reset(tb_reset),
        .i_write_en(tb_write_en),
        .i_address(tb_address),
        .i_data(tb_i_data),
        .o_data(tb_o_data),
        //PWM1 registers
        
        .o_pwm1_control_register(tb_pwm1_control_register),
        .o_pwm1_msb_period(tb_pwm1_msb_period),
        .o_pwm1_lsb_period(tb_pwm1_lsb_period),
        .o_pwm1A_action_register(tb_pwm1A_action_register),
        .o_pwm1A_msb_compa(tb_pwm1A_msb_compa),
        .o_pwm1A_lsb_compa(tb_pwm1A_lsb_compa),
        .o_pwm1A_msb_compb(tb_pwm1A_msb_compb),
        .o_pwm1A_lsb_compb(tb_pwm1A_lsb_compb),
        .o_pwm1A_deadband_register(tb_pwm1A_deadband_register),
        .o_pwm1B_action_register(tb_pwm1B_action_register),
        .o_pwm1B_msb_compa(tb_pwm1B_msb_compa),
        .o_pwm1B_lsb_compa(tb_pwm1B_lsb_compa),
        .o_pwm1B_msb_compb(tb_pwm1B_msb_compb),
        .o_pwm1B_lsb_compb(tb_pwm1B_lsb_compb),
        .o_pwm1B_deadband_register(tb_pwm1B_deadband_register)
        
    );
    initial begin
        tb_clk = 0;
        forever #1 tb_clk = ~tb_clk;
    end
    initial begin
        tb_write_en = 0;
        tb_address = 0;
        tb_i_data = 0;
        tb_reset = 1;
        #800;
        tb_reset = 0;
        tb_write_en = 1;
        tb_i_data = 8'b0000_0101;
        #4;
        tb_address = tb_address + 1;
        tb_i_data = 8'b0000_0001;
        #4;
        tb_address = tb_address + 1;
        tb_i_data = 8'b1000_0000;
        #4;
        tb_address = tb_address + 1;
        tb_i_data = 8'b0001_0010;
        #4;
        tb_address = tb_address + 1;
        tb_i_data = 8'b0000_1010;
        #4;
        tb_address = tb_address + 1;
        tb_i_data = 8'b0010_1010;
        #4;
        tb_address = tb_address + 1;
        tb_i_data = 8'b1000_0000;
        #4;
        tb_address = tb_address + 1;
        tb_i_data = 8'b0100_0010;
        #4;
        tb_i_data = 0;
        tb_write_en = 0;
        tb_address = 0;
        for(tb_address = 0; tb_address < 10; tb_address = tb_address +1)
            #2;
        $stop();
    end
endmodule
