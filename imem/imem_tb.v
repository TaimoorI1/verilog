module imem_tb;

    reg  [31:0] addr;      
    wire [31:0] instr;     

    integer errors = 0;
    integer tests  = 0;

    imem dut (
        .addr(addr),
        .instr(instr)
    );

    task check;
        input [31:0] got;
        input [31:0] expected;
        begin
            tests = tests + 1;
            if (got !== expected) begin
                errors = errors + 1;
                $display("FAIL: addr=%0d  got=%h  expected=%h", addr, got, expected);
            end else begin
                $display("PASS: addr=%0d  got=%h", addr, got);
            end
        end
    endtask

    initial begin
        // load known values into the DUT's memory
        dut.mem[0] = 32'hAAAAAAAA;   // word 0, byte addr 0
        dut.mem[1] = 32'hBBBBBBBB;   // word 1, byte addr 4
        dut.mem[2] = 32'hCCCCCCCC;   // word 2, byte addr 8

        // drive an address, wait a tick for the combinational read, check
        addr = 32'd0; #1; check(instr, 32'hAAAAAAAA);  
        addr = 32'd4; #1; check(instr, 32'hBBBBBBBB);
         addr = 32'd8; #1; check(instr,32'hCCCCCCCC);


        $display("");
        $display("%0d/%0d passed", tests - errors, tests);
        if (errors == 0) $display("ALL TESTS PASSED");
        else $display("%0d FAILED", errors);
        $finish;
    end

endmodule