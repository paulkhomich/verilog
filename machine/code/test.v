module test();
    reg [7:0] x;
    reg [1:0] on;
    reg start, clk, rst;
    main testee(
        .clk(clk),
        .rst(rst),
        .start(start),
        .on(on),
        .x(x)
    );
    initial begin
        $dumpfile("test.vcd");
        $dumpvars(0, test);
    end

    // Начальные сбросы и приготовления
    initial begin
        rst = 0;
        clk = 1;
        start = 0;
        x = 0;
        on = 0;
    end
    always #1 clk = !clk;
    initial #2 rst = 1'd1;
    initial #3 rst = 0;
    initial #128 $finish;

    // Проверка режима 2 (Скидываем счетчик S до 001)
    initial #3 on = 2'd2;
    initial #5 on = 0;
    initial #3 start = 1'd1;
    initial #17 start = 0;

    // Проверка режима 3 (Изменение Y и S)
    initial #33 x = 8'd144;
    initial #33 on = 2'd3;
    initial #35 on = 0;

    // Проверка режима 1 (Что по 4 такта и active независим)
    initial #57 on = 2'd1;
    initial #59 on = 0;
    initial #61 start = 1'd1;
    initial #63 start = 0;

endmodule