`timescale 1ns/1ps

module datapath (
    input clk, rst, pcsrc, alusrc, regwrite,
    input [1:0] resultsrc,
    input [2:0] immsrc, aluctrl,
    input [31:0] instr, readdata,
    output zero,
    output [31:0] aluresult, writedata, pc
);
    wire [31:0] pcnext, pctarget, pcplus4, immext, srca, srcb, result;
    flopr pcreg (.clk(clk), .rst(rst), .d(pcnext), .q(pc));
    thirty_two_bit_adder pcadd4(.a(pc), .b(32'd4), .sum(pcplus4), .cin(1'b0));
    thirty_two_bit_adder pcaddbranch(.a(pc), .b(immext), .sum(pctarget), .cin(1'b0));
    mux2 pcmux(.d0(pcplus4), .d1(pctarget), .sel(pcsrc), .y(pcnext));
    regfile regfile(.clk(clk), .we(regwrite), .a1(instr[19:15]), .a2(instr[24:20]), .a3(instr[11:7]), .wd3(result), .rd1(srca), .rd2(writedata));
    extender ext(.instr(instr[31:7]), .immsrc(immsrc), .immext(immext));
    mux2 srcbmux(.d0(writedata), .d1(immext), .sel(alusrc), .y(srcb));
    alu alu(.a(srca), .b(srcb), .F(aluctrl), .out(aluresult), .zero(zero));
    mux3 resultmux(.d0(aluresult), .d1(readdata), .d2(pcplus4), .sel(resultsrc), .y(result));

endmodule
