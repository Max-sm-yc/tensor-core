
module systolic_array_2x2 (
    input wire signed [4:0] a_row0,
    input wire signed [4:0] a_row1,
    input wire signed [4:0] b_col0,
    input wire signed [4:0] b_col1,

    input wire clk,
    input wire rst,
    input wire en,

    output wire signed [10:0] c00,
    output wire signed [10:0] c01,
    output wire signed [10:0] c10,
    output wire signed [10:0] c11
);
    wire signed [4:0] a00_forward;
    wire signed [4:0] a01_forward;
    wire signed [4:0] b00_forward;
    wire signed [4:0] b01_forward;

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