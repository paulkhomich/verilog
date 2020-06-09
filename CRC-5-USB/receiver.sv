module CRCReceiver(
    input   logic           clk, rst    ,
    input   logic           in          ,
    output  logic           done, OK    ,
    output  logic [10:0]    msg
);
    // --- CONTROL/DATA VARIABLES ---
    logic isData, clr, OKCRC;
    logic [4:0] modulo;
    // --- CONTROL PATH ---
    enum logic [3:0] { I0, I1, I2, I3, I4, I5, I6, I7, I8, I9, I10, H0, H1, H2, H3, H4 } state;
    always_ff @(posedge clk, posedge rst)
        if (rst)    state <= I0;
        else        state <= state + 1;

    assign isData = state != H0 && state != H1 && state != H2 && state != H3 && state != H4;
    assign done = state == H4;
    assign clr  = state == H4;
    // --- DATA PATH ---
    always_ff @(posedge clk, posedge rst)
        if (rst)            msg <= '0;
        else if (isData)    msg <= { msg[9:0], in };

    CRCCalc     calc    (.out(modulo), .OK(OKCRC), .*);

    assign OK = done && OKCRC;

endmodule: CRCReceiver