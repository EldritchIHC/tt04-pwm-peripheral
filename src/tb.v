`default_nettype none
`timescale 1ns/1ps

/*
this testbench just instantiates the module and makes some convenient wires
that can be driven / tested by the cocotb test.py
*/

// testbench is controlled by test.py
module tb ();

    // this part dumps the trace to a vcd file that can be viewed with GTKWave
    initial begin
        $dumpfile ("tb.vcd");
        $dumpvars (0, tb);
        #1;
    end

    // wire up the inputs and outputs
    reg  clk;
    reg  rst_n;
    reg  ena;
    reg  [7:0] ui_in;
    reg  [7:0] uio_in;
    wire [7:0] uo_out;
    wire [7:0] uio_out;
    wire [7:0] uio_oe;
    //Write enable
    //wire i_write_en = ui_in[0];
    //Address inputs
    //wire [5:0] i_address = ui_in[7:2];
    //Data inputs
    //wire [7:0]  i_data= uio_in[7:0];
    //Write enable
    wire i_write_en;
    assign ui_in[0] = i_write_en;
    //Address inputs
    wire [5:0] i_address;
    assign ui_in[7:2] = i_address;
    //Data inputs
    wire [7:0]  i_data;
    assign uio_in[7:0] = i_data;
    //Data outputs
    wire [7:0] o_data = uio_out[7:0];
    //PWM outputs
    wire o_pwm1A = uo_out[0];
    wire o_pwm1B = uo_out[1];
    wire o_pwm2A = uo_out[2];
    wire o_pwm2B = uo_out[3];
    wire o_pwm3A = uo_out[4];
    wire o_pwm3B = uo_out[5];

    tt_um_eldritch_pwm_peripheral tt_um_eldritch_pwm_peripheral (
    // include power ports for the Gate Level test
    `ifdef GL_TEST
        .VPWR( 1'b1),
        .VGND( 1'b0),
    `endif
        .ui_in      (ui_in),    // Dedicated inputs
        .uo_out     (uo_out),   // Dedicated outputs
        .uio_in     (uio_in),   // IOs: Input path
        .uio_out    (uio_out),  // IOs: Output path
        .uio_oe     (uio_oe),   // IOs: Enable path (active high: 0=input, 1=output)
        .ena        (ena),      // enable - goes high when design is selected
        .clk        (clk),      // clock
        .rst_n      (rst_n)     // not reset
        );

endmodule
