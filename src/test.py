import cocotb
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge, FallingEdge, Timer, ClockCycles


@cocotb.test()
async def test_my_design(dut):

    # CONSTANT_CURRENT = 85
    # test different input currents
    CHANGING_CURRENT = [0,10,20,30,40,50,60]
    
    dut._log.info("start simulation")

    clock_cycles = 500

    # initialize clock
    clock = Clock(dut.clk, 1, units="ns")
    cocotb.start_soon(clock.start())

    dut.rst_n.value = 0 # low to reset
    await ClockCycles(dut.clk, 10)
    dut.rst_n.value = 1 # take out of reset

    # dut.ui_in.value = CONSTANT_CURRENT
    dut.ena.value = 1 # enable design

    for current in CHANGING_CURRENT:
        for _ in range(clock_cycles):  # run 500 clock cycles for each current
            dut.ui_in.value = current
            await RisingEdge(dut.clk)
    
    dut._log.info("Finished test!")
