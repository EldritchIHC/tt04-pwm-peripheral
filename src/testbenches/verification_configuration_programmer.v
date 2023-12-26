
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 26.12.2023 11:27:51
// Design Name: 
// Module Name: verification_configuration_programmer
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


module verification_configuration_programmer
    #(
      parameter ADDRESS_SIZE = 6,
      parameter DATA_SIZE = 8,
      parameter LOCATIONS = 49        
    )
    (
    input wire i_clk,
    input wire i_reset_n,
    input wire i_en,
    input wire i_write_en,
    input wire [DATA_SIZE-1:0] i_data,
    output wire [ADDRESS_SIZE-1:0] o_address,
    output reg [DATA_SIZE-1:0] o_data,
    output wire o_write_en
    );
   integer idx;
   reg [DATA_SIZE-1:0] r_memory_write [0:LOCATIONS-1];
   reg [DATA_SIZE-1:0] r_memory_read [0:LOCATIONS-1];
   reg [ADDRESS_SIZE-1:0] r_counter;
   wire [ADDRESS_SIZE-1:0] w_counter_next;
   /*Initialiaze memory to 0*/
   initial begin
        for( idx = 0; idx < LOCATIONS; idx=idx+1) 
            begin
                r_memory_read[idx] <= 0;
                r_memory_write[idx] <= 0;
            end
    end
    
    /*Address counter*/
    always@(posedge i_clk, posedge i_reset_n)
    begin
        if(~i_reset_n)
            r_counter <= ( LOCATIONS - 1 );
        else if(i_en)
            r_counter <= w_counter_next;
        else
            r_counter <= r_counter;          
    end
    assign w_counter_next = ( r_counter == ( LOCATIONS - 1) ) ?  0 :  r_counter + 1;
    assign o_address = r_counter;
    
    /*Write configuration*/
    always@(*)
        if(i_write_en)
            o_data <= r_memory_write[r_counter];
    assign o_write_en = i_write_en;
    
    /*Read configuration*/
    always@(posedge i_clk)
        if(~i_write_en)
            r_memory_read[r_counter] <= i_data;
endmodule
