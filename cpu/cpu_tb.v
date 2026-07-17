module cpu_tb;
    reg clk;
    reg reset;

    cpu dut (
        .clk(clk),
        .reset(reset)
    );

    initial clk = 0;
    always #5 clk = ~clk;

    // instr 1 = 32'h00A00093;   addi x1, x0, 10
    // instr 2 = 32'h01400113;   addi x2, x0, 20
    // instr 3 = 32'h01E00193;   addi x3, x0, 30
    // instr 4 = 32'h0020C233;   xor  x4, x1, x2     
    // instr 5 = 32'h0020A2B3    slt  x5, x1, x2     
    // instr 6 = 32'hFF800313    addi x6, x0, -8     
    // instr 7 = 32'h40135393    srai x7, x6, 1     
    // instr 8 = 32'h00112023    sw x1, 0(x2)
    // instr 9 = 32'h00012403    lw x8, 0(x2)    




    initial begin
        reset = 1;

        dut.fetch_inst.imem_inst.mem[0] = 32'h00A00093;
        dut.fetch_inst.imem_inst.mem[1] = 32'h01400113;
        dut.fetch_inst.imem_inst.mem[2] = 32'h01E00193;
        dut.fetch_inst.imem_inst.mem[3] = 32'h0020C233;
        dut.fetch_inst.imem_inst.mem[4] = 32'h0020A2B3;
        dut.fetch_inst.imem_inst.mem[5] = 32'hFF800313;
        dut.fetch_inst.imem_inst.mem[6] = 32'h40135393;
        dut.fetch_inst.imem_inst.mem[7] = 32'h00112023;
        dut.fetch_inst.imem_inst.mem[8] = 32'h00012403;

       
        @(posedge clk);
        #1 reset = 0;

        repeat(10)@(posedge clk);

        $display("x1 expected 10, actual %0d", dut.regfile_inst.registers[1]);
        $display("x2 expected 20, actual %0d", dut.regfile_inst.registers[2]);
        $display("x3 expected 30, actual %0d", dut.regfile_inst.registers[3]);
        $display("x4 expected 30, actual %0d", dut.regfile_inst.registers[4]);
        $display("x5 expected 1, actual %0d", dut.regfile_inst.registers[5]);
        $display("x6 expected -8, actual %0d", $signed(dut.regfile_inst.registers[6]));
        $display("x7 expected -4, actual %0d", $signed(dut.regfile_inst.registers[7]));
        $display("mem[20] expected 10, actual %0d", dut.dmem_inst.storage[5]);
        $display("x8 expected 10, actual %0d", dut.regfile_inst.registers[8]);

    
        $display("PC = %0d", dut.fetch_inst.pc_inst.pc);

        $finish;

    end

endmodule
        



