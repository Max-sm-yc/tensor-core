import types_pkg::*;


module mac (
    input logic clk,
    input logic rst,
    input logic en,
    input int5_t a,
    input int5_t b,
    output int11_t acc
);

    always_ff @(posedge clk) begin
        if (rst)
            acc <= 11'sd0;
        else if (en)
            acc <= acc + (a * b);
    end

endmodule

module pe (
    input logic clk,
    input logic rst,
    input logic en,

    input int5_t a_in,
    input int5_t b_in,

    output int5_t a_out,
    output int5_t b_out,
    output int11_t acc
);

    mac mac_inst (
        .clk(clk),
        .rst(rst),
        .en(en),
        .a(a_in),
        .b(b_in),
        .acc(acc)
    );

    always_ff @(posedge clk) begin
        if (rst) begin
            a_out <= '0;
            b_out <= '0;
        end
        else if (en) begin
            a_out <= a_in;
            b_out <= b_in;
        end
    end
endmodule
