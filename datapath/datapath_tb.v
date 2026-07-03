module datapath_tb;
    reg clk;
    reg reset;

    datapath dut (
        .clk(clk),
        .reset(reset)
    );

    
    initial clk = 0;
    always #5 clk = ~clk;

    // instr 1 = 32'h00A00093;   addi x1, x0, 10
    // instr 2 = 32'h01400113;   addi x2, x0, 20
    // instr 3 = 32'h01E00193;   addi x3, x0, 30

    initial begin
        reset = 1;

        dut.fetch_inst.imem_inst.mem[0] = 32'h00A00093;
        dut.fetch_inst.imem_inst.mem[1] = 32'h01400113;
        dut.fetch_inst.imem_inst.mem[2] = 32'h01E00193;

       
        @(posedge clk);
        #1 reset = 0;

        repeat(5)@(posedge clk);

        $display("x1 expected 10, actual %0d", dut.regfile_inst.registers[1]);
        $display("x2 expected 20, actual %0d", dut.regfile_inst.registers[2]);
        $display("x3 expected 30, actual %0d", dut.regfile_inst.registers[3]);

        $display("PC = %0d", dut.fetch_inst.pc_inst.pc);

        $finish;

    end

endmodule
        



