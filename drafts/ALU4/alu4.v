module alu4 #(
    parameter N = 32
)(
    input [2:0] f,
    input [N-1:0] a, b,
    output reg [N-1:0] y,
    output overflow, zero
);

    wire [N-1:0] _b;
    wire [N  :0] _ab;
    assign _b = f[2] ? ~b : b;
    assign _ab = a + _b + f[2];

    always @(*) begin
        case(f[1:0])
            2'b00: y = a & _b;
            2'b01: y = a | _b;
            2'b10: y = _ab;
            2'b11: y = {{(N-1){1'b0}}, _ab[N-1]};
        endcase
    end

    assign overflow = _ab[N];
    assign zero = y == 0;

endmodule