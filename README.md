# Opensource PWM Peripheral in SKY130 PDK

![](../../workflows/gds/badge.svg) ![](../../workflows/docs/badge.svg) ![](../../workflows/wokwi_test/badge.svg) ![](../../workflows/test/badge.svg)

<img src="https://github.com/EldritchIHC/tt04-pwm-peripheral/blob/main/doc/gds_render.png">


# Introduction

The purpose of this project is to develop an Opensource PWM Peripheral with advanced functions and configurations. These capabilities are needed mostly in Power Electronics, where fine control of the control signals are crucial. The two standout functions that I have implemented are the deadband and the synchronization between counters. The deadband is a pause between the falling edge and the rising edge of the complementary PWM signals. It is needed to prevent shorting the input voltage to ground or to achieve resonance. The synchronization option is aimed at three phase inverters and interleaved DC-DC converters.

Testbenches for each module are available in the sources folder. The blackbox diagram of the project is presented below.

<img src="https://github.com/EldritchIHC/tt04-pwm-peripheral/blob/main/doc/PWM%20Peripheral%20Block.png">

## Overview of the design

A simplified schematic of the peripheral arhitecture can be seen below. Each module is configured by bits from the register file. Their function depends also on registers from other modules. For example the comparator's action is decided by values from the register file, but it also uses the counter register to generate the squarewave.

<img src="https://github.com/EldritchIHC/tt04-pwm-peripheral/blob/main/doc/PWM%20Peripheral%20Arhitecture.png">

## Module description

The peripheral is made out of the following modules:
- Register File
- Counters(A master and 2 slaves)
- Comparators(2 for each counter)
- Deadband Generators(1 for each comparator)

## Interface

| Inputs        | Description                                        | Outputs        | Description   |
| -----:        | ---                                                | ---            |:------ |
| ena           | Enable the design(Unused)                          | uo_out[7:6]    | Unused, tied low |
| clk           | System clock                                       | uo_out[5]      | Output for PWM1A |
| rst_n         | Reset active low                                   | uo_out[4]      | Output for PWM1B |
| ui_in[7:2]    | Address pins used to access the registers           | uo_out[3]      | Output for PWM2A |
| ui_in[1]      | Unused                                             | uo_out[2]      | Output for PWM2B |
| ui_in[0]      | Write enable for the registers                     | uo_out[1]      | Output for PWM3A |
| ui_io[7:0]    | Bidirectional data pins                            | uo_out[0]      | Output for PWM3B |


## Configuration

The peripheral has multiple 8bit registers to configure each PWM module. The addresses are 6bit wide. The address map is available in the 'doc' folder. To configure the peripheric firstly set the write enable pin high and set the pins ui_in[7:2] with the register address. After that set the ui_io[7:0] pins with the configuration needed to obtain the desired behavior. For testing, the configuration of the peripheral has been done using a Microblaze microcontroller(see below).
A driver library written that runs on Raspberry Pico should be available for the final ASIC.

## Testbenches and Verification

For starters, each module has been tested through a Verilog testbench. Behavioral and post synthesis simulations have been run in Vivado to check correct functionality. The testbench files are available in the 'src' folder. At a later stage, a cocotb testbench has been written to verify the peripheral through assertions. In this file, the desired configurations are written to the register and then read to check if the right values have been saved. At the end of the configuration, three pairs of 25% duty PWM signals with 120 degrees of phase between them should be visible. This test has been run on the Verilog and gatelevel netlist.
<img src="https://github.com/EldritchIHC/tt04-pwm-peripheral/blob/main/doc/gatelevel_gtk.jpg">
The design has been tested also using a Xilinx Nexys A7 FPGA. The peripheral has been tied to the GPIO of a Microblaze microcontroller and a driver library has been written in C using Vitis. These files can be found in the 'doc' folder. Extensive testing has been done using thie method.

## Known Issues And Limitations

The phase for the Up-Down counter mode isn't fully tested.
If a comparator is set to toggle high(set) at a value and another to toggle low(reset) at the same level the edges may be delayed by a clock level. This defect can be avoided by checking the PWM signals at the output ot by using deadband. 
