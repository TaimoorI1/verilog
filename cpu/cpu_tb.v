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
    // instr 10 = 32'h00300493   addi x9, x0, 3
    // instr 11 = 32'h00000513   addi x10, x0, 0
    // instr 12 = 32'h00000593   addi x11, x0, 0
    // loop:
    // instr 13 = 32'h00A50513  addi x10, x10, 10 
    // instr 14 = 32'hFFF48493   addi x9,  x9,  -1
    // instr 15 = 32'h00B48463   beq  x9,  x11, done     # +8
    // instr 16 = 32'hFE000AE3   beq  x0,  x0,  loop     # -12
    // done:
    // instr 17 = 32'h06300613   addi x12, x0, 99


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
        dut.fetch_inst.imem_inst.mem[9] = 32'h00300493;
        dut.fetch_inst.imem_inst.mem[10] = 32'h00000513;
        dut.fetch_inst.imem_inst.mem[11] = 32'h00000593;
        dut.fetch_inst.imem_inst.mem[12] = 32'h00A50513;  
        dut.fetch_inst.imem_inst.mem[13] = 32'hFFF48493;  
        dut.fetch_inst.imem_inst.mem[14] = 32'h00B48463;  
        dut.fetch_inst.imem_inst.mem[15] = 32'hFE000AE3;  
        dut.fetch_inst.imem_inst.mem[16] = 32'h06300613;  

        @(posedge clk);
        #1 reset = 0;

        repeat(30)@(posedge clk);

        $display("x1 expected 10, actual %0d", dut.regfile_inst.registers[1]);
        $display("x2 expected 20, actual %0d", dut.regfile_inst.registers[2]);
        $display("x3 expected 30, actual %0d", dut.regfile_inst.registers[3]);
        $display("x4 expected 30, actual %0d", dut.regfile_inst.registers[4]);
        $display("x5 expected 1, actual %0d", dut.regfile_inst.registers[5]);
        $display("x6 expected -8, actual %0d", $signed(dut.regfile_inst.registers[6]));
        $display("x7 expected -4, actual %0d", $signed(dut.regfile_inst.registers[7]));
        $display("mem[20] expected 10, actual %0d", dut.dmem_inst.storage[5]);
        $display("x8 expected 10, actual %0d", dut.regfile_inst.registers[8]);
        $display("x9  expected 0,  actual %0d", dut.regfile_inst.registers[9]);
        $display("x10 expected 30, actual %0d", dut.regfile_inst.registers[10]);
        $display("x11 expected 0,  actual %0d", dut.regfile_inst.registers[11]);
        $display("x12 expected 99, actual %0d", dut.regfile_inst.registers[12]);

    
        $display("PC = %0d", dut.fetch_inst.pc_inst.pc);

        $finish;

    end

endmodule
        



