<!---

This file is used to generate your project datasheet. Please fill in the information below and delete any unused
sections.

You can also include images in this folder and reference them in the markdown. Each image must be less than
512 kb in size, and the combined size of all images must be less than 1 MB.
-->

## How it works

This project uses ring oscillators with muxes on the inputs to allow setting an initial state or "seed". This can be configured using a clock (in3) and data (in2) similar to SPI (positive edge clocks the data in.
The in0 line is the enable to start the oscillator running, and in1 is a HOLD line that blocks one stage so that the normal long period can be obtained.
in7:in4 select the number of stages (2\*n + 5).
In order to have selectable stages without a really big mux (which would have a very different propagation speed than the other stages), two muxes per stage are used, some of them bypassing some of the chain to get the desired number of muxes. This diagram shows the short mux paths as pipes ("|"). 

  2  3   4   5   6   7   8   9  10  11  12  13
1    |   |   |   |   |   |   |   |   |   |   | 
  0 24  23  22  21  20  19  18  17  16  15  14

Note that when less than 25 stages are used, all inverters are still driven, but some outputs are not used.


## How to test

0. Hook up an analyzer / scope to the output & bidirectional channels.16 phases are driven out.
1. Select the number of stages (in7:in4).
2. If desired, seed the initial state (in3, in2).
3. Drive enable (in0) high and watch the chaos to see if it stabilizes to the longest frequency, or if high frequency modes persist.
4. The hold (in1) can be briefly drivent to get to the longest frequency. 

## External hardware

A logic analyzer will probably be the most useful tool for this - For FPGA testing, I used a Digilent Digital Discovery (DD) with this projects outputs going to DD channels 0-15, and using DD channels 24-31 to drive the project inputs.
A multi-channel oscilloscope might also be interesting to use with this.
