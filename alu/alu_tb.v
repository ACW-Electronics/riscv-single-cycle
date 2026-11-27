`timescale 1ns/1ps

// Run from the repo root: ./sim.sh alu/alu_tb.v
// Self-checking: prints FAIL lines for mismatches and a summary at the end.

module alu_tb();
    reg  [31:0] a, b;
    reg  [3:0]  F;
    wire [31:0] out;
    wire        zero;

    alu dut (.a(a), .b(b), .F(F), .out(out), .zero(zero));

    // aluctrl encoding = {alt bit, funct3}
    localparam ADD  = 4'b0000, SUB  = 4'b1000, SLL  = 4'b0001, SLT = 4'b0010,
               SLTU = 4'b0011, XOR  = 4'b0100, SRL  = 4'b0101, SRA = 4'b1101,
               OR   = 4'b0110, AND  = 4'b0111;

    integer checks = 0, fails = 0;

    // Apply one input set and compare out (and zero, derived from the expected out).
    task check(input [3:0] f, input [31:0] x, input [31:0] y, input [31:0] want);
        begin
            F = f; a = x; b = y; #1;
            checks = checks + 1;
            if (out !== want || zero !== (want == 32'b0)) begin
                fails = fails + 1;
                $display("FAIL F=%b a=%h b=%h : out=%h zero=%b, want out=%h zero=%b",
                         f, x, y, out, zero, want, want == 32'b0);
            end
        end
    endtask

    // Reference model for the random tests, written with plain Verilog operators.
    function [31:0] model(input [3:0] f, input [31:0] x, input [31:0] y);
        case (f)
            ADD:  model = x + y;
            SUB:  model = x - y;
            SLL:  model = x << y[4:0];
            SLT:  model = {31'b0, $signed(x) < $signed(y)};
            SLTU: model = {31'b0, x < y};
            XOR:  model = x ^ y;
            SRL:  model = x >> y[4:0];
            SRA:  model = $signed(x) >>> y[4:0];
            OR:   model = x | y;
            AND:  model = x & y;
            default: model = 32'b0;
        endcase
    endfunction

    reg [3:0] ops [0:9];
    integer i, j;

    initial begin
        // ---- add ----
        check(ADD, 32'd15,        32'd27,        32'd42);
        check(ADD, 32'hFFFF_FFFF, 32'd1,         32'h0000_0000);   // wraps to 0, zero = 1
        check(ADD, 32'h7FFF_FFFF, 32'd1,         32'h8000_0000);   // signed overflow, result just wraps

        // ---- sub ----
        check(SUB, 32'd20,        32'd15,        32'd5);
        check(SUB, 32'd5,         32'd20,        32'hFFFF_FFF1);   // -15
        check(SUB, 32'd10,        32'd10,        32'h0000_0000);   // zero = 1 (beq taken)
        check(SUB, 32'd0,         32'd1,         32'hFFFF_FFFF);
        check(SUB, 32'h8000_0000, 32'd1,         32'h7FFF_FFFF);   // signed overflow

        // ---- logic ----
        check(AND, 32'hAAAA_5555, 32'hFFFF_0000, 32'hAAAA_0000);
        check(OR,  32'hAAAA_5555, 32'hFFFF_0000, 32'hFFFF_5555);
        check(XOR, 32'hAAAA_5555, 32'hFFFF_0000, 32'h5555_5555);
        check(XOR, 32'h1234_5678, 32'h1234_5678, 32'h0000_0000);

        // ---- slt (signed) ----
        check(SLT, 32'd5,         32'd10,        32'd1);
        check(SLT, 32'd10,        32'd5,         32'd0);
        check(SLT, 32'd5,         32'd5,         32'd0);
        check(SLT, 32'hFFFF_FFFB, 32'd2,         32'd1);           // -5 < 2
        check(SLT, 32'hFFFF_FFFF, 32'd1,         32'd1);           // -1 < 1
        check(SLT, 32'h8000_0000, 32'd1,         32'd1);           // min < 1, subtraction overflows
        check(SLT, 32'h7FFF_FFFF, 32'h8000_0000, 32'd0);           // max < min is false, overflows

        // ---- sltu (unsigned) ----
        check(SLTU, 32'hFFFF_FFFF, 32'd1,        32'd0);           // same bits as the slt case above
        check(SLTU, 32'd1,        32'hFFFF_FFFF, 32'd1);
        check(SLTU, 32'd0,        32'd1,         32'd1);
        check(SLTU, 32'd5,        32'd5,         32'd0);
        check(SLTU, 32'h8000_0000, 32'h7FFF_FFFF, 32'd0);

        // ---- shifts: amount is b[4:0] only ----
        check(SLL, 32'd1,         32'd0,         32'd1);
        check(SLL, 32'd1,         32'd31,        32'h8000_0000);
        check(SLL, 32'd1,         32'd33,        32'd2);           // 33 & 31 = 1
        check(SLL, 32'h0000_FFFF, 32'd16,        32'hFFFF_0000);
        check(SRL, 32'h8000_0000, 32'd4,         32'h0800_0000);   // zero fill
        check(SRL, 32'hF000_0000, 32'd31,        32'd1);
        check(SRL, 32'h1234_5678, 32'd0,         32'h1234_5678);
        check(SRA, 32'h8000_0000, 32'd4,         32'hF800_0000);   // sign fill
        check(SRA, 32'h7FFF_FFFF, 32'd4,         32'h07FF_FFFF);
        check(SRA, 32'hFFFF_FFFF, 32'd31,        32'hFFFF_FFFF);
        check(SRA, 32'h8000_0000, 32'h0000_0404, 32'hF800_0000);   // srai x, x, 4: imm = 0x404

        // ---- unused code ----
        check(4'b1111, 32'd15,    32'd27,        32'd0);           // default arm

        // ---- random, every op against the reference model ----
        ops[0] = ADD; ops[1] = SUB; ops[2] = SLL; ops[3] = SLT;  ops[4] = SLTU;
        ops[5] = XOR; ops[6] = SRL; ops[7] = SRA; ops[8] = OR;   ops[9] = AND;
        for (i = 0; i < 10; i = i + 1)
            for (j = 0; j < 500; j = j + 1) begin
                a = $random; b = $random;
                check(ops[i], a, b, model(ops[i], a, b));
            end

        if (fails == 0) $display("PASS: all %0d checks", checks);
        else            $display("%0d of %0d checks FAILED", fails, checks);
        $finish;
    end
endmodule
