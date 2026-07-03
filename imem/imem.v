module imem (
    input  [31:0] addr,     // byte address, straight from the PC
    output [31:0] instr     // the 32-bit instruction at that address
);

    reg [31:0] mem [0:255];     // 256 words of instruction memory

    assign instr = mem[addr[9:2]];

endmodule