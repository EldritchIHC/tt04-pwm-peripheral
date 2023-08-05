`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 27.06.2023 09:57:35
// Design Name: 
// Module Name: tb_project_pwm_peripheral_comparator
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

module tb_project_pwm_peripheral_comparator();
    reg tb_clk;
    reg tb_reset;
    reg [15:0] tb_period;
    reg [15:0] tb_counter;
    reg [15:0] tb_counter_next;
    reg [15:0] tb_compare_a;
    reg [15:0] tb_compare_b;
    reg [1:0] tb_action_zero;
    reg [1:0] tb_action_period;
    reg [1:0] tb_action_compare_a;
    reg [1:0] tb_action_compare_b;
    wire tb_pwm;
    wire tb_db_pwm;
    wire [1:0] tb_db_action_zero_active; 
    wire [1:0] tb_db_action_period_active;
    wire [1:0] tb_db_action_compare_a_active;
    wire [1:0] tb_db_action_compare_b_active;
    wire [15:0] tb_db_compare_a_value_active;
    wire [15:0] tb_db_compare_b_value_active;
    reg [15:0] j ;
    integer i;
    localparam NOTHING = 2'b00,
           CLEAR = 2'b01,
           SET = 2'b10,
           TOGGLE = 2'b11;
    project_pwm_peripheral_comparator DUT(
        .i_clk(tb_clk),
        .i_reset(tb_reset),
        .i_period(tb_period),
        .i_counter(tb_counter),
        .i_counter_next(tb_counter_next),
        .i_compare_a(tb_compare_a),
        .i_compare_b(tb_compare_b),
        .i_action_zero(tb_action_zero),
        .i_action_period(tb_action_period),
        .i_action_compare_a(tb_action_compare_a),
        .i_action_compare_b(tb_action_compare_b),
        .o_pwm(tb_pwm),
        .db_pwm(tb_db_pwm),
        .db_action_zero_active(tb_db_action_zero_active), 
        .db_action_period_active(tb_db_action_period_active), 
        .db_action_compare_a_active(tb_db_action_compare_a_active),
        .db_action_compare_b_active(tb_db_action_compare_b_active),
        .db_compare_a_value_active(tb_db_compare_a_value_active),
        .db_compare_b_value_active(tb_db_compare_b_value_active)
    );
    //Clock generator
    initial begin
    tb_clk = 0;
    forever #1 tb_clk = ~tb_clk;
    end
    //Signals
    initial begin
    tb_reset = 1;
    tb_period = 16'h000f;
    tb_counter = 0;
    tb_counter_next = 0;
    tb_compare_a = 0;
    tb_compare_b = 0;
    tb_action_zero = 0;
    tb_action_period = 0;
    tb_action_compare_a = 0;
    tb_action_compare_b = 0;
    j = 0;
    #8;//Reset delay
    tb_reset = 0;
    #2;
    //Test 1
    $display("Test 1 - Set on zero, clear on period = 0x%h test time  = %0t", tb_period, $time);
    tb_action_zero = SET;
    tb_action_period = CLEAR;
    for(i = 0; i < 6; i = i + 1)
        for(j = 0; j <= tb_period ;j = j + 1)
        begin
            tb_counter = j;
            tb_counter_next = j + 1 ;
            if( tb_counter_next == 16'h0010) tb_counter_next = 0;
            #2;
        end
    $display("Test 1 finished time  = %0t", $time);   
    #2;
    //Test 2
    tb_compare_a = 16'h0008;
    $display("Test 2 - Set on zero, clear on compare = A 0x%h time  = %0t", tb_compare_a, $time); 
    tb_action_zero = SET;
    tb_action_period = NOTHING;
    tb_action_compare_a = CLEAR;
    for(i = 0; i < 6; i = i + 1)
        for(j = 0; j <= tb_period ;j = j + 1)
        begin
            tb_counter = j;
            tb_counter_next = j + 1 ;
            if( tb_counter_next == 16'h0010) tb_counter_next = 0;
            #2;
        end
    $display("Test 2 finished time  = %0t", $time); 
    #2; 
    //Test 3
    $display("Test 3 - Clear on zero, set on period = 0x%h test time  = %0t" , tb_period, $time);
    tb_action_zero = CLEAR;
    tb_action_period = SET;
    tb_action_compare_a = NOTHING;
    for(i = 0; i < 6; i = i + 1)
        for(j = 0; j <= tb_period ;j = j + 1)
        begin
            tb_counter = j;
            tb_counter_next = j + 1 ;
            if( tb_counter_next == 16'h0010) tb_counter_next = 0;
            #2;
        end
    $display("Test 3 finished time  = %0t", $time);
    #2;    
    //Test 4
    $display("Test 4 - Clear on zero, set on compare A = 0x%h time  = %0t",tb_compare_a, $time);
    tb_action_period = NOTHING;
    tb_action_zero = CLEAR;
    tb_action_compare_a = SET;
    for(i = 0; i < 6; i = i + 1)
        for(j = 0; j <= tb_period ;j = j + 1)
        begin
            tb_counter = j;
            tb_counter_next = j + 1 ;
            if( tb_counter_next == 16'h0010) tb_counter_next = 0;
            #2;
        end
    $display("Test 4 finished time  = %0t", $time); 
    #2;  
    //Test 5
    $display("Test 5 - Clear on period = 0x%h, set on compare A = 0x%h time  = %0t", tb_period, tb_compare_a,  $time);
    tb_action_zero = NOTHING;
    tb_action_period = CLEAR;
    tb_action_compare_a = SET;
    for(i = 0; i < 6; i = i + 1)
        for(j = 0; j <= tb_period ;j = j + 1)
        begin
            tb_counter = j;
            tb_counter_next = j + 1;
            if( tb_counter_next == 16'h0010) tb_counter_next = 0;
            #2;
        end
    $display("Test 5 finished time  = %0t", $time); 
    #2;  
    //Test 6
    $display("Test 6 - Set on period = 0x%h, clear on compare A = 0x%h time  = %0t", tb_period, tb_compare_a,  $time);
    tb_action_period = SET;
    tb_action_compare_a = CLEAR;
    for(i = 0; i < 6; i = i + 1)
        for(j = 0; j <= tb_period ;j = j + 1)
        begin
            tb_counter = j;
            tb_counter_next = j + 1;
            if( tb_counter_next == 16'h0010) tb_counter_next = 0;
            #2;
        end
    $display("Test 6 finished time  = %0t", $time);
    #2;   
    //Test 7
    tb_compare_b = 16'h0004;
    $display("Test 7 - Set on compare B = 0x%h, clear on compare A = 0x%h time  = %0t", tb_compare_b, tb_compare_a, $time);
    tb_action_period = NOTHING;
    tb_action_compare_b = SET;
    tb_action_compare_a = CLEAR;
    for(i = 0; i < 6; i = i + 1)
        for(j = 0; j <= tb_period ;j = j + 1)
        begin
            tb_counter = j;
            tb_counter_next = j + 1;
            if( tb_counter_next == 16'h0010) tb_counter_next = 0;
            #2;
        end
    $display("Test 7 finished time  = %0t", $time);
    #2; 
    $stop();
    end
endmodule
