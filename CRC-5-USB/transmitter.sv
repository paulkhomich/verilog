/*
    CRC контрольная сумма дла последовательности из 11 битов
    Входная послед.:    11 бит
    Остаток размером:   5  бит
    Итоговая посылка:   16 бит
*/
module CRCTransmitter(
    input   logic       clk, rst    ,
    input   logic       in          ,
    output  logic       send        ,
    output  logic       OK 
);
    // -- CONTROL/DATA VARIABLES --
    logic load, hash, clr;
    logic crc, OKCRC;
    logic [4:0] calcToInverse;
    // -- CONTROL PATH --
    enum logic [3:0] { I0, I1, I2, I3, I4, I5, I6, I7, I8, I9, I10, H0, H1, H2, H3, H4 } state;
    always_ff @(posedge clk, posedge rst)
        if (rst)    state <= I0;
        else        state <= state + 1;
    
    assign load = state == I10;
    assign hash = state == H0 || state == H1 || state == H2 || state == H3 || state == H4;
    assign clr  = state == H4;
    // -- DATA PATH --
    CRCCalc     calc    (.in(send), .out(calcToInverse), .OK(OKCRC), .*);
    CRCInverse  inve    (.in(calcToInverse), .out(crc), .*);

    assign send = (hash) ? crc : in;        // Отправляем (а также считаем в CRC) ВХОД или уже сам остаток
    assign OK   = OKCRC && (state == H4);   // ОК если в конце в CRC фиксированное значение

endmodule: CRCTransmitter

/*
     x5+x2+1
*/
module CRCCalc(
    input   logic       clk, rst, clr   ,
    input   logic       in              ,
    output  logic [4:0] out             ,
    output  logic       OK
);
    logic sub = in ^ out[4];
    logic [4:0] valueToWrite;
    always_comb begin
        valueToWrite[0] = sub;
        valueToWrite[1] = out[0];
        valueToWrite[2] = out[1] ^ sub;
        valueToWrite[3] = out[2];
        valueToWrite[4] = out[3];
    end

    always_ff @(posedge clk, posedge rst)
        if (rst)        out <= '1;
        else if (clr)   out <= '1;
        else begin      out <= valueToWrite;

    assign out = valueToWrite;
    assign OK  = valueToWrite == 5'b01100;

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