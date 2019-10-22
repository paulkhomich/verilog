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
    initial #2 in = 8'd20;
    initial #2 op = 3'd5;
    initial #4 apply = 1;
    initial #16 apply = 0;

    // Сложение
    initial #20 op = 3'd0;
    initial #22 apply = 1;
    initial #24 apply = 0;

    // Вычитание
    initial #28 op = 3'd1;
    initial #30 apply = 1;
    initial #32 apply = 0;

    // Произведение
    initial #36 op = 3'd2;
    initial #38 apply = 1;
    initial #40 apply = 0;

    // Деление целое
    initial #44 op = 3'd3;
    initial #46 apply = 1;
    initial #48 apply = 0;

    // Деление дробное
    initial #52 op = 3'd4;
    initial #54 apply = 1;
    initial #56 apply = 0;

    // Извлечение (До empty очереди)
    // + Некорректность (Извлечение из пустой очереди)
    initial #60 op = 3'd6;
    initial #62 apply = 1;
    initial #66 apply = 0;

    // Сброс
    initial #68 rst = 1;
    initial #69 rst = 0;

    // Некорректность кода операции
    initial #70 op = 3'd7;
    initial #72 apply = 1;
    initial #74 apply = 0;

    // Сброс
    initial #76 rst = 1;
    initial #77 rst = 0;

    // Некорректность переполнения
    initial #78 op = 3'd5;
    initial #80 apply = 1;
    initial #106 apply = 0;

     // Сброс
    initial #108 rst = 1;
    initial #109 rst = 0;

    // Некорректность — деление на 0
    initial #110 in = 8'd0;
    initial #112 apply = 1;
    initial #114 in = 8'd255;
    initial #116 op = 3'd3;

endmodule