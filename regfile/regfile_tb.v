

`timescale 1ns/1ps

module regfile_tb;

    // bench-side signals that connect to DUT
    reg         clk;
    reg  [4:0]  ra1, ra2, wa;
    reg  [31:0] wd;
    reg         we;
    wire [31:0] rd1, rd2;

    integer errors = 0;
    integer tests  = 0;     

    // plug register file into socket
    regfile dut (
        .clk(clk), .ra1(ra1), .ra2(ra2),
        .wa(wa), .wd(wd), .we(we),
        .rd1(rd1), .rd2(rd2)
    );

    // clock logic: flips every 5 ns to produce rising edge every 10 ns
    initial clk = 0;
    always #5 clk = ~clk;

    // write 'data' into register 'addr'
    task write_reg(input [4:0] addr, input [31:0] data);
    begin
        wa = addr; wd = data; we = 1;
        @(posedge clk); // write lands at rising edge of clock
        #1; we = 0; // drop write-enable afterward
    end
    endtask

    // read register 'addr' on port 1 and check that it equals 'expected'
    task check_read1(input [4:0] addr, input [31:0] expected, input [127:0] name);
    begin  
        ra1 = addr;
        #1; // combinational read settling
        tests = tests + 1;
        if (rd1 !== expected) begin
            errors = errors + 1;
            $display("FAIL [%0s]: read x%0d -> got %h, expected %h", name, addr, rd1, expected);
        end
    end 
    endtask

    task check_read2(input [4:0] addr, input [31:0] expected, input [127:0] name);
    begin  
        ra2 = addr;
        #1; // combinational read settling
        tests = tests + 1;
        if (rd2 !== expected) begin
            errors = errors + 1;
            $display("FAIL [%0s]: read x%0d -> got %h, expected %h", name, addr, rd2, expected);
        end
    end 
    endtask

    initial begin 
         // ===== EXAMPLE (done for you, so you see the pattern) =====
        write_reg(5'd3, 32'd42);                      // write 42 into x3
        check_read1(5'd3, 32'd42, "write/read x3");   // read x3 back, expect 42

        // ===== YOUR TESTS GO HERE =====

        // Test 1
        write_reg(5'd6, 32'd35);
        write_reg(5'd7, 32'd15);
        check_read1(5'd6, 32'd35, "write/read x6");
        check_read2(5'd7, 32'd15, "write/read x7");

        // Test 2
        write_reg(5'd9, 32'd50);
        wa =  5'd9; wd = 32'd14; we = 0;
        @(posedge clk);
        #1; 
        check_read1(5'd9, 32'd50, "write/read x9");

        // Test 3
        check_read1(5'd0, 32'd0, "check x0 before writing");
        write_reg(5'd0, 32'd21);
        check_read1(5'd0, 32'd0, "check x0 after writing");

        // Test 4
        write_reg(5'd31, 32'd40);
        write_reg(5'd31, 32'd50);
        check_read1(5'd31, 32'd50, "overwrite x31");

        // ===== summary =====
        if (errors == 0) $display("ALL %0d TESTS PASSED", tests);
        else             $display("%0d/%0d TESTS FAILED", errors, tests);
        $finish;
    end 
    
endmodule