// iverilog -o regfile_sim /Users/andrewwong/riscv_cpu/regfile/regfile.v /Users/andrewwong/riscv_cpu/regfile/regfile_tb.v && vvp regfile_sim

`timescale 1ns/1ps

module regfile_tb ();
    reg clk, we;
    reg [4:0] a1, a2, a3;
    reg [31:0] wd3;
    wire [31:0] rd1, rd2;
    regfile regfile_test (.clk(clk), .we(we), .a1(a1), .a2(a2), .a3(a3), .wd3(wd3), .rd1(rd1), .rd2(rd2));

    initial begin
        $dumpfile("/Users/andrewwong/riscv_cpu/regfile/regfile.vcd");
        $dumpvars(0, regfile_tb);
        clk = 0; #5
        clk = 1; #5
        we = 1; wd3 = 32'h1234_5678; a3 = 5'b1; #5
        clk = 0; #5
        clk = 1; #5
        we = 1; wd3 = 32'hDEAD_BEEF; a3 = 5'b10; #5
        clk = 0; #5
        clk = 1; #5
        we = 0; wd3 = 32'hAAAA_AAAA; a3 = 5'b1; #5
        clk = 0; #5
        clk = 1; #5
        we = 1; wd3 = 32'hFFFF_FFFF; a3 = 5'b0; #5
        clk = 0; #5
        clk = 1; #5
        we = 0; a1 = 5'b0; a2 = 5'b0; #5
        clk = 0; #5
        a1 = 5'b1; #5
        a1 = 5'b10; #5
        clk = 1; #5
        we = 1; a1 = 5'b1; a3 = 5'b1; wd3 = 32'hAAAA_BBBB;
        clk = 0; #5
        clk = 1; #5
        a3 = 5'd31; a1 = 5'd31;
        clk = 0; #5
        clk = 1; #5

        #10
        $finish;

    end
endmodule