`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 15.08.2023 15:07:37
// Design Name: 
// Module Name: tb_tt_um_eldritch_pwm_peripheral
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


module tb_tt_um_eldritch_pwm_peripheral();
reg tb_ena;
reg tb_clk;
reg tb_rst_n;
reg [5:0] tb_address;
wire [7:0] tb_ui_in;
reg tb_write_en;
reg [7:0] tb_data_in;
wire [7:0] tb_data_out;
wire [7:0] tb_pwm;//Two signals will be always low, the other are the PWM signals
wire [7:0] tb_uio_en;//Enable for the tristate buffers
tt_um_eldritch_pwm_peripheral DUT(
    .ena(tb_ena),      // will go high when the design is enabled
    .clk(tb_clk),      // clock
    .rst_n(tb_rst_n),     // reset_n - low to reset
    .ui_in(tb_ui_in),    // Dedicated inputs
    .uio_in(tb_data_in),   // IOs: Input path
    .uio_out(tb_data_out),  // IOs: Output path
    .uio_oe(tb_uio_en),   // IOs: Enable path (active high: 0=input, 1=output)
    .uo_out(tb_pwm)   // Dedicated outputs
    );
    assign tb_ui_in = {tb_address, 1'b0,tb_write_en };
    //Clock
    initial begin
    tb_clk = 0;
    forever #1 tb_clk = ~ tb_clk;
    end
    //Configuring the PWM peripheral
    initial begin
    tb_rst_n = 0;//active low
    tb_ena = 0;
    tb_address = 0;
    tb_data_in = 0;
    tb_write_en = 0;
    #800;//Reset delay
    tb_rst_n = 1;
    tb_write_en = 1;
    #16;//Write enable delay
    //Configure PWM1 Registers
    tb_address = 6'h00;//Control Register
    tb_data_in = 8'b0001_0111;//
    #8;
    tb_address = 6'h01;//MSB Period
    tb_data_in = 8'b0000_0000;
    #8;
    tb_address = 6'h02;//LSB Period
    tb_data_in = 8'b0001_1111;
    #8;
    tb_address = 6'h03;//Action Reg A
    tb_data_in = 8'b0001_0010;
    #8;
    tb_address = 6'h04;//MSB Comp A
    tb_data_in = 8'b0000_0000;
    #8;
    tb_address = 6'h05;//LSB Comp A
    tb_data_in = 8'b0000_1000;
    #8;
    tb_address = 6'h06;//MSB Comp B
    tb_data_in = 8'b0000_0000;
    #8;
    tb_address = 6'h07;//LSB Comp B
    tb_data_in = 8'b0000_0000;
    #8;
    tb_address = 6'h08;//Deadband A
    tb_data_in = 8'b0011_0000;//3 ticks of delay on RED
    #8;
    tb_address = 6'h09;//Action Reg B
    tb_data_in = 8'b0010_0001;
    #8;
    tb_address = 6'h0A;//MSB Comp A
    tb_data_in = 8'b0000_0000;
    #8;
    tb_address = 6'h0B;//LSB Comp A
    tb_data_in = 8'b0000_1000;
    #8;
    tb_address = 6'h0C;//MSB Comp B
    tb_data_in = 8'b0000_0000;
    #8;
    tb_address = 6'h0D;//LSB Comp B
    tb_data_in = 8'b0000_0000;
    #8;
    //tb_address = 6'h0E;//Deadband B
    //tb_data_in = 8'b0011_0000;//3 ticks of delay on RED
    //Register written again to bypass design bug
    
    #8;
    tb_address = 6'h00;//Control Register
    tb_data_in = 8'b0001_0111;//
    #8;
    
    //Configure PWM2 Registers
    tb_address = 6'h0F;//Control Register
    tb_data_in = 8'b0001_0111;//
    #8;
    tb_address = 6'h10;//MSB Period
    tb_data_in = 8'b0000_0000;
    #8;
    tb_address = 6'h11;//LSB Period
    tb_data_in = 8'b0001_1111;
    #8;
    tb_address = 6'h12;//MSB Phase
    tb_data_in = 8'b0000_0000;
    #8;
    tb_address = 6'h13;//LSB Phase
    tb_data_in = 8'b0000_1010;
    #8;
    tb_address = 6'h14;//Action Reg A
    tb_data_in = 8'b0001_0010;
    #8;
    tb_address = 6'h15;//MSB Comp A
    tb_data_in = 8'b0000_0000;
    #8;
    tb_address = 6'h16;//LSB Comp A
    tb_data_in = 8'b0000_1000;
    #8;
    tb_address = 6'h17;//MSB Comp B
    tb_data_in = 8'b0000_0000;
    #8;
    tb_address = 6'h18;//LSB Comp B
    tb_data_in = 8'b0000_0000;
    #8;
    tb_address = 6'h19;//Deadband A
    tb_data_in = 8'b0011_0000;//3 ticks of delay on RED
    #8;
    tb_address = 6'h1A;//Action Reg B
    tb_data_in = 8'b0010_0001;
    #8;
    tb_address = 6'h1B;//MSB Comp A
    tb_data_in = 8'b0000_0000;
    #8;
    tb_address = 6'h1C;//LSB Comp A
    tb_data_in = 8'b0000_1000;
    #8;
    tb_address = 6'h1D;//MSB Comp B
    tb_data_in = 8'b0000_0000;
    #8;
    tb_address = 6'h1E;//LSB Comp B
    tb_data_in = 8'b0000_0000;
    #8;
    //tb_address = 6'h1F;//Deadband B
    //tb_data_in = 8'b0011_0000;//3 ticks of delay on RED
    #8;
    //Configure PWM3 Registers
    tb_address = 6'h20;//Control Register
    tb_data_in = 8'b0001_0111;//
    #8;
    tb_address = 6'h21;//MSB Period
    tb_data_in = 8'b0000_0000;
    #8;
    tb_address = 6'h22;//LSB Period
    tb_data_in = 8'b0001_1111;
    #8;
    tb_address = 6'h23;//MSB Phase
    tb_data_in = 8'b0000_0000;
    #8;
    tb_address = 6'h24;//LSB Phase
    tb_data_in = 8'b0000_1010;
    #8;
    tb_address = 6'h25;//Action Reg A
    tb_data_in = 8'b0001_0010;
    #8;
    tb_address = 6'h26;//MSB Comp A
    tb_data_in = 8'b0000_0000;
    #8;
    tb_address = 6'h27;//LSB Comp A
    tb_data_in = 8'b0000_1000;
    #8;
    tb_address = 6'h28;//MSB Comp B
    tb_data_in = 8'b0000_0000;
    #8;
    tb_address = 6'h29;//LSB Comp B
    tb_data_in = 8'b0000_0000;
    #8;
    tb_address = 6'h2A;//Deadband A
    tb_data_in = 8'b0011_0000;//3 ticks of delay on RED
    #8;
    tb_address = 6'h2B;//Action Reg B
    tb_data_in = 8'b0010_0001;
    #8;
    tb_address = 6'h2C;//MSB Comp A
    tb_data_in = 8'b0000_0000;
    #8;
    tb_address = 6'h2D;//LSB Comp A
    tb_data_in = 8'b0000_1000;
    #8;
    tb_address = 6'h2E;//MSB Comp B
    tb_data_in = 8'b0000_0000;
    #8;
    tb_address = 6'h2F;//LSB Comp B
    tb_data_in = 8'b0000_0000;
    #8;
    //tb_address = 6'h30;//Deadband B
    //tb_data_in = 8'b0011_0000;//3 ticks of delay on RED
    #8;
      
    //Configuration complete for all PWMs
    #256;
    end
endmodule
