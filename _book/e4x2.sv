// Выявление максимального числа в последовательности чисел (in) по сигналу (start)
module maxInFlow(
    input   logic       clk, rst    ,
    input   logic       start       ,   // сигнал начала последовательности
    input   logic [7:0] in          ,   // входные числа
    output  logic       done        ,   // сигнал выдачи результата
    output  logic [7:0] max             // выдача максимума
);
    // CONTROL VARIABLES
    logic enable, clear;
    // --- CONTROL PATH ---
    enum logic { WAIT, WORK } state;
    always_ff @(posedge clk, posedge rst)
        if (rst)            state <= WAIT;
        else                state <= (start) ? WORK : WAIT;

    assign done   = (state == WORK) && ~start;
    assign enable = start;
    assign clear  = done;
    // --- DATA PATH ---
    logic [7:0] maxReg;
    always_ff @(posedge clk, posedge rst)
        if (rst)            maxReg <= 'd0;
        else if (clear)     maxReg <= 'd0;
        else if (enable)    maxReg <= (in > maxReg) ? in : maxReg;

    assign max    = maxReg;
    
endmodule: maxInFlow
