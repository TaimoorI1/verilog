module alu #(
    parameter WIDTH = 32          // a knob: how many bits wide. Default 32. Think "32" everywhere you see WIDTH.
)(
    input      [WIDTH-1:0] a,     // first number in,  32 bits  ([31:0])
    input      [WIDTH-1:0] b,     // second number in, 32 bits
    input      [3:0]       alu_op,// the "which operation?" code, 4 bits → 16 possible codes
    output reg [WIDTH-1:0] result,// the answer out, 32 bits. 'reg' only because it's set inside always.
    output                 zero   // 1-bit flag: 1 when result is all zeros
);

    // --- just giving names to numbers, so the case is readable ---
    localparam ADD = 4'b0000;     // "ADD" now means the code 0000
    localparam SUB = 4'b0001;
    localparam AND = 4'b0010;
    localparam OR  = 4'b0011;
    localparam XOR = 4'b0100;
    localparam SLT = 4'b0101;
    localparam SLL = 4'b0110;
    localparam SRL = 4'b0111;
    localparam SRA = 4'b1000;

    // --- the brain: look at alu_op, do the matching operation ---
    always @(*) begin
        case (alu_op)
            ADD: result = a + b;             // if code is ADD, answer is a+b
            // ↑ this is the only one filled in. you add the other 8 here, same shape.
            SUB: result = a - b;
            AND: result = a & b; 
            OR:  result = a | b;
            XOR: result = a ^ b;
            SLT: result = ($signed(a) < $signed(b)) ? {WIDTH{1'b0}} | 1'b1 : {WIDTH{1'b0}};
            SLL: result = a << b[4:0];
            SRL: result = a >> b[4:0];
            SRA: result = $signed(a) >>> b[4:0];

            default: result = {WIDTH{1'b0}}; // any unlisted code → output zeros (safety net)
        endcase
    end

    assign zero = ~|result;       // zero flag: "are all bits of result 0?"

endmodule