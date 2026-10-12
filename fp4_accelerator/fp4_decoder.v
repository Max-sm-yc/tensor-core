module fp4_decoder (
    input wire [3:0] fp4,
    output wire signed [4:0] signed_int4
);
    reg [4:0] magnitude;

    always @(*) begin
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
    end

    assign signed_int4 = fp4[3] ? -$signed(magnitude) : $signed(magnitude);
endmodule