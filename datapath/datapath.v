`timescale 1ns/1ps

module datapath (
    input clk, rst, pcsrc, alusrc, regwrite,
    input [1:0] resultsrc,
    input [2:0] immsrc, aluctrl,
    input [31:0] instr, readdata,
    output zero,
    output [31:0] aluresult, writedata, pc
);
    wire [31:0] pc, pcnext, pctarget, pcplus4, immext, srca, srcb, aluresult;
    flopr pcreg (.clk(clk), .rst(rst), .d(pcnext), .q(pcnext));
    extender dataextender(.instr(instr), .immsrc(immsrc), .immext(immext));
    


endmodule
