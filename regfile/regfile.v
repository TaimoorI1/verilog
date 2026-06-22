module regfile (
    input         clk,
    input  [4:0]  ra1,    // read address 1
    input  [4:0]  ra2,    // read address 2
    input  [4:0]  wa,     // write address
    input  [31:0] wd,     // write data
    input         we,     // write enable
    output [31:0] rd1,    // read data 1
    output [31:0] rd2     // read data 2
);

    reg [31:0] registers [0:31];

    // two combinational read ports
    assign rd1 = (ra1 == 0) ? 32'b0 : registers[ra1];
    assign rd2 = (ra2 == 0) ? 32'b0 : registers[ra2];

    // clocked write port
    always @(posedge clk)
        if (we) registers[wa] <= wd;

endmodule