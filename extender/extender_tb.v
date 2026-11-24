`timescale 1ns/1ps

// iverilog -o extender_sim /Users/andrewwong/riscv_cpu/extender/extender.v /Users/andrewwong/riscv_cpu/extender/extender_tb.v && vvp extender_sim

module extender_tb ();
    reg [31:7] instr;
    reg [2:0] immsrc;
    wire [31:0] immext;

    extender dut (
        .instr(instr),
        .immsrc(immsrc),
        .immext(immext)
    );

    initial begin
        $dumpfile("extender.vcd");
        $dumpvars(0, extender_tb);

        // 1. I-Type positive (+12)
        immsrc = 3'b000;
        instr  = {12'h00C, 13'b0};
        #10;
        if (immext !== 32'h0000_000C) $display("FAIL I+ : got %h", immext);

        // 2. I-Type negative (-4)
        immsrc = 3'b000;
        instr  = {12'hFFC, 13'b0};
        #10;
        if (immext !== 32'hFFFF_FFFC) $display("FAIL I- : got %h", immext);

        // 3. S-Type positive (+36)
        immsrc = 3'b001;
        instr  = {7'b0000001, 13'b0, 5'b00100};
        #10;
        if (immext !== 32'h0000_0024) $display("FAIL S+ : got %h", immext);

        // 4. S-Type negative (-8)
        immsrc = 3'b001;
        instr  = {7'b1111111, 13'b0, 5'b11000};
        #10;
        if (immext !== 32'hFFFF_FFF8) $display("FAIL S- : got %h", immext);

        // 5. B-Type positive (+0x824)
        immsrc = 3'b010;
        instr  = {1'b0, 6'b000001, 13'b0, 4'b0010, 1'b1};
        #10;
        if (immext !== 32'h0000_0824) $display("FAIL B+ : got %h", immext);

        // 6. B-Type negative (-2052 = 0xFFFF_F7FC)
        immsrc = 3'b010;
        instr  = {1'b1, 6'b111111, 13'b0, 4'b1110, 1'b0};
        #10;
        if (immext !== 32'hFFFF_F7FC) $display("FAIL B- : got %h", immext);

        // 7. J-Type positive (+0x2802)
        immsrc = 3'b011;
        instr  = {1'b0, 10'd1, 1'b1, 8'h02, 5'b0};
        #10;
        if (immext !== 32'h0000_2802) $display("FAIL J+ : got %h", immext);

        // 8. J-Type negative (-2 = 0xFFFF_FFFE)
        immsrc = 3'b011;
        instr  = {1'b1, 10'h3FF, 1'b1, 8'hFF, 5'b0};
        #10;
        if (immext !== 32'hFFFF_FFFE) $display("FAIL J- : got %h", immext);

        // 9. U-Type (0xABCDE000)
        immsrc = 3'b100;
        instr  = {20'hABCDE, 5'b11111};
        #10;
        if (immext !== 32'hABCD_E000) $display("FAIL U  : got %h", immext);

        // 10. Default unused opcode
        immsrc = 3'b111;
        instr  = 25'h1FF_FFFF;
        #10;
        if (immext !== 32'h0000_0000) $display("FAIL DEF: got %h", immext);

        $display("extender_tb finished.");
        $finish;
    end
endmodule