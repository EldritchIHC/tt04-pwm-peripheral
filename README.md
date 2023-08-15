# Opensource PWM Peripheral in SKY130 PDK

![](../../workflows/gds/badge.svg) ![](../../workflows/docs/badge.svg) ![](../../workflows/wokwi_test/badge.svg)

<img src="https://github.com/EldritchIHC/tt04-pwm-peripheral/blob/main/doc/gds_render.png">

# Introduction

TODO

## Overview of the design

TODO

## Module description

TODO

## Interface

TODO
| Inputs        | Description                                        | Outputs        | Description
| -----:        | ---                                                | ---       |:------
| ena           | Enable the design(Unused)                          | uo_out[7:6]    | Unused, tied low
| clk           | System clock                                       | uo_out[5]      | Output for PWM1A
| rst_n         | Reset active low                                   | uo_out[4]      | Output for PWM1B
| ui_in[7:2]    | Address pins used to acces the registers           | uo_out[3]      | Output for PWM2A
| ui_in[1]      | Unused                                             | uo_out[2]      | Output for PWM2B
| ui_in[0]      | Write enable for the registers                     | uo_out[1]      | Output for PWM3A
| ui_io[7:0]    | Bidirectional data pins                            | uo_out[0]      | Output for PWM3B


## Configuration

TODO

## Testbenches and Verification

TODO

## Known Issues And Limitations

TODO
