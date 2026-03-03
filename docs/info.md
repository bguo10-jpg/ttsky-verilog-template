<!---

This file is used to generate your project datasheet. Please fill in the information below and delete any unused
sections.

You can also include images in this folder and reference them in the markdown. Each image must be less than
512 kb in size, and the combined size of all images must be less than 1 MB.
-->

## How it works
This design is a modified version of my CSE 100 lab where I created a 16 bit counter. This counter used buttons to count up, down,  and to reset to the original value. It was also loadable using the converted values of the positions of the switches according to binary value. However, since there is no use of an FPGA in this project, I removed all logic in my code associated with it (Such as the Hex7Seg module, the selector, and anything involving the buttons and the switches). I did keep the loading a value logic to my counter but this time with a stationary value (which in this case is 46).
I also replaced the FDRE logic in my original 4 bit counter module with an always block in order to create the same logic.
Add8, AddSub8, fa, countUD16L, mux8bit modules are all unchanged from my original CSE 100 lab.

## How to test
In order to test if my counter worked, I created a testbench (with some help from GenAI). Since I am testing a counter, I need to make sure it correctly counts up and then counts down. I also need to make sure it can properly load the value that it is given (46) as well as count up and down even after a value is loaded. I also added a test for reseting. Since my original counter mapped counting up, down, and loading a value to specific buttons on the FPGA, I took those inputs in my top module and mapped them to ui_in values.
btnU = ui_in[0], btnD = ui_in[1], btnL = ui_in[2], btnC = ui_in[3] (btnU = Up, btnD = Down, btnC = Reset, btnL = Load). In order to test each individual scenario i set all values to 0 in the beginning, then seperatly set each value to 1 or kept it at 0 depending on what I tested.
Count up: Set btnU to 1 
Count down: Set btnD to 1
Load: Set btnL to 1
Reset: Set btnC to 1

## External hardware
N/A

## Use of GENAI
* Used GenAI to help write my testbench (The self checking + reference model parts)
* Used GenAI to write an always block for countUD4L.
