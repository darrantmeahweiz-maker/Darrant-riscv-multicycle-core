# 🚀 Darrant-V1: 32-bit RISC-V Multi-Cycle Processor Core

Hello! I'm **Darrant**, an Electrical and Electronic Engineering undergraduate at Universiti Malaya. Welcome to the repository of **Darrant-riscv-multicycle-core**! 

This project is not just another textbook CPU. It is the result of countless hours of designing, simulating, tearing down Verilog state machines, and chasing elusive timing bugs. I built this 32-bit RISC-V multi-cycle processor core from the ground up to deeply understand computer architecture, data paths, and hardware verification.

If you are a fellow hardware enthusiast, a recruiter, or just curious about processor design, feel free to explore my code!

## ✨ Key Features & Architectural Highlights

I designed this core to be robust, precise, and highly capable, achieving a **100% functional coverage of 47 target instructions**:

*   🧠 **11-State FSM Control Unit**: Instead of a basic single-cycle design, I implemented a robust multi-cycle architecture. A major challenge I overcame was the bus conflict during `JAL/JALR` execution. By splitting the jump execution into two distinct FSM states (`ExecuteJ_1` and `ExecuteJ_2`), I perfectly resolved the data hazard without stalling the pipeline.
*   ⚡ **Custom Hardware Accelerators**: To push the performance limits, I integrated two custom co-processors:
    *   **MUL Extension**: Handles 64-bit signed/unsigned multiplications (`mul`, `mulh`, `mulhsu`, `mulhu`). *Fun fact: I had to implement explicit sign-extension concatenations to prevent Verilog's notorious implicit unsigned type-casting traps!*
    *   **CRC Co-processor**: Hardware-accelerated Cyclic Redundancy Check (`crc8`, `crc16`, `crc32`) using custom bitwise polynomial logic.
*   🎯 **Surgical Load/Store Unit (LSU)**: The memory unit handles flawless byte/halfword alignment and strict sign-extensions (`lb`, `lbu`, `lh`, `lhu`) using precise byte-enable masks (`bw_i`), ensuring pristine memory operations.

## 🛠️ Exhaustive Verification

Writing the RTL was only half the battle. To ensure industrial-grade robustness, I wrote extreme testbenches ("Obstacle Courses") to stress-test the core:
*   **Control Flow Traps**: Passed 6 consecutive conditional branches and 2 jumps with hidden trap instructions. The trap register (`x31`) remained `0`.
*   **Memory Masking**: Verified surgical writes by overriding specific bytes in a 32-bit word without corrupting adjacent data.
*   **Full ISA Sweep**: All 47 instructions (R-Type, I-Type, S-Type, B-Type, U-Type, J-Type, System/Halt) have been verified against manually calculated hex expected values.

## 📁 Repository Structure

*   `design/hdl.v` - The complete top-level Verilog netlist, containing the ALU, LSU, Co-processors, Control Unit, and Registers.
*   `testbench/testbench.v` - The final rigorous testbench environment used for tape-out sign-off.

## 🤝 Let's Connect
Building this processor was an incredible journey that solidified my passion for digital IC design and hardware architecture. I'm always open to discussing tech, hardware optimization, or collaborating on cool projects. 

*Designed and verified with coffee, persistence, and a lot of Verilog.* ☕💻
