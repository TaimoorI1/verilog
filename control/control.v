module control (
    input [6:0] opcode,
    input [2:0] funct3,
    input funct7_5, 

    output reg reg_write,
    output reg alu_src,
    output reg [3:0] alu_control
);

always @(*) begin
    reg_write = 1'b0;
    alu_src = 1'b0;
    alu_control = 4'b0000;

   case (opcode)
        7'b0110011 : begin
            // signals true for all R-type operations
            reg_write = 1'b1;
            alu_src = 1'b0;
            case (funct3)
                3'b000 : alu_control = funct7_5 ? 4'b0001 : 4'b0000;
                3'b110 : alu_control = 4'b0011;
                3'b111 : alu_control = 4'b0010;
            endcase
        end

        7'b0010011 : begin
            // signals true for all I-type operations
            reg_write = 1'b1;
            alu_src = 1'b1;
            case (funct3)
                3'b000 : alu_control = 4'b0000;
            endcase
        end
   endcase
   
end 


endmodule
