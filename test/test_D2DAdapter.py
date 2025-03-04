
import cocotb
from cocotb.clock import Clock
from cocotb.triggers import ClockCycles


@cocotb.test()
async def test_d2d_adapter(dut):
    dut._log.info("Starting D2DAdapter Test")


    clock = Clock(dut.clock, 10, units="us")  
    cocotb.start_soon(clock.start())

 
    dut._log.info("Applying Reset")
    dut.reset.value = 0
    await ClockCycles(dut.clock, 50)  
    dut.reset.value = 1  
    await ClockCycles(dut.clock, 50)

  
    dut.io_fdi_plData_bits.value = 0x123456789ABCDEF  
    dut.io_fdi_plData_valid.value = 1

 
    dut._log.info("Waiting for output to stabilize")
    await ClockCycles(dut.clock, 200)  

  
    output_valid = dut.io_fdi_plData_valid.value.integer
    output_bits = dut.io_fdi_plData_bits.value

    dut._log.info(f"io_fdi_plData_valid = {output_valid}")
    dut._log.info(f"io_fdi_plData_bits = {hex(output_bits)}")

  
    assert output_valid == 1, "Output should be valid"
    assert output_bits != "x" and output_bits != 0, "Output data should be defined and non-zero"

