`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 28.06.2023 10:34:56
// Design Name: 
// Module Name: tb_project_pwm_peripheral_deadband
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


module tb_project_pwm_peripheral_deadband();
    reg tb_clk;
    reg tb_reset;
    reg tb_i_pwm;
    reg [3:0] tb_red;
    reg [3:0] tb_fed;
    wire tb_o_pwm;
    integer i;
    integer j;
     project_pwm_peripheral_deadband DUT(
        .i_clk(tb_clk),
        .i_reset(tb_reset),
        .i_pwm(tb_i_pwm),
        .i_red(tb_red),
        .i_fed(tb_fed),
        .o_pwm(tb_o_pwm)
    );
    //Clock
    initial begin
    tb_clk = 0;
    forever #1 tb_clk = ~ tb_clk;
    end
    //Signals
    initial begin
    tb_reset = 1;
    tb_i_pwm = 0;
    $display("No delay time = %0t ps", $time);
    //One tick of delay between input and output because of the state registers
    tb_red = 4'h0;
    tb_fed = 4'h0;
    #8;//Reset duration
    tb_reset = 0;
    for(j= 0; j < 9; j = j + 1) //Generate 9 periods of the PWM signal
        for(i = 0; i < 32; i = i + 1)
            begin
            #2;
            if(i == 31)tb_i_pwm = ~tb_i_pwm;// Generate a 32 ticks PWM signal
            end 
    #4;
    $display("8 ticks of RED time = %0t ps", $time);
    tb_red = 4'h8;// Add 8 ticks of delay tot the Rising Edge
    tb_fed = 4'h0;
        for(j= 0; j < 9; j = j + 1) //Generate 9 periods of the PWM signal
            for(i = 0; i < 32; i = i + 1)
                begin
                #2;
                if(i == 31)tb_i_pwm = ~tb_i_pwm;// Generate a 32 ticks PWM signal
                end 
    #4;         
    $display("8 ticks of FED time = %0t ps", $time);
    tb_red = 4'h0;
    tb_fed = 4'h8;// Add 8 ticks of delay tot the Falling Edge
        for(j= 0; j < 9; j = j + 1) //Generate 9 periods of the PWM signal
            for(i = 0; i < 32; i = i + 1)
                begin
                #2;
                if(i == 31)tb_i_pwm = ~tb_i_pwm;// Generate a 32 ticks PWM signal
                end 
    #4;         
    $display("8 ticks of RED and FED time = %0t ps", $time);
    tb_red = 4'h8;// Add 8 ticks of delay tot the Rising Edge
    tb_fed = 4'h8;// Add 8 ticks of delay tot the Falling Edge
        for(j= 0; j < 9; j = j + 1) //Generate 9 periods of the PWM signal
            for(i = 0; i < 32; i = i + 1)
                begin
                #2;
                if(i == 31)tb_i_pwm = ~tb_i_pwm;// Generate a 32 ticks PWM signal
                end 
    $stop();         
    end
endmodule
