`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Universitatea Politehnica din Timisoara
// Engineer: Medinceanu Paul-Catalin
// 
// Create Date: 26.06.2023 22:03:14
// Design Name: Comparator
// Module Name: project_pwm_peripheral_comparator
// Project Name: Opensource Advanced PWM Peripheral
//////////////////////////////////////////////////////////////////////////////////

//`define DEBUG
module project_pwm_peripheral_comparator(
    input wire i_clk,
    input wire i_reset,
    input wire [15:0] i_period,//Period value from the register
    input wire [15:0] i_counter,//Value from the counter
    input wire [15:0] i_counter_next,//The next value from the counter
    input wire [15:0] i_compare_a,//Value A to compare to from the setup register
    input wire [15:0] i_compare_b,//Value B to compare to from the setup register
    input wire [1:0] i_action_zero,//Value to select the action that takes place when the counter equals zero
    input wire [1:0] i_action_period,//Value to select the action that takes place when the counter equals the period
    input wire [1:0] i_action_compare_a,//Value to select the action that takes place when the counter equals Value A
    input wire [1:0] i_action_compare_b,//Value to select the action that takes place when the counter equals Value B  
    `ifdef DEBUG
    output wire db_pwm,
    `endif
    output wire o_pwm
    );
    //Counter registers
    reg r_pwm;
    reg r_pwm_next;
    //Debug signals
    `ifdef DEBUG
    assign db_pwm = r_pwm_next;
    `endif
    //Actions
    localparam NOTHING = 2'b00,
               CLEAR = 2'b01,
               SET = 2'b10,
               TOGGLE = 2'b11;
           
    //PWM generation          
    always@(posedge i_clk, posedge i_reset )
        if(i_reset)
            r_pwm <= 0;
        else
            r_pwm <= r_pwm_next;
       
   always@(*)
    begin
        r_pwm_next = r_pwm;
        if( i_counter_next == 0 )// Counter equals Zero and decides how the PWM will change
            case(i_action_zero)
                NOTHING: 
                    r_pwm_next = r_pwm;//Unchanged
                CLEAR:
                    r_pwm_next = 1'b0;//Goes Low
                SET:
                    r_pwm_next = 1'b1;//Goes High
                TOGGLE:
                    r_pwm_next = ~r_pwm;//Inverted
              endcase
          else if(i_counter == i_compare_a)// Counter equals Value A and decides how the PWM will change 
              case(i_action_compare_a)
                NOTHING: 
                    r_pwm_next = r_pwm;//Unchanged
                CLEAR:
                    r_pwm_next = 1'b0;//Goes Low
                SET:
                    r_pwm_next = 1'b1;//Goes High
                TOGGLE:
                    r_pwm_next = ~r_pwm;//Inverted
              endcase 
          else if(i_counter == i_compare_b)// Counter equals Value B and decides how the PWM will change 
              case(i_action_compare_b)
                NOTHING: 
                    r_pwm_next = r_pwm;//Unchanged
                CLEAR:
                    r_pwm_next = 1'b0;//Goes Low
                SET:
                    r_pwm_next = 1'b1;//Goes High
                TOGGLE:
                    r_pwm_next = ~r_pwm;//Inverted
              endcase         
          else if(i_counter_next == i_period)// Counter equals Period and decides how the PWM will change
              case(i_action_period)
                NOTHING: 
                    r_pwm_next = r_pwm;//Unchanged
                CLEAR:
                    r_pwm_next = 1'b0;//Goes Low
                SET:
                    r_pwm_next = 1'b1;//Goes High
                TOGGLE:
                    r_pwm_next = ~r_pwm;//Inverted
              endcase
    end     
    assign o_pwm = r_pwm;
endmodule
