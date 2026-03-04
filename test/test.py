# SPDX-FileCopyrightText: © 2024 Tiny Tapeout
# SPDX-License-Identifier: Apache-2.0

import cocotb
from cocotb.clock import Clock
from cocotb.triggers import ClockCycles, RisingEdge


@cocotb.test()
async def test_project(dut):

    # Start 10ns clock
    clock = Clock(dut.clk, 10, units="ns")
    cocotb.start_soon(clock.start())

    # Initialize signals
    dut.rst_n.value = 0
    dut.ui_in.value = 0

    expected = 0
    errors = 0

    # Apply reset
    await ClockCycles(dut.clk, 2)
    dut.rst_n.value = 1

    # Helper function: one clock + check
    async def step_and_check():
        nonlocal expected, errors
        await RisingEdge(dut.clk)

        if dut.uo_out.value.integer != expected:
            dut._log.error(
                f"Mismatch: expected={expected} got={dut.uo_out.value.integer}"
            )
            errors += 1

    # --------------------
    # Test 1: Count Up
    # --------------------
    dut.ui_in.value = 0b00000001  # up
    for _ in range(20):
        expected = (expected + 1) & 0xFF
        await step_and_check()

    dut.ui_in.value = 0

    # --------------------
    # Test 2: Count Down
    # --------------------
    dut.ui_in.value = 0b00000010  # down
    for _ in range(20):
        expected = (expected - 1) & 0xFF
        await step_and_check()

    dut.ui_in.value = 0

    # --------------------
    # Test 3: Load (46)
    # --------------------
    dut.ui_in.value = 0b00000100  # load
    await RisingEdge(dut.clk)
    expected = 46
    await step_and_check()

    dut.ui_in.value = 0

    # --------------------
    # Count up again
    # --------------------
    dut.ui_in.value = 0b00000001
    for _ in range(10):
        expected = (expected + 1) & 0xFF
        await step_and_check()

    dut.ui_in.value = 0

    # --------------------
    # Reset button (ui_in[3])
    # --------------------
    dut.ui_in.value = 0b00001000  # reset button
    await RisingEdge(dut.clk)
    expected = 0
    await step_and_check()

    dut.ui_in.value = 0

    # --------------------
    # Final result
    # --------------------
    if errors == 0:
        dut._log.info("=================================")
        dut._log.info(" ALL TESTS PASSED ")
        dut._log.info("=================================")
    else:
        raise AssertionError(f"TEST FAILED with {errors} errors")
