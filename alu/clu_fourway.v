module clu_fourway(
    input [3:0] pg,
    input [3:0] gg,
    input cin,
    output [3:0] c,
    output pg_super,
    output gg_super
    );
    
    //carry logic
    assign c[0] = cin;
    assign c[1] = gg[0] | (pg[0] & cin);
    assign c[2] = gg[1] | (pg[1] & gg[0]) | (pg[1] & pg[0] & cin);
    assign c[3] = gg[2] | (pg[2] & gg[1]) | (pg[2] & pg[1] & gg[0]) | (pg[2] & pg[1] & pg[0] & cin);
    
    assign pg_super = pg[3] & pg[2] & pg[1] & pg[0];
    assign gg_super = gg[3] | (pg[3] & gg[2]) | (pg[3] & pg[2] & gg[1]) | (pg[3] & pg[2] & pg[1] & gg[0]);
    
endmodule