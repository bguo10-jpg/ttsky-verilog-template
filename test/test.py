# SPDX-FileCopyrightText: © 2024 Tiny Tapeout
# SPDX-License-Identifier: Apache-2.0

import cocotb
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge, ReadOnly


@cocotb.test()
async def test_project(dut):

    clock = Clock(dut.clk, 10, unit="ns")
    cocotb.start_soon(clock.start())

    dut.rst_n.value = 0
    dut.ui_in.value = 0

    expected = 0
    errors = 0

    # Reset
    for _ in range(5):
        await RisingEdge(dut.clk)
    dut.rst_n.value = 1

    async def step(update_expected=None):
        nonlocal expected, errors

        await RisingEdge(dut.clk)

        if update_expected is not None:
            expected = update_expected(expected)

        await ReadOnly()

        actual = dut.uo_out.value.to_unsigned()

        if actual != expected:
            dut._log.error(f"ERROR: expected={expected}, got={actual}")
            errors += 1

    # -------------------------
    # Count Up
    # -------------------------
    dut.ui_in.value = 0b00000001
    for _ in range(20):
        await step(lambda x: (x + 1) & 0xFF)

    await RisingEdge(dut.clk)
    dut.ui_in.value = 0

    # -------------------------
    # Count Down
    # -------------------------
    dut.ui_in.value = 0b00000010
    for _ in range(20):
        await step(lambda x: (x - 1) & 0xFF)

    await RisingEdge(dut.clk)
    dut.ui_in.value = 0

    # -------------------------
    # Load 46
    # -------------------------
    dut.ui_in.value = 0b00000100
    await step(lambda x: 46)

    await RisingEdge(dut.clk)
    dut.ui_in.value = 0

    # -------------------------
    # Count Up Again
    # -------------------------
    dut.ui_in.value = 0b00000001
    for _ in range(10):
        await step(lambda x: (x + 1) & 0xFF)

    await RisingEdge(dut.clk)
    dut.ui_in.value = 0

    # -------------------------
    # Reset Button
    # -------------------------
    dut.ui_in.value = 0b00001000
    await step(lambda x: 0)

    await RisingEdge(dut.clk)
    dut.ui_in.value = 0

    # -------------------------
    # Final Result
    # -------------------------
    if errors != 0:
        raise AssertionError(f"{errors} mismatches detected")

    dut._log.info("=================================")
    dut._log.info(" ALL TESTS PASSED ")
    dut._log.info("=================================")
