# Opensource PWM Peripheral in SKY130 PDK

![](../../workflows/gds/badge.svg) ![](../../workflows/docs/badge.svg) ![](../../workflows/wokwi_test/badge.svg) ![](../../workflows/test/badge.svg)

<img src="https://github.com/EldritchIHC/tt04-pwm-peripheral/blob/main/doc/gds_render.png">


# Introduction

The purpose of this project is to develop an Opensource PWM Peripheral with advanced functions and configurations. These capabilities are needed mostly in Power Electronics, where fine control of the control signals are crucial. The two standout functions that I have implemented are the deadband and the synchronization between counters. The deadband is a pause between the falling edge and the rising edge of the complementary PWM signals. It is needed to prevent shorting the input voltage to ground or to achieve resonance. The synchronization option is aimed at three phase inverters and interleaved DC-DC converters.

Testbenches for each module are available in the sources folder. The blackbox diagram of the project is presented below.

<img src="https://github.com/EldritchIHC/tt04-pwm-peripheral/blob/main/doc/PWM%20Peripheral%20Block.png">
## Overview of the design

TODO

## Module description

TODO

## Interface

TODO
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

The peripheral has multiple 8bit registers to configure each PWM module. The addresses are 6bit wide. The address map is available in the 'doc' folder. To configure the peripheric firstly set the write enable pin high and set the pins ui_in[7:2] with the desired address. After that set the ui_io[7:0] pins with the configuration needed to obtain the right behavior. For testing, the configutaion of the peripheral has been done using a Microblaze microcontroller(see below).
A driver library written that runs on Raspberry Pico should be available for the final ASIC.

## Testbenches and Verification

Each module has been tested through a Verilog testbench. Behavioral and post synthesis simulations have been run in Vivado to check correct functionality. The testbench files are available in the 'src' folder. The design has been teste also using a Xilinx Nexys A7 FPGA. The peripheral has been tied to the GPIO of a Microblaze microcontroller and a driver library has been written in C using Vitis. These files can be found in the 'doc' folder. Extensive testing has been done using thie method.

## Known Issues And Limitations

TODO

TODO
