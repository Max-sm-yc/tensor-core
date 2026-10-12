import types_pkg::*;

module fp4_decoder (
    input fp4_t fp4,
    output int5_t signed_int4
);
    int5_t magnitude;

    always_comb begin
       case (fp4[2:0])
        3'b000: magnitude = 0;
        3'b001: magnitude = 1;
        3'b010: magnitude = 2;
        3'b011: magnitude = 3;
        3'b100: magnitude = 4;
        3'b101: magnitude = 6;
        3'b110: magnitude = 8;
        3'b111: magnitude = 12;
        default: magnitude = '0;
       endcase 
    end

    assign signed_int4 = fp4[3] ? -magnitude : magnitude;
endmodule