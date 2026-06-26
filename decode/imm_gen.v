module imm_gen(
    input [31:0] instr ,
    output reg [31:0] out
);

    wire [6:0] opcode = instr[6:0];

    always @(*) begin 
        case (opcode)
            7'b0010011: out = {{20{instr[31]}}, instr[31:20]};
            7'b0100011: out = {{20{instr[31]}}, instr[31:25], instr[11:7]};
            default: out = 32'b0;
        endcase
    end 


endmodule