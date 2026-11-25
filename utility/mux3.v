`timescale 1ns/1ps

module mux3 
    #(parameter WIDTH = 32)(
    input sel0, sel1,
    input [WIDTH-1: 0] d0, d1, d2, d3,
    output [WIDTH-1: 0] y
);

assign y = sel1 ? (sel0 ? d3 : d2) : sel0 ? d1 : d0;

endmodule
