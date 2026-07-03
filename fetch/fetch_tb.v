module fetch_tb;

    reg clk;
    reg reset;
    wire [31:0] pc;
    wire [31:0] instr;

    // device under test
    fetch dut (
        .clk   (clk),
        .reset (reset),
        .pc    (pc),
        .instr (instr)
    );

    // clock generator: flip every 5 units
    initial clk = 0;
    always #5 clk = ~clk;

    // test script
    initial begin
        
        dut.imem_inst.mem[0] = 32'h00A00093;   // addi x1, x0, 10
        dut.imem_inst.mem[1] = 32'h01400113;   // addi x2, x0, 20
        dut.imem_inst.mem[2] = 32'h01E00193;   // addi x3, x0, 30

        reset = 1;        // hold reset high to force PC to 0
        #10;              // wait one full clock cycle
        reset = 0;        // now the PC is free to walk


        // $monitor prints automatically whenever a watched signal changes
        $monitor("time=%0t  pc=%0d  instr=%h", $time, pc, instr);

        #50;              // let it run 5 more cycles
        $finish;
    end

endmodule