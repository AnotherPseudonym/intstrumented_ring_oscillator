/*
 * Copyright (c) 2024 Your Name
 * SPDX-License-Identifier: Apache-2.0
 */

`default_nettype none

module tt_um_instrumented_ring_oscillator (
    input  wire [7:0] ui_in,    // Dedicated inputs
    output wire [7:0] uo_out,   // Dedicated outputs
    input  wire [7:0] uio_in,   // IOs: Input path
    output wire [7:0] uio_out,  // IOs: Output path
    output wire [7:0] uio_oe,   // IOs: Enable path (active high: 0=input, 1=output)
    input  wire       ena,      // always 1 when the design is powered, so you can ignore it
    input  wire       clk,      // clock
    input  wire       rst_n     // reset_n - low to reset
);

    // List all unused inputs to prevent warnings
    wire _unused = &{ena, clk, rst_n, 1'b0};

    // Configure bidirectional pins to be all outputs.
    assign uio_oe  = ~0;


    iro iro (.enable (ena & ui_in[0]), .hold (ui_in[1]), .bdat (ui_in[2]), .bclk (ui_in[3]), .n_stages (ui_in[7:4]), .phases ({uio_out[7:0], uo_out[7:0]}));

endmodule
