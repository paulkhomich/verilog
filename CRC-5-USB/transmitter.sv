/*
    CRC контрольная сумма дла последовательности из 11 битов
    Входная послед.:    11 бит
    Остаток размером:   5  бит
    Итоговая посылка:   16 бит
    Без задержек (лишних тактов)
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
