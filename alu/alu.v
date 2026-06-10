module alu #(
    parameter WIDTH = 32
)(
    input      [WIDTH-1:0] a,
    input      [WIDTH-1:0] b,
    input      [3:0]       alu_op,
    output reg [WIDTH-1:0] result,
    output                 zero
);

    localparam ADD = 4'b0000;
    localparam SUB = 4'b0001;
    localparam AND = 4'b0010;
    localparam OR  = 4'b0011;
    localparam XOR = 4'b0100;
    localparam SLT = 4'b0101;
    localparam SLL = 4'b0110;
    localparam SRL = 4'b0111;
    localparam SRA = 4'b1000;

    always @(*) begin
        case (alu_op)
            ADD: result = a + b;
            SUB: result = a - b;
            AND: result = a & b;
            OR:  result = a | b;
            XOR: result = a ^ b;
            SLT: result = ($signed(a) < $signed(b)) ? 32'd1 : 32'd0;
            SLL: result = a << b[4:0];
            SRL: result = a >> b[4:0];
            SRA: result = $signed(a) >>> b[4:0]; // arithmetic: preserves sign bit
            default: result = {WIDTH{1'b0}};
        endcase
    end

    assign zero = ~|result; // asserted when result is all zeros (used by branch instructions)

endmodule