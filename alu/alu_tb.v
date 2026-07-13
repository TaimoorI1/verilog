`timescale 1ns/1ps

module alu_tb;

    localparam WIDTH = 32;

    // bench-side signals to drive/observe the ALU
    reg  [WIDTH-1:0] a, b;
    reg  [3:0]       alu_op;
    wire [WIDTH-1:0] result;
    wire             zero;

    integer errors = 0;
    integer tests  = 0;

    // plug ALU into the socket
    alu #(.WIDTH(WIDTH)) dut (
        .a(a), .b(b), .alu_op(alu_op),
        .result(result), .zero(zero)
    );

    // same encodings as the design
    localparam ADD = 4'b0000, SUB = 4'b0001, AND_ = 4'b0010,
               OR_ = 4'b0011, XOR_ = 4'b0100, SLT = 4'b0101,
               SLL = 4'b0110, SRL = 4'b0111, SRA = 4'b1000,
               SLTU = 4'b1100;

    // the checker: drive inputs, wait, compare against expected
    task check(
        input [3:0]       op,
        input [WIDTH-1:0] in_a,
        input [WIDTH-1:0] in_b,
        input [WIDTH-1:0] expected,
        input [127:0]     name
    );
    begin
        alu_op = op; a = in_a; b = in_b;
        #1; // let combinational logic settle
        tests = tests + 1;
        if (result !== expected) begin
            errors = errors + 1;
            $display("FAIL [%0s]: a=%h b=%h -> got %h, expected %h",
                     name, in_a, in_b, result, expected);
        end
    end
    endtask

    initial begin

        check(SRA, 32'hFFFFFFF8, 32'd1, 32'hFFFFFFFC, "SRA negative"); // -8 >>> 1 = -4
        check(SRA, 32'hFFFFFFF8, 32'd1, 32'hFFFFFFFC, "SRA negative");
        check(SRL, 32'h00010000, 32'd16, 32'h00000001, "SRL basic");
        check(SRL, 32'h000ABCD3, 32'd8, 32'h00000ABC, "SRL 2 digits");
        check(SLL, 32'h000ABCD3, 32'd8, 32'h0ABCD300, "SLL 2 digits");
        check(SLT, 32'd8, 32'd9, 32'd1, "SLT basic");
        check(SLT, 32'd9, 32'd3, 32'd0, "SLT zero");
        check(SLT, 32'hFFFFFFFF, 32'd1, 32'd1, "SLT negative");
        check(SLT, 32'd4, 32'hFFFFFFFF, 32'd0, "SLT zero negative");
        check(XOR_, 32'd3, 32'd3, 32'd0, "XOR same");
        check(XOR_, 32'd4, 32'd2, 32'd6, "XOR different");
        check(OR_, 32'hC, 32'h3, 32'hF, "OR basic"); 
        check(AND_, 32'hD, 32'h5, 32'h5, "AND basic");
        check(SUB, 32'd7, 32'd7, 32'd0, "SUB zero");
        check(SUB, 32'd4, 32'd5, 32'hFFFFFFFF, "SUB negative");
        check(ADD, 32'd7, 32'd2, 32'd9, "ADD basic");
        check(ADD, 32'hA, 32'h6, 32'h10, "ADD basic");
        check(SLTU, 32'hFFFFFFFF, 32'd1, 32'b0, "SLT unsigned");
        check(SLTU, 32'd1, 32'hFFFFFFFF, 32'b1, "SLT unsigned");
        
        if (errors == 0) $display("ALL %0d TESTS PASSED", tests);
        else             $display("%0d/%0d TESTS FAILED", errors, tests);
        $finish;
    end

endmodule