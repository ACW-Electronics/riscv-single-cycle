module alu(
    input [31:0] a, b,
    input [3:0] F,
    output reg [31:0] out,
    output zero
    );
    wire [31:0] sum, bb;
    wire cin, cout, slt, overflow;
    wire subtract = (F == 4'b1000) | (F == 4'b0010) | (F == 4'b0011);
    assign bb = subtract ? ~b : b;  // if subtract = 1, either getting difference or slt which needs ~b
    assign cin = subtract;          // if subtract = 1, either getting difference or slt which needs cin = 1
    // Overflow logic:
    // First checks if overflow possible -  ~(subtract ^ a[31] ^ b[31])
    // If adding two of the same sign, overflow possible
    // If subtracting different signs, overflow possible
    // Second checks if sign flipped after adding/subtracting - (a[31] ^ sum[31])
    assign overflow = ~(subtract ^ a[31] ^ b[31]) & (a[31] ^ sum[31]);  
    assign slt = sum[31] ^ overflow;    // a < b if sum[31] is 1, meaning sum is negative or if overflow on subtraction
    thirty_two_bit_adder adder (.a(a), .b(bb), .cin(cin), .sum(sum), .cout(cout));
    assign zero = out == 32'b0;
    
    always @(*) begin
        case(F)
            4'b0000: out = sum ;   // add
            4'b1000: out = sum;   // sub 
            4'b0001: out = a << b[4:0];   // sll 
            4'b0010: out = {{31{1'b0}}, slt};   // slt 
            4'b0011: out = {{31{1'b0}}, ~cout};   // sltu 
            4'b0100: out = a ^ b;   // xor 
            4'b0101: out = a >> b[4:0];   // srl 
            4'b1101: out = $signed(a) >>> b[4:0];   // sra 
            4'b0110: out = a | b;   // or
            4'b0111: out = a & b;   // and 
            default: out = 32'b0;
        endcase
    end
endmodule