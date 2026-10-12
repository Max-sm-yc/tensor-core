
module input_scheduler (
    input wire clk,
    input wire rst,
    input wire en,

    input wire signed [4:0] a00, a01, a10, a11,
    input wire signed [4:0] b00, b01, b10, b11,

    output reg signed [4:0] a_row0,
    output reg signed [4:0] a_row1,
    output reg signed [4:0] b_col0,
    output reg signed [4:0] b_col1
);
    reg [2:0] cycle;
    always @(posedge clk) begin
        if (rst)
            cycle <= 0;
        else if (en)
            cycle <= cycle + 1'b1; 
    end

    always @(*) begin

        a_row0 = 5'sd0;
        a_row1 = 5'sd0;
        b_col0 = 5'sd0;
        b_col1 = 5'sd0;
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
            default: begin
                a_row0 = 5'sd0;
                a_row1 = 5'sd0;
                b_col0 = 5'sd0;
                b_col1 = 5'sd0;
            end
        endcase
    end
endmodule