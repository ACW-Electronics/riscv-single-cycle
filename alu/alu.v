module alu(
    input [31:0] a, b,
    input [2:0] F,
    output reg [31:0] out,
    output zero
    );
    wire [31:0] sum, bb;
    wire cin, slt, overflow;
    assign bb = F[0] ? ~b : b;  // if F[0] = 1, either getting difference or slt which needs ~b
    assign cin = F[0];          // if F[0] = 1, either getting difference or slt which needs cin = 1
    // Overflow logic:
    // First checks if overflow possible -  ~(F[0] ^ a[31] ^ b[31])
    // If adding two of the same sign, overflow possible
    // If subtracting different signs, overflow possible
    // Second checks if sign flipped after adding/subtracting - (a[31] ^ sum[31])
    assign overflow = ~(F[0] ^ a[31] ^ b[31]) & (a[31] ^ sum[31]);  
    assign slt = sum[31] ^ overflow;    // a < b if sum[31] is 1, meaning sum is negative or if overflow on subtraction
    thirty_two_bit_adder adder (.a(a), .b(bb), .cin(cin), .sum(sum), .cout());
    assign zero = out == 32'b0;
    
    always @(*) begin
        case(F)
            3'b000: out = sum ;   // add
            3'b001: out = sum;   // sub 
            3'b010: out = a & b;   // and
            3'b011: out = a | b;   // or
            3'b101: out = {{31{1'b0}}, slt};   // slt
            default: out = 32'b0 ;
        endcase
    end
endmodule