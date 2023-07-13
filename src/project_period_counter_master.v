`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 23.06.2023 13:25:52
// Design Name: 
// Module Name: project_period_counter_master
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


module project_period_counter_master(
    input i_clk,
    input i_reset,
    input i_en,
    input i_sync_en,
    input [1:0] i_mode,
    input [15:0] i_period,
    output o_sync,
    output [15:0] o_period_next,
    output [15:0] o_period
    );
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
            OFF:  r_period_counter_next = r_period_counter;
            UP:
                if(r_period_counter == i_period)
                    r_period_counter_next = 0;
                else
                    r_period_counter_next = r_period_counter + 1;
            DOWN:
                if(r_period_counter == 0)
                    r_period_counter_next = i_period;
                else
                    r_period_counter_next = r_period_counter - 1;
            UP_DOWN:
            begin
            //Count Logic
                if(r_period_counter == i_period - 16'h0001 )
                    r_up_down_state_next = 1'b1;
                else
                    if(r_period_counter == 16'h0001)
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
