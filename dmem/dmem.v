module dmem (
    input clk,
    input [31:0] addr,
    input [31:0] write_data,
    input mem_write,
    output [31:0] read_data
);

reg [31:0] storage [0:255];

assign read_data = storage[addr[9:2]];

always @(posedge clk)
    if (mem_write) storage[addr[9:2]] <= write_data;

endmodule
