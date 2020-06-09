/*
    Вычислитель CRC
    Инициализируется единицами (для распознавания нулевых НАЧАЛЬНЫХ последовательностей)
    Отправляется инверсный остаток (для распознавания нулевыъ КОНЕЧНЫХ послед-стей)
    Остаток константен:     01100
    Полином:                x5+x2+1
*/
module CRCCalc(
    input   logic       clk, rst, clr   ,
    input   logic       in              ,
    output  logic [4:0] out             ,
    output  logic       OK
);
    logic [4:0] modulo;
    wire logic [4:0] next = {
        modulo[3],
        modulo[2],
        in ^ modulo[4] ^ modulo[1],
        modulo[0],
        in ^ modulo[4]
    };
    
    always_ff @(posedge clk, posedge rst)
        if (rst)        modulo <= '1;
        else if (clr)   modulo <= '1;
        else            modulo <= next;
    
    assign out = next;
    assign OK  = next == 5'b01100;

endmodule: CRCCalc

module CRCInverse(
    input   logic       clk, rst        ,
    input   logic       load            ,
    input   logic [4:0] in              ,
    output  logic       out
);
    logic [4:0] value;

    always_ff @(posedge clk, posedge rst)
        if (rst)        value <= '0;
        else if (load)  value <= ~in;
        else            value <= { value[3:0], 1'b0 };

    assign out = value[4];

endmodule: CRCInverse