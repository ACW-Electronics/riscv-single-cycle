// iverilog -o alu_sim /Users/andrewwong/riscv_cpu/alu/alu.v /Users/andrewwong/riscv_cpu/alu/alu_tb.v && vvp alu_sim

module alu_tb();
    reg [31:0] a, b;
    reg [2:0] F;
    reg [31:0] out;
    reg zero;
    alu test_alu (.a(a), .b(b), .F(F), .out(out), .zero(zero));
    initial begin
    a = 32'd15; b = 32'd27; F = 3'b000; #5; // 15 + 27 = 42
    a = 32'hFFFF_FFFF; b = 32'd1; F = 3'b000; #5; // out = 0, zero = 1
    a = 32'd20; b = 32'd15; F = 3'b001; #5; // 20 - 15 = 5
    a = 32'd5; b = 32'd20; F = 3'b001; #5; // 5 - 20 = -15
    a = 32'd10; b = 32'd10; F = 3'b001; #5; // out = 0, zero = 1
    a = 32'hAAAA_5555; b = 32'hFFFF_0000; F = 3'b010; #5; // a & b = 32'hAAAA_0000
    a = 32'hAAAA_5555; b = 32'hFFFF_0000; F = 3'b011; #5; // a | b = 32'FFFF_5555
    a = 32'd5; b = 32'd10; F = 3'b101; #5; // 5 < 10, slt = 1
    a = 32'd10; b = 32'd5; F = 32'b101; #5; // 10 < 5, slt = 0
    a = 32'd5; b = 32'd5; F = 3'b101; #5; // 5 < 5, slt = 0
    a = 32'hFFFF_FFFB; b = 32'd2; F = 32'b101; #5; // -5 < 2, slt = 1
    a = 32'h8000_0000; b = 32'h0000_0001; F = 3'b101; #5; // -2^31 < 1, slt = 1 on overflow
    a = 32'd15; b = 32'd27; F = 3'b111; #5; // default, out = 0
     
    end
endmodule