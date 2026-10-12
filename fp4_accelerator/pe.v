module pe (
    input wire clk,
    input wire rst,
    input wire en,

    input wire signed [4:0] a_in,
    input wire signed [4:0] b_in,

    output reg signed [4:0] a_out,
    output reg signed [4:0] b_out,
    output reg signed [10:0] acc
);
    always @(posedge clk) begin
        if (rst) begin
            a_out <= 0;
            b_out <= 0;
            acc <= 0;
        end
        else if (en) begin
            a_out <= a_in;
            b_out <= b_in;
            acc <= acc + (a_in * b_in);
        end
    end
endmodule
