`timescale 1ns / 100ps
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


/*
open_vcd xsim_dump.vcd
log_vcd /tb_tt_um_eldritch_pwm_peripheral/dut/*
run 332ns
close_vcd
*/
`include "pwm_peripheral_addresses.vh"
module tb_tt_um_eldritch_pwm_peripheral();

reg tb_ena;
reg tb_clk;
reg tb_rst_n;
reg tb_en;
reg tb_write_configuration_en;
wire tb_write_en;
wire [5:0] tb_address;
wire [7:0] tb_ui_in;
wire [7:0] tb_data_in;
wire [7:0] tb_data_out;
wire [7:0] tb_pwm;//Two signals will be always low, the other are the PWM signals
wire [7:0] tb_uio_en;//Enable for the tristate buffers, goes to the onchip buffers
localparam LOCATIONS =49,
           ADDRESS_SIZE = 6,
           DATA_SIZE = 8;
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
    assign tb_ui_in = {tb_address, 1'b0, tb_write_en };
    
    verification_configuration_programmer
    #(
      .ADDRESS_SIZE(ADDRESS_SIZE),
      .DATA_SIZE(DATA_SIZE),
      .LOCATIONS(LOCATIONS)        
    ) VERIFICATION_MODULE
    (
        .i_clk(tb_clk),
        .i_reset_n(tb_rst_n),
        .i_en(tb_en),//Start the configuration module
        .i_write_en(tb_write_configuration_en),
        .i_data(tb_data_out),//Data coming from the Peripheral
        .o_address(tb_address),//Address selection coming from the module
        .o_data(tb_data_in),//Data going to the Peripheral
        .o_write_en(tb_write_en)//Write enable going to the Peripheral
    );
    
    /* Clock generation*/
    initial begin
        tb_clk = 0;
        forever #1 tb_clk = ~ tb_clk;
    end
    
    initial begin
        tb_rst_n = 0;
        tb_en = 0;
        tb_write_configuration_en = 0;
        tb_ena = 0;
        #4;
        /* Single pair of PWMs configuration */
        /* PWM Module 1*/
        /*
        VERIFICATION_MODULE.r_memory_write[`CONTROL_REG1]    = 8'b0000_0101;
        VERIFICATION_MODULE.r_memory_write[`PERIOD_MSB1]     = 8'b0000_0000;
        VERIFICATION_MODULE.r_memory_write[`PERIOD_LSB1]     = 8'b0001_1111;
        VERIFICATION_MODULE.r_memory_write[`ACTION_REG_A1]   = 8'b0001_0010;
        VERIFICATION_MODULE.r_memory_write[`COMP_A_MSB_A1]   = 8'b0000_0000;
        VERIFICATION_MODULE.r_memory_write[`COMP_A_LSB_A1]   = 8'b0000_1111;
        VERIFICATION_MODULE.r_memory_write[`COMP_A_MSB_B1]   = 8'b0000_0000;
        VERIFICATION_MODULE.r_memory_write[`COMP_A_LSB_B1]   = 8'b0000_0000;
        VERIFICATION_MODULE.r_memory_write[`DEADBAND_REG_A1] = 8'b0001_0000;
        VERIFICATION_MODULE.r_memory_write[`ACTION_REG_B1]   = 8'b0010_0001;
        VERIFICATION_MODULE.r_memory_write[`COMP_B_MSB_A1]   = 8'b0000_0000;
        VERIFICATION_MODULE.r_memory_write[`COMP_B_LSB_A1]   = 8'b0000_1111;
        VERIFICATION_MODULE.r_memory_write[`COMP_B_MSB_B1]   = 8'b0000_0000;
        VERIFICATION_MODULE.r_memory_write[`COMP_B_LSB_B1]   = 8'b0000_0000;
        VERIFICATION_MODULE.r_memory_write[`DEADBAND_REG_B1] = 8'b0001_0000;
        */
         /* All PWM pairs are independently configured */
        // PWM Module 1
        /*
        VERIFICATION_MODULE.r_memory_write[`CONTROL_REG1]    = 8'b0000_0101;
        VERIFICATION_MODULE.r_memory_write[`PERIOD_MSB1]     = 8'b0000_0000;
        VERIFICATION_MODULE.r_memory_write[`PERIOD_LSB1]     = 8'b0001_1111;
        VERIFICATION_MODULE.r_memory_write[`ACTION_REG_A1]   = 8'b0001_0010;
        VERIFICATION_MODULE.r_memory_write[`COMP_A_MSB_A1]   = 8'b0000_0000;
        VERIFICATION_MODULE.r_memory_write[`COMP_A_LSB_A1]   = 8'b0000_1111;
        VERIFICATION_MODULE.r_memory_write[`COMP_A_MSB_B1]   = 8'b0000_0000;
        VERIFICATION_MODULE.r_memory_write[`COMP_A_LSB_B1]   = 8'b0000_0000;
        VERIFICATION_MODULE.r_memory_write[`DEADBAND_REG_A1] = 8'b0001_0000;
        VERIFICATION_MODULE.r_memory_write[`ACTION_REG_B1]   = 8'b0010_0001;
        VERIFICATION_MODULE.r_memory_write[`COMP_B_MSB_A1]   = 8'b0000_0000;
        VERIFICATION_MODULE.r_memory_write[`COMP_B_LSB_A1]   = 8'b0000_1111;
        VERIFICATION_MODULE.r_memory_write[`COMP_B_MSB_B1]   = 8'b0000_0000;
        VERIFICATION_MODULE.r_memory_write[`COMP_B_LSB_B1]   = 8'b0000_0000;
        VERIFICATION_MODULE.r_memory_write[`DEADBAND_REG_B1] = 8'b0001_0000;
        //PWM Module 2
        VERIFICATION_MODULE.r_memory_write[`CONTROL_REG2]    = 8'b0000_1001;
        VERIFICATION_MODULE.r_memory_write[`PERIOD_MSB2]     = 8'b0000_0000;
        VERIFICATION_MODULE.r_memory_write[`PERIOD_LSB2]     = 8'b0001_1111;
        VERIFICATION_MODULE.r_memory_write[`PHASE_MSB2]      = 8'b0000_0000;
        VERIFICATION_MODULE.r_memory_write[`PHASE_LSB2]      = 8'b0000_0000;
        VERIFICATION_MODULE.r_memory_write[`ACTION_REG_A2]   = 8'b1100_1000;
        VERIFICATION_MODULE.r_memory_write[`COMP_A_MSB_A2]   = 8'b0000_0000;
        VERIFICATION_MODULE.r_memory_write[`COMP_A_LSB_A2]   = 8'b0000_0000;
        VERIFICATION_MODULE.r_memory_write[`COMP_A_MSB_B2]   = 8'b0000_0000;
        VERIFICATION_MODULE.r_memory_write[`COMP_A_LSB_B2]   = 8'b0000_1100;
        VERIFICATION_MODULE.r_memory_write[`DEADBAND_REG_A2] = 8'b0000_0010;
        VERIFICATION_MODULE.r_memory_write[`ACTION_REG_B2]   = 8'b1000_0001;
        VERIFICATION_MODULE.r_memory_write[`COMP_B_MSB_A2]   = 8'b0000_0000;
        VERIFICATION_MODULE.r_memory_write[`COMP_B_LSB_A2]   = 8'b0000_0000;
        VERIFICATION_MODULE.r_memory_write[`COMP_B_MSB_B2]   = 8'b0000_0000;
        VERIFICATION_MODULE.r_memory_write[`COMP_B_LSB_B2]   = 8'b0000_1100;
        VERIFICATION_MODULE.r_memory_write[`DEADBAND_REG_B2] = 8'b0000_0010;
        
        //PWM Module 3
        VERIFICATION_MODULE.r_memory_write[`CONTROL_REG3]    = 8'b0000_1101;
        VERIFICATION_MODULE.r_memory_write[`PERIOD_MSB3]     = 8'b0000_0000;
        VERIFICATION_MODULE.r_memory_write[`PERIOD_LSB3]     = 8'b0000_1111;
        VERIFICATION_MODULE.r_memory_write[`PHASE_MSB3]      = 8'b0000_0000;
        VERIFICATION_MODULE.r_memory_write[`PHASE_LSB3]      = 8'b0000_0000;
        VERIFICATION_MODULE.r_memory_write[`ACTION_REG_A3]   = 8'b1001_0000;
        VERIFICATION_MODULE.r_memory_write[`COMP_A_MSB_A3]   = 8'b0000_0000;
        VERIFICATION_MODULE.r_memory_write[`COMP_A_LSB_A3]   = 8'b0000_0011;
        VERIFICATION_MODULE.r_memory_write[`COMP_A_MSB_B3]   = 8'b0000_0000;
        VERIFICATION_MODULE.r_memory_write[`COMP_A_LSB_B3]   = 8'b0000_0111;
        VERIFICATION_MODULE.r_memory_write[`DEADBAND_REG_A3] = 8'b0000_0000;
        VERIFICATION_MODULE.r_memory_write[`ACTION_REG_B3]   = 8'b0110_0000;
        VERIFICATION_MODULE.r_memory_write[`COMP_B_MSB_A3]   = 8'b0000_0000;
        VERIFICATION_MODULE.r_memory_write[`COMP_B_LSB_A3]   = 8'b0000_0011;
        VERIFICATION_MODULE.r_memory_write[`COMP_B_MSB_B3]   = 8'b0000_0000;
        VERIFICATION_MODULE.r_memory_write[`COMP_B_LSB_B3]   = 8'b0000_0111;
        VERIFICATION_MODULE.r_memory_write[`DEADBAND_REG_B3] = 8'b0000_0000;
        */
         /* All PWM2 synchronized to PWM1 */
        // PWM Module 1
        /*
        VERIFICATION_MODULE.r_memory_write[`CONTROL_REG1]    = 8'b0010_0111;
        VERIFICATION_MODULE.r_memory_write[`PERIOD_MSB1]     = 8'b0000_0000;
        VERIFICATION_MODULE.r_memory_write[`PERIOD_LSB1]     = 8'b0001_0001;
        VERIFICATION_MODULE.r_memory_write[`ACTION_REG_A1]   = 8'b0001_0010;
        VERIFICATION_MODULE.r_memory_write[`COMP_A_MSB_A1]   = 8'b0000_0000;
        VERIFICATION_MODULE.r_memory_write[`COMP_A_LSB_A1]   = 8'b0000_1000;
        VERIFICATION_MODULE.r_memory_write[`COMP_A_MSB_B1]   = 8'b0000_0000;
        VERIFICATION_MODULE.r_memory_write[`COMP_A_LSB_B1]   = 8'b0000_0000;
        VERIFICATION_MODULE.r_memory_write[`DEADBAND_REG_A1] = 8'b0000_0000;
        VERIFICATION_MODULE.r_memory_write[`ACTION_REG_B1]   = 8'b0010_0001;
        VERIFICATION_MODULE.r_memory_write[`COMP_B_MSB_A1]   = 8'b0000_0000;
        VERIFICATION_MODULE.r_memory_write[`COMP_B_LSB_A1]   = 8'b0000_1000;
        VERIFICATION_MODULE.r_memory_write[`COMP_B_MSB_B1]   = 8'b0000_0000;
        VERIFICATION_MODULE.r_memory_write[`COMP_B_LSB_B1]   = 8'b0000_0000;
        VERIFICATION_MODULE.r_memory_write[`DEADBAND_REG_B1] = 8'b0000_0000;
        //PWM Module 2
        VERIFICATION_MODULE.r_memory_write[`CONTROL_REG2]    = 8'b0000_0101;
        VERIFICATION_MODULE.r_memory_write[`PERIOD_MSB2]     = 8'b0000_0000;
        VERIFICATION_MODULE.r_memory_write[`PERIOD_LSB2]     = 8'b0001_0001;
        VERIFICATION_MODULE.r_memory_write[`PHASE_MSB2]      = 8'b0000_0000;
        VERIFICATION_MODULE.r_memory_write[`PHASE_LSB2]      = 8'b0000_1010;
        VERIFICATION_MODULE.r_memory_write[`ACTION_REG_A2]   = 8'b0001_0010;
        VERIFICATION_MODULE.r_memory_write[`COMP_A_MSB_A2]   = 8'b0000_0000;
        VERIFICATION_MODULE.r_memory_write[`COMP_A_LSB_A2]   = 8'b0000_1000;
        VERIFICATION_MODULE.r_memory_write[`COMP_A_MSB_B2]   = 8'b0000_0000;
        VERIFICATION_MODULE.r_memory_write[`COMP_A_LSB_B2]   = 8'b0000_0000;
        VERIFICATION_MODULE.r_memory_write[`DEADBAND_REG_A2] = 8'b0000_0000;
        VERIFICATION_MODULE.r_memory_write[`ACTION_REG_B2]   = 8'b0010_0001;
        VERIFICATION_MODULE.r_memory_write[`COMP_B_MSB_A2]   = 8'b0000_0000;
        VERIFICATION_MODULE.r_memory_write[`COMP_B_LSB_A2]   = 8'b0000_1000;
        VERIFICATION_MODULE.r_memory_write[`COMP_B_MSB_B2]   = 8'b0000_0000;
        VERIFICATION_MODULE.r_memory_write[`COMP_B_LSB_B2]   = 8'b0000_0000;
        VERIFICATION_MODULE.r_memory_write[`DEADBAND_REG_B2] = 8'b0000_0000;
        */
        /* All PWM pairs are synchronized as a 3-phase signal*/
        // PWM Module 1     
        VERIFICATION_MODULE.r_memory_write[`CONTROL_REG1]    = 8'b0001_1111;//updown, Bcomp generates sync
        VERIFICATION_MODULE.r_memory_write[`PERIOD_MSB1]     = 8'b0000_0000;
        VERIFICATION_MODULE.r_memory_write[`PERIOD_LSB1]     = 8'b0000_1111;
        VERIFICATION_MODULE.r_memory_write[`ACTION_REG_A1]   = 8'b0001_0010;
        VERIFICATION_MODULE.r_memory_write[`COMP_A_MSB_A1]   = 8'b0000_0000;
        VERIFICATION_MODULE.r_memory_write[`COMP_A_LSB_A1]   = 8'b0000_1100;
        VERIFICATION_MODULE.r_memory_write[`COMP_A_MSB_B1]   = 8'b0000_0000;
        VERIFICATION_MODULE.r_memory_write[`COMP_A_LSB_B1]   = 8'b0000_1010;
        VERIFICATION_MODULE.r_memory_write[`DEADBAND_REG_A1] = 8'b0000_0000;
        VERIFICATION_MODULE.r_memory_write[`ACTION_REG_B1]   = 8'b0010_0001;
        VERIFICATION_MODULE.r_memory_write[`COMP_B_MSB_A1]   = 8'b0000_0000;
        VERIFICATION_MODULE.r_memory_write[`COMP_B_LSB_A1]   = 8'b0000_1100;
        VERIFICATION_MODULE.r_memory_write[`COMP_B_MSB_B1]   = 8'b0000_0000;
        VERIFICATION_MODULE.r_memory_write[`COMP_B_LSB_B1]   = 8'b0000_0000;
        VERIFICATION_MODULE.r_memory_write[`DEADBAND_REG_B1] = 8'b0000_0000;
        //PWM Module 2
        VERIFICATION_MODULE.r_memory_write[`CONTROL_REG2]    = 8'b0001_1111;
        VERIFICATION_MODULE.r_memory_write[`PERIOD_MSB2]     = 8'b0000_0000;
        VERIFICATION_MODULE.r_memory_write[`PERIOD_LSB2]     = 8'b0000_1111;
        VERIFICATION_MODULE.r_memory_write[`PHASE_MSB2]      = 8'b0000_0000;
        VERIFICATION_MODULE.r_memory_write[`PHASE_LSB2]      = 8'b0000_0111;
        VERIFICATION_MODULE.r_memory_write[`ACTION_REG_A2]   = 8'b0001_0010;
        VERIFICATION_MODULE.r_memory_write[`COMP_A_MSB_A2]   = 8'b0000_0000;
        VERIFICATION_MODULE.r_memory_write[`COMP_A_LSB_A2]   = 8'b0000_1100;
        VERIFICATION_MODULE.r_memory_write[`COMP_A_MSB_B2]   = 8'b0000_0000;
        VERIFICATION_MODULE.r_memory_write[`COMP_A_LSB_B2]   = 8'b0000_1010;
        VERIFICATION_MODULE.r_memory_write[`DEADBAND_REG_A2] = 8'b0000_0000;
        VERIFICATION_MODULE.r_memory_write[`ACTION_REG_B2]   = 8'b0010_0001;
        VERIFICATION_MODULE.r_memory_write[`COMP_B_MSB_A2]   = 8'b0000_0000;
        VERIFICATION_MODULE.r_memory_write[`COMP_B_LSB_A2]   = 8'b0000_1100;
        VERIFICATION_MODULE.r_memory_write[`COMP_B_MSB_B2]   = 8'b0000_0000;
        VERIFICATION_MODULE.r_memory_write[`COMP_B_LSB_B2]   = 8'b0000_0000;
        VERIFICATION_MODULE.r_memory_write[`DEADBAND_REG_B2] = 8'b0000_0000;      
        //PWM Module 3
        VERIFICATION_MODULE.r_memory_write[`CONTROL_REG3]    = 8'b0001_1111;
        VERIFICATION_MODULE.r_memory_write[`PERIOD_MSB3]     = 8'b0000_0000;
        VERIFICATION_MODULE.r_memory_write[`PERIOD_LSB3]     = 8'b0000_1111;
        VERIFICATION_MODULE.r_memory_write[`PHASE_MSB3]      = 8'b0000_0000;
        VERIFICATION_MODULE.r_memory_write[`PHASE_LSB3]      = 8'b0000_0111;
        VERIFICATION_MODULE.r_memory_write[`ACTION_REG_A3]   = 8'b0001_0010;
        VERIFICATION_MODULE.r_memory_write[`COMP_A_MSB_A3]   = 8'b0000_0000;
        VERIFICATION_MODULE.r_memory_write[`COMP_A_LSB_A3]   = 8'b0000_1100;
        VERIFICATION_MODULE.r_memory_write[`COMP_A_MSB_B3]   = 8'b0000_0000;
        VERIFICATION_MODULE.r_memory_write[`COMP_A_LSB_B3]   = 8'b0000_0000;
        VERIFICATION_MODULE.r_memory_write[`DEADBAND_REG_A3] = 8'b0000_0000;
        VERIFICATION_MODULE.r_memory_write[`ACTION_REG_B3]   = 8'b0010_0001;
        VERIFICATION_MODULE.r_memory_write[`COMP_B_MSB_A3]   = 8'b0000_0000;
        VERIFICATION_MODULE.r_memory_write[`COMP_B_LSB_A3]   = 8'b0000_1100;
        VERIFICATION_MODULE.r_memory_write[`COMP_B_MSB_B3]   = 8'b0000_0000;
        VERIFICATION_MODULE.r_memory_write[`COMP_B_LSB_B3]   = 8'b0000_0000;
        VERIFICATION_MODULE.r_memory_write[`DEADBAND_REG_B3] = 8'b0000_0000;
        #4;
        tb_rst_n = 1;
        tb_en = 1;
        tb_write_configuration_en = 1;
        #(2 * LOCATIONS);
        tb_write_configuration_en = 0;
        #(2 * LOCATIONS);
        tb_en = 0;
        #128;
        $stop();   
    end
endmodule
