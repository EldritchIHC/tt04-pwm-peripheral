import cocotb
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge, FallingEdge, Timer, ClockCycles

test_config_pwm_master = [0x17, 0x00, 0x1F,             0x12, 0x00, 0x08, 0x00, 0x00, 0x30, 0x21, 0x00, 0x08, 0x00, 0x00, 0x30 ]
test_config_pwm_slave =  [0x17, 0x00, 0x1F, 0x00, 0x0A, 0x12, 0x00, 0x08, 0x00, 0x00, 0x30, 0x21, 0x00, 0x08, 0x00, 0x00, 0x30 ]
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
    #Configuring and verifying PWM1
    dut._log.info("starting pwm1 config")
    i = 0
    for tst_add in range(0x00, 0x0F, 1):
    	dut._log.info("writing at address {}".format(tst_add ))
    	dut.i_address.value = tst_add 
    	dut.i_data.value = test_config_pwm_master[i]
    	i = i + 1
    	await ClockCycles(dut.clk, 8)
    	
    await ClockCycles(dut.clk, 10)
    dut.i_write_en.value = 0	
    await ClockCycles(dut.clk, 10)
    
    dut._log.info("verifying pwm1 config")
    i = 0
    for tst_add  in range(0x00, 0x0F, 1):
    	dut._log.info("checking data at address {}".format(tst_add ))
    	dut.i_address.value = tst_add 
    	await ClockCycles(dut.clk, 4)
    	assert int(dut.o_data.value) == test_config_pwm_master[i]
    	i = i + 1
    	await ClockCycles(dut.clk, 4)
    
    await ClockCycles(dut.clk, 10)
    dut.i_write_en.value = 1	
    await ClockCycles(dut.clk, 10)
    	
   #Configuring and verifying PWM2
    dut._log.info("starting pwm2 config")
    i = 0
    for tst_add in range(0x0F, 0x20, 1):
    	dut._log.info("writing at address {}".format(tst_add))
    	dut.i_address.value = tst_add
    	dut.i_data.value = test_config_pwm_slave[i]
    	i = i + 1
    	await ClockCycles(dut.clk, 8)
    	
    await ClockCycles(dut.clk, 10)
    dut.i_write_en.value = 0	
    await ClockCycles(dut.clk, 10)
    
    dut._log.info("verifying pwm2 config")
    i = 0
    for tst_add in range(0x0F, 0x20, 1):
    	dut._log.info("checking data at address {}".format(tst_add))
    	dut.i_address.value = tst_add
    	await ClockCycles(dut.clk, 4)
    	assert int(dut.o_data.value) == test_config_pwm_slave[i]
    	i = i + 1
    	await ClockCycles(dut.clk, 4)
    	
    await ClockCycles(dut.clk, 10)
    dut.i_write_en.value = 1	
    await ClockCycles(dut.clk, 10)
    	
   #Configuring and verifying PWM3
    dut._log.info("starting pwm3 config")
    i = 0
    for tst_add in range(0x20, 0x31, 1):
    	dut._log.info("writing at address {}".format(tst_add))
    	dut.i_address.value = tst_add
    	dut.i_data.value = test_config_pwm_slave[i]
    	i = i + 1
    	await ClockCycles(dut.clk, 8)
    	
    await ClockCycles(dut.clk, 10)
    dut.i_write_en.value = 0	
    await ClockCycles(dut.clk, 10)
    
    
    dut._log.info("verifying pwm3 config")
    i = 0
    for tst_add in range(0x20, 0x31, 1):
    	dut._log.info("checking data at address {}".format(tst_add))
    	dut.i_address.value = tst_add
    	await ClockCycles(dut.clk, 4)
    	assert int(dut.o_data.value) == test_config_pwm_slave[i]
    	i = i + 1
    	await ClockCycles(dut.clk, 4)
    	
    await Timer(20, units="us")
