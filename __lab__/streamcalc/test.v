module test;
    reg clk, rst,apply;
    reg [7:0] in;
    reg [2:0] op;
    main testee(.clk(clk), .rst(rst), .apply(apply), .in(in), .op(op));
    initial begin
        $dumpfile("main.vcd");
        $dumpvars(0, test);
    end

    initial begin
        clk = 1;
        rst = 0;
        apply = 0;
    end

    always #1 clk = !clk;
    initial #2 rst = 1;
    initial #3 rst = 0;
    initial #128 $finish;

    // Добавление чисел в очередь
    initial #1 in = 8'd20;
    initial #1 op = 3'd5;
    initial #3 apply = 1;
    initial #15 apply = 0;

    // Сложение
    initial #19 op = 3'd0;
    initial #21 apply = 1;
    initial #23 apply = 0;

    // Вычитание
    initial #27 op = 3'd1;
    initial #29 apply = 1;
    initial #31 apply = 0;

    // Произведение
    initial #35 op = 3'd2;
    initial #37 apply = 1;
    initial #39 apply = 0;

    // Деление целое
    initial #43 op = 3'd3;
    initial #45 apply = 1;
    initial #47 apply = 0;

    // Деление дробное
    initial #51 op = 3'd4;
    initial #53 apply = 1;
    initial #55 apply = 0;

    // Извлечение (До empty очереди)
    // + Некорректность (Извлечение из пустой очереди)
    initial #59 op = 3'd6;
    initial #61 apply = 1;
    initial #65 apply = 0;

    // Сброс
    initial #68 rst = 1;
    initial #69 rst = 0;

    // Некорректность кода операции
    initial #69 op = 3'd7;
    initial #71 apply = 1;
    initial #73 apply = 0;

    // Сброс
    initial #76 rst = 1;
    initial #77 rst = 0;

    // Некорректность переполнения
    initial #77 op = 3'd5;
    initial #79 apply = 1;
    initial #105 apply = 0;

     // Сброс
    initial #108 rst = 1;
    initial #109 rst = 0;

    // Некорректность — деление на 0
    initial #109 in = 8'd0;
    initial #111 apply = 1;
    initial #113 in = 8'd255;
    initial #115 op = 3'd3;

endmodule