`timescale 1ns/1ps

module maindec (
    input [6:0] op,
    output [1:0] aluop,
    output reg regwrite, alusrc, memwrite, jump, branch
    output reg [2:0] immsrc,
    output reg [1:0] resultsrc
);
    always @(*) begin
        case(op)
            7'b0110011: begin // R-type
                regwrite <= 1'b1;
                immsrc <= 3'bxxx;
                alusrc <= 1'b0;
                memwrite <= 1'b0;
                resultsrc <= 2'b00;
                branch <= 1'b0;
                aluop <= 2'b10;
                jump <= 1'b0;
            end   
            7'b0010011: begin// I-ALU
                regwrite <= 1'b1;
                immsrc <= 3'b000;
                alusrc <= 1'b1;
                memwrite <= 1'b0;
                resultsrc <= 2'b00;
                branch <= 1'b0;
                aluop <= 2'b10;
                jump <= 1'b0;
            end   
            7'b0000011: begin   // lw
                regwrite <= 1'b1;
                immsrc <= 3'b000;
                alusrc <= 1'b1;
                memwrite <= 1'b0;
                resultsrc <= 2'b01;
                branch <= 1'b0;
                aluop <= 2'b00;
                jump <= 1'b0;
            end
            7'b0100011: begin   // sw
                regwrite <= 1'b0;
                immsrc <= 3'b001;
                alusrc <= 1'b1;
                memwrite <= 1'b1;
                resultsrc <= 2'bxx;
                branch <= 1'b0;
                aluop <= 2'b00;
                jump <= 1'b0;
                
            end
            7'b1100011: begin   // beq
                regwrite <= 1'b0;
                immsrc <= 3'b010;
                alusrc <= 1'b0;
                memwrite <= 1'b0;
                resultsrc <= 2'bxx;
                branch <= 1'b1;
                aluop <= 2'b01;
                jump <= 1'b0;
            end
            7'b1101111: begin   // jal
                regwrite <= 1'b1;
                immsrc <= 3'b011;
                alusrc <= 1'bx;
                memwrite <= 1'b0;
                resultsrc <= 2'b10;
                branch <= 1'b0;
                aluop <= 2'bxx;
                jump <= 1'b1;
            end
            default: begin
                regwrite <= 1'b1;
                immsrc <= 3'b011;
                alusrc <= 1'bx;
                memwrite <= 1'b0;
                resultsrc <= 2'b10;
                branch <= 1'b0;
                aluop <= 2'bxx;
                jump <= 1'b1;
            end
        endcase
    end
    

endmodule
