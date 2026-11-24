module thirty_two_bit_adder(
    input [31:0] a, b,
    input cin,
    output [31:0] sum,
    output cout
    );
    wire [1:0] pg_16, gg_16;
    wire c_16;
    sixteen_bit_cla cla_one (.a(a[15:0]), .b(b[15:0]), .cin(cin), .sum(sum[15:0]), .pg(pg_16[0]), .gg(gg_16[0]));
    assign c_16 = gg_16[0] | (pg_16[0] & cin);
    sixteen_bit_cla cla_two (.a(a[31:16]), .b(b[31:16]), .cin(c_16), .sum(sum[31:16]), .pg(pg_16[1]), .gg(gg_16[1]));
    assign c_out = gg_16[1] | (pg_16[1] & cin);
    
endmodule