import cocotb
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge, FallingEdge, Timer, ClockCycles

test_config_values_pwm1 = [0x17, 0x00, 0x1F, 0x12 , 0x00, 0x08, 0x00, 0x00, 0x30, 0x21, 0x00, 0x08, 0x00, 0x00, 0x30 ]
@cocotb.test()
async def test_pwm_peripheral(dut):
    dut._log.info("start")
    clock = Clock(dut.clk, 100, units="ns")
    cocotb.start_soon(clock.start())
    
    # reset
    dut.rst_n.value = 1
    dut.i_data.value = 0
    dut.i_write_en.value = 0
    await ClockCycles(dut.clk, 10)
    dut._log.info("reset")
    dut.rst_n.value = 0
    dut._log.info("write enable")
    dut.i_write_en.value = 1
    await Timer(10, units="us")
    dut.rst_n.value = 1
    await ClockCycles(dut.clk, 10)
    
    dut._log.info("starting pwm1 config")
    for i in range(0x00, 0x0F, 1):
    	dut._log.info("writing at adrress {}".format(i))
    	dut.i_address.value = i
    	dut.i_data.value = test_config_values_pwm1[i]
    	await ClockCycles(dut.clk, 8)
    	
    await ClockCycles(dut.clk, 10)
    dut.i_write_en.value = 0	
    await ClockCycles(dut.clk, 10)
    dut._log.info("verifying pwm1 config")
    for i in range(0x00, 0x0F, 1):
    	dut._log.info("checking data at adrress {}".format(i))
    	dut.i_address.value = i
    	await ClockCycles(dut.clk, 4)
    	assert int(dut.o_data.value) == test_config_values_pwm1[i]
    	await ClockCycles(dut.clk, 4)
