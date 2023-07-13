`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 28.06.2023 10:14:06
// Design Name: 
// Module Name: project_pwm_peripheral_deadband
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


module project_pwm_peripheral_deadband(
    input i_clk,
    input i_reset,
    input i_pwm,
    input [3:0] i_red,
    input [3:0] i_fed,
    output o_pwm
    );
    localparam [1:0] IDLE = 2'b00,
                     RED = 2'b01,
                     LEVEL = 2'b10,
                     FED = 2'b11;
     reg [1:0] r_state;  
     reg [1:0] r_state_next;
     reg [3:0] r_red_counter;
     reg [3:0] r_red_counter_next;
     reg [3:0] r_fed_counter;
     reg [3:0] r_fed_counter_next;
     reg r_pwm;
     reg r_pwm_next;
     //Sequential
     always@(posedge i_clk, posedge i_reset)
        if(i_reset)
            begin
                r_state <= IDLE;
                r_red_counter <= 0;
                r_fed_counter <= 0;
                r_pwm <= 0;
            end   
        else
            begin
                r_state <= r_state_next;
                r_red_counter <= r_red_counter_next;
                r_fed_counter <= r_fed_counter_next;
                r_pwm <= r_pwm_next;
            end 
     //State logic
     always@(*)
        begin
            r_state_next = r_state;
            r_red_counter_next = r_red_counter;
            r_fed_counter_next = r_fed_counter;
            r_pwm_next = r_pwm;
            case(r_state)
                IDLE:
                    if(i_pwm)
                        begin
                            r_state_next = RED;
                        end
                RED:
                    if(r_red_counter == i_red)
                        begin
                            r_red_counter_next = 0;
                            r_pwm_next = 1'b1;
                            r_state_next = LEVEL;
                        end 
                   else
                        r_red_counter_next = r_red_counter + 1;
                LEVEL: 
                    if(~i_pwm)
                        begin
                            r_state_next = FED;
                        end 
                FED:
                   if(r_fed_counter == i_fed)
                        begin
                            r_fed_counter_next = 0;
                            r_pwm_next = 1'b0;
                            r_state_next = IDLE;
                        end 
                   else
                        r_fed_counter_next = r_fed_counter + 1;                    
            endcase                       
        end
        assign o_pwm = r_pwm; 
endmodule
