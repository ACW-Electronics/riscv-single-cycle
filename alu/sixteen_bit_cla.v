module sixteen_bit_cla(
    input [15:0] a, b,
    input cin,
    output [15:0] sum,
    output pg, gg
    );
    wire [3:0] pg_bus, gg_bus, c;
    clu_fourway fourway_clu (.pg(pg_bus), .gg(gg_bus), .cin(cin), .c(c), .pg_super(pg), .gg_super(gg));
    four_bit_cla cla_zero (.a(a[3:0]), .b(b[3:0]), .cin(c[0]), .sum(sum[3:0]), .pg(pg_bus[0]), .gg(gg_bus[0]));
    four_bit_cla cla_one (.a(a[7:4]), .b(b[7:4]), .cin(c[1]), .sum(sum[7:4]), .pg(pg_bus[1]), .gg(gg_bus[1]));
    four_bit_cla cla_two (.a(a[11:8]), .b(b[11:8]), .cin(c[2]), .sum(sum[11:8]), .pg(pg_bus[2]), .gg(gg_bus[2]));
    four_bit_cla cla_three (.a(a[15:12]), .b(b[15:12]), .cin(c[3]), .sum(sum[15:12]), .pg(pg_bus[3]), .gg(gg_bus[3]));
    
endmodule