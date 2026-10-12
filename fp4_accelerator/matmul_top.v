
module matmul_top(
    input wire clk,
    input wire rst,
    input wire en,

    input wire [3:0] a00, a01, a10, a11,
    input wire [3:0] b00, b01, b10, b11,

    output wire signed [10:0] c00, c01, c10, c11
);
    wire signed [4:0] int_a00, int_a01, int_a10, int_a11;
    wire signed [4:0] int_b00, int_b01, int_b10, int_b11;

    fp4_decoder decoder_a00 (
        .fp4(a00),
        .signed_int4(int_a00)
    );
    fp4_decoder decoder_a01 (
        .fp4(a01),
        .signed_int4(int_a01)
    );
    fp4_decoder decoder_a10 (
        .fp4(a10),
        .signed_int4(int_a10)
    );
    fp4_decoder decoder_a11 (
        .fp4(a11),
        .signed_int4(int_a11)
    );
    fp4_decoder decoder_b00 (
        .fp4(b00),
        .signed_int4(int_b00)
    );
    fp4_decoder decoder_b01 (
        .fp4(b01),
        .signed_int4(int_b01)
    );
    fp4_decoder decoder_b10 (
        .fp4(b10),
        .signed_int4(int_b10)
    );
    fp4_decoder decoder_b11 (
        .fp4(b11),
        .signed_int4(int_b11)
    );

    wire signed [4:0] sched_a_row0;
    wire signed [4:0] sched_a_row1;
    wire signed [4:0] sched_b_col0;
    wire signed [4:0] sched_b_col1;

    input_scheduler scheduler (
        .clk(clk),
        .rst(rst),
        .en(en),

        .a00(int_a00),
        .a01(int_a01),
        .a10(int_a10),
        .a11(int_a11),
        .b00(int_b00),
        .b01(int_b01),
        .b10(int_b10),
        .b11(int_b11),

        .a_row0(sched_a_row0),
        .a_row1(sched_a_row1),
        .b_col0(sched_b_col0),
        .b_col1(sched_b_col1)
    );

    systolic_array_2x2 systolic_array (
        .a_row0(sched_a_row0),
        .a_row1(sched_a_row1),
        .b_col0(sched_b_col0),
        .b_col1(sched_b_col1),

        .clk(clk),
        .rst(rst),
        .en(en),

        .c00(c00),
        .c01(c01),
        .c10(c10),
        .c11(c11)
    );
endmodule