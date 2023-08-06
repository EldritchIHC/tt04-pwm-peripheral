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
    input wire [1:0] i_sync_sel,//Select event that produces a sync pulse
    input wire [15:0] i_compare_b,//Used to generate sync pulse
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
     //UP_DOWN count modes
      localparam UD_UP = 1'b0,
                 UD_DOWN = 1'b1;
     //Sync generation modes      
     localparam ZERO = 2'b00,
                PERIOD = 2'b01,
                COMP_B_UP = 2'b10,
                COMP_B_DOWN = 2'b11;
                      
      reg [15:0] r_period_counter;
      reg [15:0] r_period_counter_next;
      reg r_sync;
      reg r_sync_next;
      reg r_up_down_state; 
      reg r_up_down_state_next;
      
         
    always@(posedge i_clk, posedge i_reset) 
        if(i_reset)
        begin
            r_period_counter <= 0;
            r_up_down_state <= UD_UP;
            r_sync <= 0;
        end
        else 
            begin
            r_sync <= r_sync_next;
            if(i_en) 
                begin                   
                    r_period_counter <= r_period_counter_next;
                    r_up_down_state <= r_up_down_state_next;
                end
            end
    //Counter logic
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
                    r_up_down_state_next = UD_DOWN;
                else
                    if(r_period_counter == 16'h0001)//If the counter reaches zero it will count up
                        r_up_down_state_next = UD_UP; 
            //Counting            
                if(r_up_down_state == UD_DOWN)
                    r_period_counter_next = r_period_counter  - 1;
                else
                    r_period_counter_next = r_period_counter  + 1;
            end                      
        endcase
    end
    //Sync logic
    always@(*)
    begin
    r_sync_next = r_sync;
        case(i_sync_sel)
        ZERO:
            if(r_period_counter_next == 0)
                r_sync_next = 1'b1;
            else
                r_sync_next = 1'b0;
        PERIOD:
            if(r_period_counter_next == i_period)
                r_sync_next = 1'b1;
            else
                r_sync_next = 1'b0;
        COMP_B_UP:
            if( (r_period_counter_next == i_compare_b) && ( r_up_down_state == UD_UP ))
                r_sync_next = 1'b1;
            else
                r_sync_next = 1'b0;
        COMP_B_DOWN:
            if( (r_period_counter_next == i_compare_b) && ( r_up_down_state == UD_DOWN ))
                r_sync_next = 1'b1;
            else
                r_sync_next = 1'b0; 
        endcase
    end
   //OUTPUT  
   assign o_period_next =  r_period_counter_next;  
   assign o_period = r_period_counter; 
   assign o_sync = (i_sync_en) ? r_sync : 1'b0;      
endmodule
