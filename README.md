For your VHDL project on Multi-Cycle CPU design, here is a detailed README based on the structure you have provided and incorporating the file descriptions from your GitHub repository. I have translated and included details from your provided PDF to enhance the content where necessary:

---

# Multi-Cycle CPU VHDL Project

## Overview

This project is a VHDL implementation of a Multi-Cycle CPU design. It aims to create a CPU with a micro-instruction cycle that performs operations across multiple cycles for optimized instruction throughput. The system is structured to work with the DE10 Altera board and is designed for educational purposes to illustrate the principles of CPU design.

## Table of Contents
- [System Design](#system-design)
- [Control Unit](#control-unit)
- [Data Path](#data-path)
- [Verification](#verification)
- [Additional Components](#additional-components)

## System Design

The design encapsulates all the necessary modules required for the CPU operations, which include the following components:

### File Descriptions

#### `aux_package.vhd`
Defines all component declarations, enabling interconnections between the various modules.

#### `top.vhd`
Serves as the main module, integrating control and datapath modules. It interfaces with memory and other components, orchestrating the flow of instructions and data.

Inputs/Outputs:
- Reset, clock, enable signals
- Data inputs for memory
- Control signals for operation stages
- Testbench signals

#### `control.vhd`
Implements the finite state machine of the control unit with signals to coordinate the actions of the datapath according to the current operation and state.

#### `datapath.vhd`
Responsible for the actual implementation of the system, including interactions with modules like ALU and memory components.

#### `RF.vhd`
A register file that facilitates data storage and retrieval needed for CPU operations.

#### `ProgMem.vhd` and `dataMem.vhd`
Represent program and data memory respectively, storing instructions for the CPU and the data it processes.

#### `ALU.vhd`
The arithmetic logic unit performs the mathematical and logical operations required by the CPU instructions.

#### `FA.vhd`
A full adder module used within the ALU for arithmetic operations.

#### `BidirPinBasic.vhd` and `BidirPin.vhd`
Bi-directional pin modules for interfacing with external hardware and for the bi-directional BUS within the system.

## Control Unit

The control unit is implemented as a Mealy state machine, managing control signals sent to the datapath and dealing with signals for simulation purposes. It generates control signals based on the current state and the opcode of the instruction being executed.

## Data Path

The datapath module includes all interactions between system modules, executing instructions as dictated by the control unit. It manages the system's state and data flow throughout the CPU operations.

## Verification

A series of processes are defined for system simulation, including clock generation, reset signal generation, and data loading from external files into the system memory. The verification stage simulates a sequence of instructions to test the CPU's functionality and state transitions.


**Final Note**: For a comprehensive understanding of the system's operations and the functionality of each component, please refer to the individual `.vhd` files within the project repository.
For detailed information, see this pdf:

[CPU Lab 3.pdf](https://github.com/talshva/CPU-Lab-3/files/15001424/CPU.Lab.3.pdf)

