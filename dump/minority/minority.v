// Голосование меньшинства
module minority(
    input a, b, c,
    output y
);
    assign y = ~a * ~b | ~a * ~c | ~b * ~c;
endmodule