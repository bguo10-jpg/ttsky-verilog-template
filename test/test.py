# SPDX-FileCopyrightText: © 2024 Tiny Tapeout
# SPDX-License-Identifier: Apache-2.0

import cocotb
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge, ReadOnly


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
    for _ in range(5):
        await RisingEdge(dut.clk)

    dut.rst_n.value = 1

    async def step_and_check(update_expected=None):
        nonlocal expected, errors

        # Wait for clock edge (DUT updates here)
        await RisingEdge(dut.clk)

        # Update expected AFTER the edge
        if update_expected is not None:
            expected = update_expected(expected)

        # Let signals settle
        await ReadOnly()

        actual = dut.uo_out.value.integer

        if actual != expected:
            dut._log.error(f"ERROR: expected={expected}, got={actual}")
            errors += 1

    # -------------------------------------------------
    # Test 1: Count Up
    # -------------------------------------------------
    dut.ui_in.value = 0b00000001  # up

    for _ in range(20):
        await step_and_check(lambda x: (x + 1) & 0xFF)

    dut.ui_in.value = 0

    # -------------------------------------------------
    # Test 2: Count Down
    # -------------------------------------------------
    dut.ui_in.value = 0b00000010  # down

    for _ in range(20):
        await step_and_check(lambda x: (x - 1) & 0xFF)

    dut.ui_in.value = 0

    # -------------------------------------------------
    # Test 3: Load 46
    # -------------------------------------------------
    dut.ui_in.value = 0b00000100  # load
    await step_and_check(lambda x: 46)
    dut.ui_in.value = 0

    # -------------------------------------------------
    # Test 4: Count Up Again
    # -------------------------------------------------
    dut.ui_in.value = 0b00000001

    for _ in range(10):
        await step_and_check(lambda x: (x + 1) & 0xFF)

    dut.ui_in.value = 0

    # -------------------------------------------------
    # Test 5: Reset Button (ui_in[3])
    # -------------------------------------------------
    dut.ui_in.value = 0b00001000
    await step_and_check(lambda x: 0)
    dut.ui_in.value = 0

    # -------------------------------------------------
    # Final Result
    # -------------------------------------------------
    if errors != 0:
        raise AssertionError(f"{errors} mismatches detected")

    dut._log.info("=================================")
    dut._log.info(" ALL TESTS PASSED ")
    dut._log.info("=================================")
