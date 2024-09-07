# Traffic Light State Machine

A state machine in VHDL that controls two 7-segment displays on an FPGA, each representing a set of traffic lights in the north-south and east-west directions.

It was the 4th lab project in the ECE 124 Digital Circuits & Systems course. 

## How it works

The lights go through 16 states and are controlled by a Moore-type finite state machine. The next state depends on the input and the current state, while the output only depends on the current state.
The two inputs to the state machine are two of the push buttons on the FPGA, representing pedestrian crossing request signals in north-south and east-west directions.
The state machine can account for pedestrian crossing signals, at which it may skip states to satisfy the request earlier.

The components of the project include:
1. The Moore Machine's state transition and output logic.
2. A holding register to retain the pedestrian crossing request and cancel it when the requested light has turned green.
3. A two-stage synchronizer to mitigate metastability.
4. A signal generator to produce the clock signals, a 1 Hz `sm_clken` and a 4 Hz `blinkSignal` to trigger state machine state changes and for the LED indicators on the FPGA, respectively. 
5. A module to light up the seven-segment display.
6. A component to filter push button signals, reducing debouncing effects.

The state transition sequence involved is:

- The north-south green light blinks for two states, while the east-west red light is on. During any of these two cases, if the east-west request is activated, then it will skip to the north-south amber light being activated.
- The north-south green light is solid for four states, while the east-west red light is on.
- The north-south amber light is on for two states, while the east-west red light is on.
- The east-west green light blinks for two states, while the north-south red light is on. During any of these two cases, if the north-south request is activated, then it will skip to the east-west amber light being activated.
- The east-west green light is solid for four states, while the north-south red light is on.
- The east-west amber light is on for two states, while the north-south red light is on.
