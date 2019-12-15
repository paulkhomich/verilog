module shift2 #(
    parameter N = 32
)(
    input [N-1:0] a,
    output [N-1:0] y
);

    assign y = {a[N-3:0], 2'b00};

endmodule