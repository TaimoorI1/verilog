module control_tb;

reg [6:0] opcode;
reg [2:0] funct3;
reg funct7_5;

wire reg_write;
wire alu_src;
wire [3:0] alu_control;

integer errors;
integer tests;

control dut (
    .opcode(opcode),
    .funct3(funct3),
    .funct7_5(funct7_5),
    .reg_write(reg_write),
    .alu_src(alu_src),
    .alu_control(alu_control)
);

task check;
    input [3:0] exp_alu_control;
    input exp_alu_src;
    input exp_reg_write;
    begin
        tests = tests + 1;
        if (!(alu_control == exp_alu_control && alu_src == exp_alu_src && reg_write == exp_reg_write)) begin
            errors = errors + 1;
            $display("FAIL: opcode=%b funct3=%b f7_5=%b | got ctrl=%b src=%b wr=%b, expected ctrl=%b src=%b wr=%b",
                     opcode, funct3, funct7_5,
                     alu_control, alu_src, reg_write,
                     exp_alu_control, exp_alu_src, exp_reg_write);
        end
    end
endtask

initial begin  
    errors = 0; tests = 0;
    // ADD
    opcode = 7'b0110011; funct3 = 3'b000; funct7_5 = 1'b0;
    #1;
    check(4'b0000, 1'b0, 1'b1);
    // SUB
    opcode = 7'b0110011; funct3 = 3'b000; funct7_5 = 1'b1;
    #1;
    check(4'b0001, 1'b0, 1'b1);
    // OR
    opcode = 7'b0110011; funct3 = 3'b110; funct7_5 = 1'b0;
    #1;
    check(4'b0011, 1'b0, 1'b1);
    // AND
    opcode = 7'b0110011; funct3 = 3'b111; funct7_5 = 1'b0;
    #1;
    check(4'b0010, 1'b0, 1'b1);
    // ADDI
    opcode = 7'b0010011; funct3 = 3'b000;
    #1;
    check(4'b0000, 1'b1, 1'b1);
    // garbage case ; expect default
     opcode = 7'b1111111; funct3 = 3'b000; funct7_5 = 1'b0;
    #1;
    check(4'b0000, 1'b0, 1'b0);



    $display("%0d/%0d passed", tests-errors, tests); $finish;

end

endmodule
