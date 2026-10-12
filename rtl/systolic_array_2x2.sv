import types_pkg::*;


module systolic_array_2x2 (
    input int5_t a_row0,
    input int5_t a_row1,
    input int5_t b_col0,
    input int5_t b_col1,

    input logic clk,
    input logic rst,
    input logic en,

    output int11_t c00,
    output int11_t c01,
    output int11_t c10,
    output int11_t c11
);
    int5_t a00_forward;
    int5_t a01_forward;
    int5_t b00_forward;
    int5_t b01_forward;

    pe pe00 (
        .clk(clk),
        .rst(rst),
        .en(en),

        .a_in(a_row0),
        .b_in(b_col0),

        .a_out(a00_forward),
        .b_out(b00_forward),
        .acc(c00)
    );

    pe pe01 (
        .clk(clk),
        .rst(rst),
        .en(en),

        .a_in(a00_forward),
        .b_in(b_col1),

        .a_out(),
        .b_out(b01_forward),
        .acc(c01)
    );

    pe pe10 (
        .clk(clk),
        .rst(rst),
        .en(en),

        .a_in(a_row1),
        .b_in(b00_forward),

        .a_out(a01_forward),
        .b_out(),
        .acc(c10)
    );

    pe pe11 (
        .clk(clk),
        .rst(rst),
        .en(en),

        .a_in(a01_forward),
        .b_in(b01_forward),

        .a_out(),
        .b_out(),
        .acc(c11)
    );
endmodule