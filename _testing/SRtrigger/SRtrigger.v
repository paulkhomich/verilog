module SRtrigger(
    input       s, r,
    output reg  q, qn
);
    always @(*) begin
        case({s, r})
            2'b10: {q, qn} = 2'b10;
            2'b01: {q, qn} = 2'b01;
            2'b00: {q, qn} = {q, qn};
            2'b11: {q, qn} = 2'bxx;
        endcase
    end
endmodule