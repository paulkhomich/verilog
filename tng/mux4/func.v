module func(
    input   a, b, c,
    output  y
);
    mux4 mux4_1(
        .s({a, c}),
        .d0(~b),
        .d1(b),
        .d2(~b),
        .d3(~b),
        .y(y)
    );
endmodule