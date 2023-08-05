`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Universitatea Politehnica din Timisoara
// Engineer:  Medinceanu Paul-Catalin
// 
// Create Date: 23.06.2023 13:25:52
// Design Name: Master Counter
// Module Name: project_period_counter_master
// Project Name: Opensource Advanced PWM Peripheral
//////////////////////////////////////////////////////////////////////////////////


module project_period_counter_master(
    input wire i_clk,
    input wire i_reset,
    input wire i_en,//Count enable
    input wire i_sync_en,//Enable synchronization signal for slave counters
    input wire [1:0] i_mode,//Counting mode setup value
    input wire [15:0] i_period,//Period of the counter
    output wire o_sync,//Sync signal
    output wire [15:0] o_period_next,//The next valie of the counter register
    output wire [15:0] o_period//Counter register
    );
    //The counting modes
    localparam OFF = 2'b00,
               UP = 2'b01,
               DOWN = 2'b10,
               UP_DOWN = 2'b11;
      reg [15:0] r_period_counter;
      reg [15:0] r_period_counter_next;
      reg r_sync;
      wire w_sync_next;
      reg r_up_down_state; 
      reg r_up_down_state_next;
      
         
    always@(posedge i_clk, posedge i_reset) 
        if(i_reset)
        begin
            r_period_counter <= 0;
            r_up_down_state <= 1'b0;
            r_sync <= 0;
        end
        else if(i_en) 
                begin
                    r_sync <= w_sync_next;
                    r_period_counter <= r_period_counter_next;
                    r_up_down_state <= r_up_down_state_next;
                end

    always@(*)  
    begin  
    r_up_down_state_next = r_up_down_state;
    r_period_counter_next = r_period_counter;
        case(i_mode)
            OFF:  r_period_counter_next = r_period_counter;//No change
            UP:
                if(r_period_counter == i_period)//Reset when counter equals the period value
                    r_period_counter_next = 0;
                else
                    r_period_counter_next = r_period_counter + 1;
            DOWN:
                if(r_period_counter == 0)
                    r_period_counter_next = i_period;//Load the period value when the counter reaches zero
                else
                    r_period_counter_next = r_period_counter - 1;
            UP_DOWN:
            begin
            //Count Logic
                if(r_period_counter == i_period - 16'h0001 )//If the counter reaches period it will count down
                    r_up_down_state_next = 1'b1;
                else
                    if(r_period_counter == 16'h0001)//If the counter reaches zero it will count up
                        r_up_down_state_next = 1'b0; 
            //Counting            
                if(r_up_down_state == 1'b1)
                    r_period_counter_next = r_period_counter  - 1;
                else
                    r_period_counter_next = r_period_counter  + 1;
            end                      
        endcase
    end
    
   //OUTPUT  
   assign o_period_next =  r_period_counter_next;  
   assign o_period = r_period_counter; 
   assign w_sync_next = (r_period_counter_next == i_period) ? 1'b1 : 1'b0;
   assign o_sync = (i_sync_en) ? r_sync : 1'b0;
       
endmodule
