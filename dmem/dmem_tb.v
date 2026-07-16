`timescale 1ns/1ps

module dmem_tb;
    reg clk;
    reg [31:0] addr;
    reg [31:0] write_data;
    reg mem_write;
    wire [31:0] read_data;

    dmem dut (
        .clk(clk), .addr(addr), .write_data(write_data),
        .mem_write(mem_write), .read_data(read_data)
    );

    initial clk = 0;
    always #5 clk = ~clk;

    initial begin
        // Test 1: write then read
        mem_write = 1;
        addr = 32'h10;
        write_data = 32'hDDDDEEEE;
        @(posedge clk); #1;
        mem_write = 0;
        if (read_data === 32'hDDDDEEEE) $display("PASS: write-read");
        else $display("FAIL: write-read, got %0h", read_data);

        // Test 2: uninitialized read
        addr = 32'h01;
        #1;
        if (read_data === 32'hxxxxxxxx) $display("PASS: uninitialized read");
        else $display("FAIL: uninitialized read, got %0h", read_data);
        
        // Test 3: write disabled
        mem_write = 0;
        addr = 32'h10;
        write_data = 32'hABCD1234;
        @(posedge clk); #1;
        if (read_data === 32'hDDDDEEEE) $display("PASS: write disabled");
        else $display("FAIL: write disabled, got %0h", read_data);

        // Test 4: No clobber
        mem_write = 1;
        addr = 32'h110;
        #1;
        write_data = 32'hAAAABBBB;
        @(posedge clk); #1;
        mem_write = 0;

        addr = 32'h10;
        #1;
        if (read_data !== 32'hDDDDEEEE) $display("FAIL: clobber, got %0h", read_data);
        else $display ("PASS: first address preserved");

        addr = 32'h110;
        if (read_data === 32'hAAAABBBB) $display("PASS: no clobber");
        else $display("FAIL: clobber, got %0h", read_data);

        $finish;
    end
endmodule
