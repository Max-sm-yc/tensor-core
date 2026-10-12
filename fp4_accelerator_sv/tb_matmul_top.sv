`timescale 1ns/1ps

import types_pkg::*;

module tb_matmul_top;
    logic clk = 0;
    logic rst;
    logic en;

    fp4_t a00, a01, a10, a11;
    fp4_t b00, b01, b10, b11;

    logic signed [10:0] c00, c01, c10, c11;

    matmul_top matmul(
        .clk(clk),
        .rst(rst),
        .en(en),

        .a00(a00),
        .a01(a01),
        .a10(a10),
        .a11(a11),

        .b00(b00),
        .b01(b01),
        .b10(b10),
        .b11(b11),

        .c00(c00),
        .c01(c01),
        .c10(c10),
        .c11(c11)
    );

    always #5 clk = ~clk;

    always @(posedge clk) begin
        #1;
        $display(
            "time=%0t rst=%b en=%b cycle=%0d | A0=%0d B0=%0d | C=[%0d,%0d,%0d,%0d]",
            $time,
            rst,
            en,
            matmul.scheduler.cycle,
            matmul.sched_a_row0,
            matmul.sched_b_col0,
            c00, c01, c10, c11
        );
    end

    initial begin
        rst = 1;
        en = 0;
            
        a00 = 4'b0010;
        a01 = 4'b0100;
        a10 = 4'b0101;
        a11 = 4'b0110;

        b00 = 4'b0100;
        b01 = 4'b0000;
        b10 = 4'b0010;
        b11 = 4'b0101;
        
        repeat (2) @(negedge clk);
        rst = 0;
        en = 1;

        repeat (4) @(posedge clk);

        #1;

        $display("C =");
        $display("[%0d], [%0d]", c00, c01);
        $display("[%0d], [%0d]", c10, c11);

        $finish;

    end
endmodule