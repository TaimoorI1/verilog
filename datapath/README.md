# Datapath

This datapath executes the core flow of a simple single-cycle RISC-V CPU: fetch an instruction, decode it, read operands, run the ALU, and write the result back to the register file. It currently supports basic I-type ALU execution, especially `addi`.

## Architecture

The PC holds the current byte address and sends it to instruction memory. `imem` uses that byte address to output the 32-bit instruction stored at that location. On each clock edge, the PC loads `PC + 4`, which allows the CPU to step through sequential 32-bit instructions.

The instruction is decoded into fields such as `opcode`, `rd`, `rs1`, `rs2`, `funct3`, `funct7`, and `imm`. `rs1` and `rs2` are sent to the register file as read addresses, and the register file outputs the actual register values as `rd1` and `rd2`.

`rd1` becomes ALU input A. ALU input B is selected by a mux controlled by `alu_src`: when `alu_src = 0`, ALU B gets `rd2`; when `alu_src = 1`, ALU B gets `imm`. The ALU result becomes writeback data, `wd`, which is written into destination register `rd` on the clock edge when write enable is high.

## Design Decisions

Instruction memory is addressed by byte address from the PC, but the memory array stores 32-bit words. To convert the byte address into a word index, `imem` uses `addr[9:2]`. The low two bits are ignored because RISC-V instructions here are 4 bytes wide, so aligned instruction addresses advance as `0, 4, 8, 12`, with the bottom two bits always `00`.

The `alu_src` mux exists because different instruction types use different second operands. R-type instructions use a second register value (`rd2`), while I-type instructions use the immediate (`imm`). For this checkpoint, `alu_src` is hardwired to `1`, so the datapath executes I-type immediate instructions.

Control is intentionally hardwired for now: `we = 1`, `alu_src = 1`, and `alu_op` selects the current ALU operation. This is a temporary design choice to prove the datapath works before building the full control unit. These hardwired signals are the seed of the control unit, where `we` will become `reg_write`, `alu_op` will become `alu_control`, and both will be derived from `opcode`, `funct3`, and `funct7`.

## Verification

I verified the datapath using three hand-assembled I-type instructions loaded directly into instruction memory:

32'h00A00093  addi x1, x0, 10 : x1 = 10
32'h01400113  addi x2, x0, 20 : x2 = 20
32'h01E00193  addi x3, x0, 30 : x3 = 30

The testbench displayed predicted vs. actual register values by inspecting the internal register file through hierarchy.

The first simulation produced all `X` values. I localized the issue upstream: the PC was never properly reset, so instruction memory was being addressed with an unknown PC. The bug was a reset race in the testbench - reset was released before the first rising clock edge, but the PC reset was synchronous. The fix was to hold reset through a clock edge before releasing it, allowing the PC to start cleanly at 0.