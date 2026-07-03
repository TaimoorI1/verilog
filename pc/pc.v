module pc (
    input             clk,
    input             reset,
    input      [31:0] next_pc,
    output reg [31:0] pc
);

    // clocked update:
    always @(posedge clk)
        if (reset) 
            pc <= 32'b0; // reset high, pc <= address 0
        else
            pc <= next_pc; // otherwise pc <= next_pc

endmodule