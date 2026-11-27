`timescale 1ns/1ps

module controller (
    input [6:0] op,
    input [2:0] funct3,
    input funct7b5, zero, negative, overflow, carry,
    output regwrite, memwrite, alursrcb
    output [1:0] resultsrc, alusrca, pcsrc
    output [2:0] immsrc,
    output [3:0] aluctrl,
);  
    wire [1:0] aluop;
    wire branch, jump, jalr;
    reg taken;
    aludec aludec();

    maindec maindec(.op(op), .aluop(aluop), .regwrite(regwrite), .alusrc(), .memwrite(), .jump(), .branch(), .immsrc(), .resultsrc());
    

endmodule
