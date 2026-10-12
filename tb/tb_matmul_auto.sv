`timescale 1ns/1ps

import types_pkg::*;

module tb_matmul_auto;
    logic clk = 0;
    logic rst = 1;
    logic en = 0;

    logic [3:0] dut_a00, dut_a01, dut_a10, dut_a11;
    logic [3:0] dut_b00, dut_b01, dut_b10, dut_b11;

    logic signed [10:0] dut_c00, dut_c01, dut_c10, dut_c11;

    matmul_top matmul (
        .clk(clk),
        .rst(rst),
        .en(en),

        .a00(dut_a00),
        .a01(dut_a01),
        .a10(dut_a10),
        .a11(dut_a11),

        .b00(dut_b00),
        .b01(dut_b01),
        .b10(dut_b10),
        .b11(dut_b11),

        .c00(dut_c00),
        .c01(dut_c01),
        .c10(dut_c10),
        .c11(dut_c11)
    );
    

    always #5 clk = ~clk;

    int passed = 0;
    int failed = 0;

    function automatic integer decode_fp4(
        input logic [3:0] fp4
    );
        integer magnitude;
        begin
            case (fp4[2:0])
                3'b000: magnitude = 0;
                3'b001: magnitude = 1;
                3'b010: magnitude = 2;
                3'b011: magnitude = 3;
                3'b100: magnitude = 4;
                3'b101: magnitude = 6;
                3'b110: magnitude = 8;
                3'b111: magnitude = 12;
            endcase

            decode_fp4 = fp4[3] ? -magnitude : magnitude;
        end
    endfunction

    task automatic run_test(
        input logic [3:0] a00, a01, a10, a11,
        input logic [3:0] b00, b01, b10, b11
    );

        integer e00, e01, e10, e11;
        integer c00, c01, c10, c11;

        @(negedge clk);

        rst = 1;
        en = 0;

        dut_a00 = a00;
        dut_a01 = a01;
        dut_a10 = a10;
        dut_a11 = a11;

        dut_b00 = b00;
        dut_b01 = b01;
        dut_b10 = b10;
        dut_b11 = b11;

        @(negedge clk);
        rst = 0;
        en = 1;

        repeat (4) @(posedge clk);

        @(negedge clk);

        c00 = dut_c00;
        c01 = dut_c01;
        c10 = dut_c10;
        c11 = dut_c11;

        begin
            e00 = decode_fp4(a00) * decode_fp4(b00) + decode_fp4(a01) * decode_fp4(b10);
            e01 = decode_fp4(a00) * decode_fp4(b01) + decode_fp4(a01) * decode_fp4(b11);
            e10 = decode_fp4(a10) * decode_fp4(b00) + decode_fp4(a11) * decode_fp4(b10);
            e11 = decode_fp4(a10) * decode_fp4(b01) + decode_fp4(a11) * decode_fp4(b11);

            if ((c00 !== e00) || (c01 !== e01) || (c10 !== e10) || (c11 !== e11)) begin
                failed++;
                $display("FAIL test %0d", passed+failed);
                $display("Expected: %0d %0d %0d %0d", e00, e01, e10, e11);
                $display("Actual: %0d %0d %0d %0d", c00, c01, c10, c11);
            end else begin
                passed++;
                $display("PASS test %0d", passed+failed);
            end
        end
    endtask

    initial begin
        dut_a00 = 0;
        dut_a01 = 0;
        dut_a10 = 0;
        dut_a11 = 0;

        dut_b00 = 0;
        dut_b01 = 0;
        dut_b10 = 0;
        dut_b11 = 0;


        run_test(0,0,0,0, 0,0,0,0);
        run_test(2,0,0,2, 2,0,0,2);
        run_test(7,7,7,7, 7,7,7,7);

        for (int t = 0; t < 100; t++) begin
            run_test(
                $urandom_range(0,15),
                $urandom_range(0,15),
                $urandom_range(0,15),
                $urandom_range(0,15),
                $urandom_range(0,15),
                $urandom_range(0,15),
                $urandom_range(0,15),
                $urandom_range(0,15)
            );
        end

        $display("Passed: %0d Failed %0d", passed, failed);

        if (failed > 0) 
            $fatal(1, "Verification failed");

        $finish;
    end
endmodule
