`timescale 1ns/1ps

module aludec (
    input [2:0] funct3,
    input funct7b5, op5,
    input [1:0] aluop,
    output reg [3:0] aluctrl
);
    reg alt;
    always @(*) begin
        case(funct3)
            3'b000: alt = funct7b5 & op5;
            3'b101: alt = funct7b5;
            default: alt = 1'b0;
        endcase
        case(aluop)
            2'b00: begin
                aluctrl = 4'b0000;  // add
            end
            2'b01: begin
                aluctrl = 4'b1000;  // sub
            end
            2'b10: begin
                aluctrl = {alt, funct3}; 
            end
            default: aluctrl = 4'bxxxx;
        endcase
    end
    

endmodule
