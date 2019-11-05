module func(
    input   a,b,c,
    output  y
);
    mux8 mux8_1(
        .s({a, b, c}),
        .d0(1'b1),
        .d1(1'b0),
        .d2(1'b0),
        .d3(1'b1),
        .d4(1'b1),
        .d5(1'b1),
        .d6(1'b0),
        .d7(1'b0),
        .y(y)
    );
endmodule