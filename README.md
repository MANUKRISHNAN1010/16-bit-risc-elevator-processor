16-bit Mini RISC Processor – Elevator Control System

Project Overview

This project presents the design of a 16-bit Mini RISC Processor using Verilog HDL, with an elevator control system as its practical application.

The processor demonstrates important computer architecture concepts such as instruction execution, datapath design, control logic, register operations, memory access, and processor-based I/O control.

The design is inspired by RISC architecture and uses a 12-instruction instruction set to demonstrate basic processor operations.

Objectives

- Design and implement a 16-bit Mini RISC Processor.
- Understand the working of a processor datapath and control unit.
- Implement instruction execution using Verilog HDL.
- Interface processor operations with an elevator control application.
- Explore hardware safety mechanisms in a digital control system.

Architecture and Main Components

The processor consists of the following modules:

Module| Description
Program Counter (PC)| Holds the address of the current instruction.
Instruction Memory| Stores the processor instructions.
Control Unit| Generates control signals based on the instruction.
Register File| Stores processor registers and operands.
ALU| Performs arithmetic and logical operations.
Data Memory| Provides data storage and access.
I/O Interface| Connects the processor with external inputs and outputs.
Elevator Control| Implements the elevator application logic.

Key Specifications

- Processor width: 16-bit
- Instruction set: 12 instructions
- Register file: 8 registers, each 16-bit wide
- Instruction memory: 128 × 16-bit
- Data memory: 64 × 16-bit
- HDL: Verilog
- Application: Elevator control system

Elevator Control Application

The processor is used to demonstrate basic elevator operations, including:

- Floor selection and movement control.
- Upward and downward movement.
- Same-floor request handling.
- Emergency-stop operation.
- Door and motor control.

Safety Mechanisms

The design includes safety-related control conditions:

- The motor is disabled during an emergency condition.
- The motor is disabled when the door is not closed.
- The door is allowed to open only when the motor is stopped.

Simulation and Testing

A Verilog testbench ("tb_elevator.v") is included to exercise different elevator operating conditions:

- Same-floor request.
- Upward movement.
- Downward movement.
- Emergency condition.

The source files are intended for simulation using ModelSim or another compatible Verilog simulator. Simulation results should be verified before claiming successful operation.

Repository Structure

16-bit-risc-elevator-processor/
│
├── elevator_processor_top.v
├── program_counter.v
├── instruction_memory.v
├── control_unit.v
├── register_file.v
├── alu.v
├── data_memory.v
├── io_interface.v
├── elevator_control.v
├── tb_elevator.v
│
└── README.md

Technologies Used

- Verilog HDL
- Digital Electronics
- Computer Architecture
- ModelSim / Compatible Verilog Simulator
- GitHub

Learning Outcomes

Through this project, we explored:

- RISC processor architecture.
- Datapath and control unit design.
- Verilog HDL coding.
- Instruction execution and memory operations.
- Processor-based control applications.
- Basic hardware safety concepts.

Future Improvements

- Add more instructions and processor features.
- Improve the elevator scheduling algorithm.
- Integrate FPGA-based hardware implementation.
- Expand simulation coverage with additional test cases.

Author

Manukrishnan
Electronics and Communication Engineering Student

---

Academic project: 16-bit Mini RISC Processor for Elevator Control System.
