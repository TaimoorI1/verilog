# RISC-V RV32I CPU Core (in progress)

A RISC-V RV32I core built from scratch in Verilog, with verification as the main focus.

## ALU — Phase 2 (complete)
- 9 ops: ADD, SUB, AND, OR, XOR, SLT (signed), SLL, SRL, SRA
- Parameterized width (default 32-bit)

## Verification
Self-checking testbench (`alu_tb.v`), 18 tests, all passing. Coverage:
- Arithmetic including two's-complement negatives
- Bitwise AND / OR / XOR
- Logical vs arithmetic shifts (sign extension on SRA)
- Signed set-less-than with negative operands
- Edge cases: shift by non-nibble amounts, wrap-around addition

## Run the tests
```bash
iverilog -o alu_sim alu.v alu_tb.v
vvp alu_sim
```

## Roadmap
- [x] Phase 1 — Verilog fluency
- [x] Phase 2 — ALU + testbench
- [ ] Phase 3 — Register file
- [ ] Phase 4 — Datapath / pipeline + hazards
