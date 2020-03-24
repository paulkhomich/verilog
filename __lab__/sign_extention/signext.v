module signext(
    input [3:0] a,
    output [7:0] y
);
    assign y = { {(4){a[3]}}, a };
endmodule
