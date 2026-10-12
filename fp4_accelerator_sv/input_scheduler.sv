
import types_pkg::*;

module input_scheduler (
    input logic clk,
    input logic rst,
    input logic en,

    input int5_t a00, a01, a10, a11,
    input int5_t b00, b01, b10, b11,

    output int5_t a_row0,
    output int5_t a_row1,
    output int5_t b_col0,
    output int5_t b_col1
);
    logic [2:0] cycle;
    always_ff @(posedge clk) begin
        if (rst)
            cycle <= 0;
        else if (en && cycle < 2'd3)
            cycle <= cycle + 1'b1; 
    end

    always_comb begin

        a_row0 = '0;
        a_row1 = '0;
        b_col0 = '0;
        b_col1 = '0;
        case (cycle)
            3'd0: begin
                a_row0 = a00;
                b_col0 = b00;
            end 
            3'd1: begin
                a_row0 = a01;
                a_row1 = a10;
                b_col0 = b10;
                b_col1 = b01;
            end
            3'd2: begin
                a_row1 = a11;
                b_col1 = b11;
            end
            default: ;
        endcase
    end
endmodule