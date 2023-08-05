`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 23.06.2023 13:47:42
// Design Name: 
// Module Name: tb_project_period_counter_master
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


module tb_project_period_counter_master();
    reg tb_clk;
    reg tb_reset;
    reg tb_en;
    reg tb_sync_en;
    reg [1:0] tb_mode;
    reg [15:0] tb_period;
    wire tb_o_sync;
    wire [15:0] tb_o_period; 
    wire [15:0] tb_o_period_next ;
    integer idx;
    integer jdx;
    integer enable_test_flag;
    integer mode_test_flag;
    integer phase_test_flag;
    project_period_counter_master DUT(
        .i_clk(tb_clk),
        .i_reset(tb_reset),
        .i_en(tb_en),
        .i_mode(tb_mode),
        .i_sync_en(tb_sync_en),
        .i_period(tb_period),
        .o_sync(tb_o_sync),
        .o_period_next(tb_o_period_next),
        .o_period(tb_o_period)
    );
    //Clock generator
    initial begin
        tb_clk = 0;
        forever #1 tb_clk = ~tb_clk;
    end

    
    initial begin
        enable_test_flag = 0;
        mode_test_flag = 0;       
        tb_reset = 1;
        tb_en = 0;//0
        tb_sync_en = 1;
        tb_period = 16'h0F;
        tb_mode = 0;
        #8;//Reset delay
        tb_reset = 0;
        #2;
        $display("Testing enable signal");
        $display("Enable level is: %b time = %0t", tb_en, $time);
        for(idx = 0; idx < 16; idx = idx + 1)
        begin     
            #2;
            if(tb_o_period != 0)
                begin
                $display("Enable Test Failed time = %0t", $time);
                enable_test_flag = enable_test_flag + 1;
                end
        end
        tb_en = 1'b1;
        tb_mode = 2'b01;
        tb_reset = 1;//
        #8;//
        tb_reset = 0;//
        #1;
        $display("Enable level is: %b time = %0t", tb_en, $time);
        for( idx = 1; idx < 16; idx = idx + 1)
        begin
            #2;           
            if(tb_o_period != idx)
                begin
                $display("Enable Test Failed time = %0t", $time);
                enable_test_flag = enable_test_flag + 1;
                end
                   
        end
        if( enable_test_flag == 0)
           $display("Overall Enable Test Passed") ;
        else
            $display("Overall Enable Test Failed with %d errors",enable_test_flag);
            
   //#######################################################################     
        //Count mode test
        tb_reset = 1;
        #8;
        tb_reset = 0;
        tb_en = 1'b1;
        //UP
        tb_mode = 2'b01;
        $display("Testing mode signal");
        $display("Mode level is: %b time = %0t", tb_mode, $time);
        for(jdx = 0; jdx < 2 ;jdx = jdx + 1)
            for( idx = 0; idx < 16; idx = idx + 1)
            begin             
                if(tb_o_period != idx)
                    begin
                    $display("Mode Test Failed time = %0t", $time);
                    mode_test_flag = mode_test_flag + 1;
                    end
                #2;
            end
        tb_reset = 1;
        #8;
        tb_reset = 0;
        //DOWN
        tb_mode = 2'b10;       
        $display("Mode level is: %b time = %0t", tb_mode, $time);
        for(jdx = 0; jdx < 2 ;jdx = jdx + 1)
            for( idx = 15; idx > -1 ; idx = idx - 1)
            begin
                #2;
                if(tb_o_period != idx)
                    begin
                    $display("Mode Test Failed time = %0t", $time);
                    mode_test_flag = mode_test_flag + 1;
                    end
    
            end
        tb_mode = 2'b11;
        tb_reset = 1;
        idx = 0;
        #8;
        tb_reset = 0; 
        //UP_DOWN             
        $display("Mode level is: %b time = %0t", tb_mode, $time);
        for(jdx = 0; jdx < 2 ;jdx = jdx + 1)
        begin
            for( idx = 1; idx < 16 ; idx = idx + 1)
            begin      
                #2;    
                if(tb_o_period != idx)
                    begin
                    $display("Mode Test Failed time = %0t", $time);
                    mode_test_flag = mode_test_flag + 1;
                    end
            end
            for( idx = 14; idx > -1 ; idx = idx - 1)
            begin
                #2;
                if(tb_o_period != idx)
                    begin
                    $display("Mode Test Failed time = %0t", $time);
                    mode_test_flag = mode_test_flag + 1;
                    end
            end 
        end
        if( mode_test_flag == 0)
           $display("Overall Mode Test Passed") ;
        else
            $display("Overall Mode Test Failed with %d errors",mode_test_flag);
            $stop();
    //#######################################################################
    /*
        //Phase signal test 
        tb_en = 1'b0;
        idx = 0;
        tb_phase  = 16'h0008; 
        tb_mode = 2'b01;
        tb_phase_en = 1; 
        #2;
        tb_reset = 1;
        $display("Testing phase signal");
        $display("Mode level is: %b", tb_mode);
        #2;
        tb_reset = 0; 
        #2;
        tb_phase_en = 0;
        tb_en = 1'b1;
        for( idx = 9; idx < 16; idx = idx + 1)
        begin
            #2;
            if(tb_o_period != idx)
                begin
                $display("Phase Test Failed");
                phase_test_flag = phase_test_flag + 1;
                end
            
        end
    */
    end
endmodule
