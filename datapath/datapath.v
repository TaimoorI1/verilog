module datapath (
    input clk,
    input reset
);

wire [31:0] instr;
wire [6:0] opcode;
wire [4:0] rd, rs1, rs2;
wire [2:0] funct3;
wire [6:0] funct7;
wire [31:0] imm;
wire [31:0] rd1, rd2;
wire [31:0] alu_result;
wire [31:0] pc;

// PC sends byte address to imem, imem outputs the instruction
fetch fetch_inst (
    .clk(clk),
    .reset(reset),
    .pc(pc),
    .instr(instr)
);


// instruction goes to decode, which deconstructs rs1, rs2, rd, imm
decode decode_inst (
    .instr(instr),
    .opcode(opcode),
    .rd(rd),
    .funct3(funct3),
    .rs1(rs1),
    .rs2(rs2),
    .funct7(funct7),
    .imm(imm)
);


// regfile reads rs1/rs2, outputs rd1, rd2
regfile regfile_inst (
    .clk(clk),
    .ra1(rs1),
    .ra2(rs2),
    .wa(rd),
    .wd(alu_result),
    .we(1'b1),
    .rd1(rd1),
    .rd2(rd2)
);


// ALU computes, result written back to rd at clock edge
wire alu_src = 1'b1;
wire [31:0] alu_b = alu_src ? imm : rd2;

alu alu_inst (
    .a(rd1),
    .b(alu_b),
    .alu_op(4'b0000),
    .result(alu_result)
);

endmodule