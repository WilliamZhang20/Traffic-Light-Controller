# Traffic Light State Machine

A state machine in VHDL that controls two 7-segment displays on an FPGA, each representing a set of traffic lights in the north-south and east-west directions.

It was the 4th lab project in the ECE 124 Digital Circuits & Systems course. 

## How it works

The lights go through 16 states and are controlled by a Mealy-type finite state machine. It can account for pedestrian crossing signals, at which it may skip states.

The components of the project include:
1. The Mealy Machine's state transition and output logic.
2. A holding register to retain the pedestrian crossing request and cancel it when the requested light has turned green.
3. A two-stage synchronizer to mitigate metastability.
4. A signal generator to produce the clock signals `sm_clken` and `blink` for the LED indicators on the FPGA and to trigger state machine state changes. 
5. A module to light up the seven-segment display.
