`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06.07.2023 22:04:55
// Design Name: 
// Module Name: tb_project_period_counter_slave
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


module tb_project_period_counter_slave();
    reg tb_clk;
    reg tb_reset;
    reg tb_en;
    reg tb_sync_en;
    reg [1:0] tb_sync_sel;
    reg [15:0] tb_compare_b;
    reg tb_phase_en;
    reg [1:0] tb_mode;
    reg [15:0] tb_phase;
    reg tb_phase_direction;
    reg [15:0] tb_period;
    wire tb_o_sync;
    wire [15:0] tb_o_period; 
    wire [15:0] tb_o_period_next ;
    integer idx;
    integer jdx;
    integer enable_test_flag;
    integer mode_test_flag;
    integer phase_test_flag;
    reg phase_strobe_flag;
    project_period_counter_slave DUT(
        .i_clk(tb_clk),
        .i_reset(tb_reset),
        .i_en(tb_en),
        .i_phase_en(tb_phase_en),
        .i_phase_direction(tb_phase_direction),
        .i_mode(tb_mode),
        .i_sync_en(tb_sync_en),
        .i_sync_sel(tb_sync_sel),
        .i_compare_b(tb_compare_b),
        .i_phase(tb_phase),
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
        tb_sync_sel = 2'b00;
        tb_compare_b = 16'h0005;
        tb_phase_direction = 1;
        enable_test_flag = 0;
        mode_test_flag = 0;
        phase_test_flag = 0; 
        phase_strobe_flag = 1'b0;      
        tb_reset = 1;
        tb_en = 0;//0
        tb_sync_en = 1;
        tb_period = 16'h000f;
        //tb_period = 16'h1f;
        tb_mode = 0;
        tb_phase = 0;
        tb_phase_en = 1'b0;       
        #8;//Reset delay
        tb_reset = 0;
        #2;
        $display("Testing enable signal");
        $display("Enable level is: %b time = %0t", tb_en, $time);
        for(idx = 0; idx < tb_period + 1; idx = idx + 1)
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
        #1;
        $display("Enable level is: %b time = %0t", tb_en, $time);
        for( idx = 1; idx < tb_period + 1; idx = idx + 1)
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
        tb_sync_sel = 2'b00;
        tb_reset = 0;
        tb_en = 1'b1;
        //UP
        tb_mode = 2'b01;
        $display("Testing mode signal");
        $display("Mode level is: %b time = %0", tb_mode , $time);
        for(jdx = 0; jdx < 4 ;jdx = jdx + 1)
            begin
            for( idx = 0; idx < tb_period + 1; idx = idx + 1)
            begin             
                if(tb_o_period != idx)
                    begin
                    $display("Mode Test Failed time = %0t", $time);
                    mode_test_flag = mode_test_flag + 1;
                    end
                #2;
            end
            tb_sync_sel = tb_sync_sel + 1;//Change sync generation
            end
        tb_reset = 1;
        #8;
        tb_sync_sel = 2'b00;
        tb_reset = 0;
        //DOWN
        tb_mode = 2'b10;       
        $display("Mode level is: %b time = %0t", tb_mode, $time);
        for(jdx = 0; jdx < 4 ;jdx = jdx + 1)
            begin
            for( idx = tb_period; idx > -1 ; idx = idx - 1)
            begin
                #2;
                if(tb_o_period != idx)
                    begin
                    $display("Mode Test Failed time = %0t", $time);
                    mode_test_flag = mode_test_flag + 1;
                    end
            end
            tb_sync_sel = tb_sync_sel + 1;//Change sync generation
            end
        tb_mode = 2'b11;
        tb_reset = 1;
        idx = 0;
        #8;
        tb_sync_sel = 2'b00;
        tb_reset = 0; 
        //UP_DOWN             
        $display("Mode level is: %b time = %0t", tb_mode , $time);
        for(jdx = 0; jdx < 4 ;jdx = jdx + 1)
        begin
            for( idx = 1; idx < tb_period + 1 ; idx = idx + 1)
            begin      
                #2;    
                if(tb_o_period != idx)
                    begin
                    $display("Mode Test Failed time = %0t", $time);
                    mode_test_flag = mode_test_flag + 1;
                    end
            end
            for( idx = tb_period - 1; idx > -1 ; idx = idx - 1)
            begin
                #2;
                if(tb_o_period != idx)
                    begin
                    $display("Mode Test Failed time = %0t", $time);
                    mode_test_flag = mode_test_flag + 1;
                    end
            end
        tb_sync_sel = tb_sync_sel + 1;//Change sync generation    
        end 
        if( mode_test_flag == 0)
           $display("Overall Mode Test Passed") ;
        else
            $display("Overall Mode Test Failed with %d errors",mode_test_flag);
    //#######################################################################
        //Phase signal test 
        tb_en = 1'b0;
        idx = 0;
        tb_phase  = 16'h0005; 
        //UP
        tb_mode = 2'b01; 
        #2;
        tb_reset = 1;
        $display("Testing phase signal");
        $display("Mode level is: %b time = %0t", tb_mode , $time);     
        #8;
        tb_reset = 0;
        tb_phase_en = 0;
        tb_en = 1'b1;
        for ( jdx = 0; jdx < 4; jdx = jdx + 1)
        begin
            for( idx = 0; idx < tb_period + 1; idx = idx + 1)
            begin              
                if(idx == tb_period)
                    begin
                       tb_phase_en = 1'b1;
                       phase_strobe_flag = 1'b1;
                   end
                        else
                         tb_phase_en = 1'b0; 
                if(phase_strobe_flag)     
                    if( ( ( (tb_o_period + tb_phase) || (tb_o_period - tb_phase + 1)  ) ) == idx )
                        begin
                        $display("Phase Test Failed time = %0t", $time);
                        $display("Phase = %0h Period = %0h Counter = %0h time = %0t", tb_phase, tb_o_period, idx,$time);
                        phase_test_flag = phase_test_flag + 1;
                        end 
                #2;          
            end
        end
        //DOWN
        tb_mode = 2'b10; 
        #2;
        tb_reset = 1;
        phase_strobe_flag = 1'b0;
        $display("Testing phase signal");
        $display("Mode level is: %b time = %0t", tb_mode , $time);
        #8;
        tb_reset = 0; 
        tb_phase_en = 0;
        tb_en = 1'b1;
        for ( jdx = 0; jdx < 4; jdx = jdx + 1)
        begin
            for( idx = tb_period; idx > - 1; idx = idx - 1)
            begin              
                if(idx == tb_period)
                    begin
                       tb_phase_en = 1'b1;
                       phase_strobe_flag = 1'b1;
                   end
                        else
                         tb_phase_en = 1'b0; 
                if(phase_strobe_flag)     
                    if( ( ( (tb_o_period + tb_phase) || (tb_o_period - tb_phase + 1)  ) ) == idx )
                        begin
                        $display("Phase Test Failed time = %0t", $time);
                        $display("Phase = %0h Period = %0h Counter = %0h time = %0t", tb_phase, tb_o_period, idx,$time);
                        phase_test_flag = phase_test_flag + 1;
                        end 
                #2;          
            end
        end
        //UP_DOWN
        //Load Phase and count Up
        tb_mode = 2'b11;
        idx = 0;
        tb_phase_direction = 0; 
        #2;
        tb_reset = 1;
        phase_strobe_flag = 1'b0;
        $display("Testing phase signal");
        $display("Mode level is: %b time = %0t", tb_mode , $time);
        #8;
        tb_reset = 0; 
        tb_phase_en = 0;
        tb_en = 1'b1;
        for ( jdx = 0; jdx < 4; jdx = jdx + 1)
        begin
            for( idx = 0; idx < tb_period +1 ; idx = idx + 1)
            begin  
                //Generate phase strobe on counting up                       
                if(idx == 8)
                    begin
                       tb_phase_en = 1'b1;
                       phase_strobe_flag = 1'b1;
                   end
                        else
                         tb_phase_en = 1'b0;                        
                if(phase_strobe_flag)     
                    if( ( ( (tb_o_period + tb_phase) || (tb_o_period - tb_phase + 1)  ) ) == idx )
                        begin
                        //$display("Phase Test Failed time = %0t", $time);
                        //$display("Phase = %0h Period = %0h Counter = %0h time = %0t", tb_phase, tb_o_period, idx,$time);
                        //phase_test_flag = phase_test_flag + 1;
                        end 
                #2;          
            end
            for( idx = tb_period - 1; idx > -1 ; idx = idx - 1)
            begin 
                //Generate phase strobe on counting down  
                /*                      
                if(idx == 8)
                    begin
                       tb_phase_en = 1'b1;
                       phase_strobe_flag = 1'b1;
                   end
                        else
                         tb_phase_en = 1'b0;
                         */                         
                if(phase_strobe_flag)     
                    if( ( ( (tb_o_period + tb_phase) || (tb_o_period - tb_phase + 1)  ) ) == idx )
                        begin
                        //$display("Phase Test Failed time = %0t", $time);
                        //$display("Phase = %0h Period = %0h Counter = %0h time = %0t", tb_phase, tb_o_period, idx, $time);
                        //phase_test_flag = phase_test_flag + 1;
                        end 
                #2;          
            end
        end
        //Load Phase and count Down
        tb_mode = 2'b11;
        idx = 0;
        tb_phase_direction = 1; 
        #2;
        tb_reset = 1;
        phase_strobe_flag = 1'b0;
        $display("Testing phase signal");
        $display("Mode level is: %b time = %0t", tb_mode , $time);
        #8;
        tb_reset = 0; 
        tb_phase_en = 0;
        tb_en = 1'b1;
        for ( jdx = 0; jdx < 4; jdx = jdx + 1)
        begin
            for( idx = 0; idx < tb_period +1 ; idx = idx + 1)
            begin  
                //Generate phase strobe on counting up                       
                if(idx == 8)
                    begin
                       tb_phase_en = 1'b1;
                       phase_strobe_flag = 1'b1;
                   end
                        else
                         tb_phase_en = 1'b0;                        
                if(phase_strobe_flag)     
                    if( ( ( (tb_o_period + tb_phase) || (tb_o_period - tb_phase + 1)  ) ) == idx )
                        begin
                        //$display("Phase Test Failed time = %0t", $time);
                        //$display("Phase = %0h Period = %0h Counter = %0h time = %0t", tb_phase, tb_o_period, idx,$time);
                        //phase_test_flag = phase_test_flag + 1;
                        end 
                #2;          
            end
            for( idx = tb_period - 1; idx > -1 ; idx = idx - 1)
            begin 
                //Generate phase strobe on counting down  
                /*                      
                if(idx == 8)
                    begin
                       tb_phase_en = 1'b1;
                       phase_strobe_flag = 1'b1;
                   end
                        else
                         tb_phase_en = 1'b0;
                         */                         
                if(phase_strobe_flag)     
                    if( ( ( (tb_o_period + tb_phase) || (tb_o_period - tb_phase + 1)  ) ) == idx )
                        begin
                        //$display("Phase Test Failed time = %0t", $time);
                        //$display("Phase = %0h Period = %0h Counter = %0h time = %0t", tb_phase, tb_o_period, idx, $time);
                        //phase_test_flag = phase_test_flag + 1;
                        end 
                #2;          
            end
        end
        
        if( phase_test_flag == 0)
           $display("Overall Phase Test Passed") ;
        else
            $display("Overall Phase Test Failed with %d errors",phase_test_flag);
    $stop();
    end
endmodule
