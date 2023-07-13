`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 26.06.2023 22:03:14
// Design Name: 
// Module Name: project_pwm_peripheral_comparator
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


module project_pwm_peripheral_comparator(
    input i_clk,
    input i_reset,
    input [15:0] i_period,
    input [15:0] i_counter,
    input [15:0] i_counter_next,
    input [15:0] i_compare_a,
    input [15:0] i_compare_b,
    input [1:0] i_action_zero,
    input [1:0] i_action_period,
    input [1:0] i_action_compare_a,
    input [1:0] i_action_compare_b,
    output o_pwm,
    output db_pwm
    );
    reg r_pwm;
    reg r_pwm_next;
    //Actions
    localparam NOTHING = 2'b00,
               CLEAR = 2'b01,
               SET = 2'b10,
               TOGGLE = 2'b11;
           
               
    always@(posedge i_clk, posedge i_reset )
        if(i_reset)
            r_pwm <= 0;
        else
            r_pwm <= r_pwm_next;

   always@(*)
    begin
        r_pwm_next = r_pwm;
        if(i_counter_next == 0)
            case(i_action_zero)
                NOTHING: 
                    r_pwm_next = r_pwm;
                CLEAR:
                    r_pwm_next = 1'b0;
                SET:
                    r_pwm_next = 1'b1;
                TOGGLE:
                    r_pwm_next = ~r_pwm;
              endcase
          else if(i_counter == i_compare_a) 
              case(i_action_compare_a)
                NOTHING: 
                    r_pwm_next = r_pwm;
                CLEAR:
                    r_pwm_next = 1'b0;
                SET:
                    r_pwm_next = 1'b1;
                TOGGLE:
                    r_pwm_next = ~r_pwm;
              endcase 
          else if(i_counter == i_compare_b) 
              case(i_action_compare_b)
                NOTHING: 
                    r_pwm_next = r_pwm;
                CLEAR:
                    r_pwm_next = 1'b0;
                SET:
                    r_pwm_next = 1'b1;
                TOGGLE:
                    r_pwm_next = ~r_pwm;
              endcase         
          else if(i_counter_next == i_period) 
              case(i_action_period)
                NOTHING: 
                    r_pwm_next = r_pwm;
                CLEAR:
                    r_pwm_next = 1'b0;
                SET:
                    r_pwm_next = 1'b1;
                TOGGLE:
                    r_pwm_next = ~r_pwm;
              endcase                      
    end  
    assign db_pwm = r_pwm_next;   
    assign o_pwm = r_pwm;
endmodule
