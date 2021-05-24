// Управление 7-сгементным индикатором
module disp7s(
    input [3:0]     in,
    output reg [6:0]    out
);
    always @(*) begin
        case(in)
            4'd00: out = 7'b111_1110;
            4'd01: out = 7'b011_0000;
            4'd02: out = 7'b110_1101;
            4'd03: out = 7'b111_1001;
            4'd04: out = 7'b011_0011;
            4'd05: out = 7'b101_1011;
            4'd06: out = 7'b101_1111;
            4'd07: out = 7'b111_0000;
            4'd08: out = 7'b111_1111;
            4'd09: out = 7'b111_1011;
            4'd10: out = 7'b111_0111;
            4'd11: out = 7'b001_1111;
            4'd12: out = 7'b100_1110;
            4'd13: out = 7'b011_1101;
            4'd14: out = 7'b100_1111;
            4'd15: out = 7'b100_0111;
            default: out = 7'b000_0000;
        endcase
    end
endmodule