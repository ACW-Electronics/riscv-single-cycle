`timescale 1ns/1ps

module maindec (
    input [6:0] op,
    output reg [1:0] aluop,
    output reg regwrite, alusrcb, memwrite, jump, branch, jalr,
    output reg [2:0] immsrc,
    output reg [1:0] resultsrc, alusrca
);
    always @(*) begin
        case(op)
            7'b0110011: begin // R-type
                regwrite = 1'b1;
                immsrc = 3'bxxx;
                alusrca = 2'b00;
                alusrcb = 1'b0;
                memwrite = 1'b0;
                resultsrc = 2'b00;
                branch = 1'b0;
                aluop = 2'b10;
                jump = 1'b0;
                jalr = 1'b0;
            end   
            7'b0010011: begin// I-ALU
                regwrite = 1'b1;
                immsrc = 3'b000;
                alusrca = 2'b00;
                alusrcb = 1'b1;
                memwrite = 1'b0;
                resultsrc = 2'b00;
                branch = 1'b0;
                aluop = 2'b10;
                jump = 1'b0;
                jalr = 1'b0;
            end   
            7'b0000011: begin   // lw
                regwrite = 1'b1;
                immsrc = 3'b000;
                alusrca = 2'b00;
                alusrcb = 1'b1;
                memwrite = 1'b0;
                resultsrc = 2'b01;
                branch = 1'b0;
                aluop = 2'b00;
                jump = 1'b0;
                jalr = 1'b0;
            end
            7'b0100011: begin   // sw
                regwrite = 1'b0;
                immsrc = 3'b001;
                alusrca = 2'b00;
                alusrcb = 1'b1;
                memwrite = 1'b1;
                resultsrc = 2'bxx;
                branch = 1'b0;
                aluop = 2'b00;
                jump = 1'b0;
                jalr = 1'b0;
            end
            7'b1100011: begin   // branch
                regwrite = 1'b0;
                immsrc = 3'b010;
                alusrca = 2'b00;
                alusrcb = 1'b0;
                memwrite = 1'b0;
                resultsrc = 2'bxx;
                branch = 1'b1;
                aluop = 2'b01;
                jump = 1'b0;
                jalr = 1'b0;
            end
            7'b1101111: begin   // jal
                regwrite = 1'b1;
                immsrc = 3'b011;
                alusrca = 2'bxx;
                alusrcb = 1'bx;
                memwrite = 1'b0;
                resultsrc = 2'b10;
                branch = 1'b0;
                aluop = 2'bxx;
                jump = 1'b1;
                jalr = 1'b0;
            end
            7'b1100111: begin   // jalr
                regwrite = 1'b1;
                immsrc = 3'b000;
                alusrca = 2'b00;
                alusrcb = 1'b1;
                memwrite = 1'b0;
                resultsrc = 2'b10;
                branch = 1'b0;
                aluop = 2'b00;
                jump = 1'b0;
                jalr = 1'b1;
            end
            7'b0110111: begin   // lui
                regwrite = 1'b1;
                immsrc = 3'b100;
                alusrca = 2'b10;
                alusrcb = 1'b1;
                memwrite = 1'b0;
                resultsrc = 2'b00;
                branch = 1'b0;
                aluop = 2'b00;
                jump = 1'b0;
                jalr = 1'b0;
            end
            7'b0010111: begin   // auipc
                regwrite = 1'b1;
                immsrc = 3'b100;
                alusrca = 2'b01;
                alusrcb = 1'b1;
                memwrite = 1'b0;
                resultsrc = 2'b00;
                branch = 1'b0;
                aluop = 2'b00;
                jump = 1'b0;
                jalr = 1'b0;
            end
            default: begin
                regwrite = 1'b0;
                immsrc = 3'bxxx;
                alusrca = 2'bxx;
                alusrcb = 1'bx;
                memwrite = 1'b0;
                resultsrc = 2'bxx;
                branch = 1'b0;
                aluop = 2'bxx;
                jump = 1'b0;
                jalr = 1'b0;
            end
        endcase
    end
    

endmodule
