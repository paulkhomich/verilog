/*  Приемник и передатчик данных 32 бит по каналу 8 бит между собой 
*/
typedef struct packed {
    logic [7:0] a;
    logic [7:0] b;
    logic [7:0] c;
    logic [7:0] d;
} pkg;

module transmitter(
    input   logic           clk, rst,
    input   pkg             value   ,
    input   logic           free    ,
    output  logic [7:0]     payload ,
    output  logic           put 
);
    // --- CONTROL SIGNALS ---
    logic load;
    enum logic [1:0] { FST, SND, THRD, FRTH } num;
    // --- CONTROL PATH ---
    enum logic [2:0] { WAIT, A, B, C, D } state;
    always_ff @(posedge clk, posedge rst)
        if (rst)    state <= WAIT;
        else case (state) 
            WAIT:   state <= (free) ? A : WAIT;
            A:      state <= B;
            B:      state <= C;  
            C:      state <= D;
            D:      state <= WAIT;
        default:    state <= WAIT;
        endcase
    
    assign put  = state != WAIT;
    assign load = state == WAIT;
    always_comb case (state)
        A:          num = FST;
        B:          num = SND;
        C:          num = THRD;
        D:          num = FRTH;
        default:    num = FST;
    endcase
    // --- DATA PATH ---
    pkg bank;
    always_ff @(posedge clk, posedge rst)
        if (rst)        bank <= 'd0;
        else if (load)  bank <= value;
    
    always @(*) case (num)
        FST:            payload = bank.a;
        SND:            payload = bank.b;
        THRD:           payload = bank.c;
        FRTH:           payload = bank.d;
    endcase


endmodule: transmitter

module receiver(
    input   logic           clk, rst,
    input   logic [7:0]     payload ,
    input   logic           put     ,
    output  logic           free    ,
    output  pkg             value   
);
    // --- CONTROL SIGNALS ---
    logic load;
    // --- CONTROL PATH ---
    enum logic { WAIT, LOAD } state;
    always_ff @(posedge clk, posedge rst) 
        if (rst)    state <= WAIT;
        else        state <= (put) ? LOAD : WAIT;
    
    assign free = state == WAIT;
    assign load = put;
    // --- DATA PATH ---
    pkg bank;
    always @(posedge clk, posedge rst)
        if (rst)        bank <= 'd0;
        else if (load)  bank <= { bank.b, bank.c, bank.d, payload };

    assign value = bank;

endmodule: receiver

module test;
    pkg valueIn, valueOut;
    logic [7:0] payload;
    logic clk, rst, free, put;

    transmitter tr (.value(valueIn), .*);
    receiver    rc (.value(valueOut), .*);

    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(0, test);
        clk = 0;
        rst = 1;
        valueIn = 32'd66111;

        #64 $finish;
    end

    always #1 clk = ~clk;

    initial begin
        #2 rst = 0;
    end

endmodule: test