module adderFlow #(
    parameter w = 6
)(
    input   logic           clk, rst                            ,
    input   logic           a, b                                ,
    input   logic           start                               ,
    output  logic [w-1:0]   sum                                 ,
    output  logic           done, cout, zero                   
);
    // --- СИГНАЛЫ ИЗ CP ---
    logic init;
    // --- СИГНАЛЫ ИЗ DP ---
    logic last;
    // --- CONTROLPATH ---
    enum logic { WAIT, SUM } state;
    always_ff @(posedge clk, posedge rst)
        if (rst)    state <= WAIT;
        else case (state)
            WAIT:   state <= (start) ? SUM  : WAIT;
            SUM:    state <= (last)  ? WAIT : SUM;
        endcase
    
    assign init = (state == WAIT) && start;
    assign done = last;
    // --- DATAPATH ---
    logic in, out, res;

    counter #(w) count (.*);
    shift   #(w) shift (.a(res), .val(sum), .*);
    adder   #(w) adder (.c(res), .cin(out), .cout(in), .*);
    regist       regis (.*);

    assign cout = out;
    assign zero = ~(|sum);

endmodule: adderFlow

// --- ПОЛНЫЙ СУММАТОР ---
module adder #(
    parameter w = 6
)(
    input   logic   a, b, cin   ,
    output  logic   c, cout
);
    assign {cout, c} = a + b + cin;

endmodule: adder

module regist(
    input   logic   clk, rst    ,
    input   logic   in          ,
    output  logic   out
);
    logic register;
    always_ff @(posedge clk, posedge rst)
        if (rst)    register <= 'd0;
        else        register <= in;
    
    assign out = register;

endmodule: regist

// --- СДВИГАЮЩИЙ РЕГИСТР ---
module shift #(
    parameter w = 6
) (
    input   logic           clk, rst    ,
    input   logic           a           ,
    output  logic [w-1:0]   val
);
    logic [w-1:0] register;
    always_ff @(posedge clk, posedge rst)
        if (rst)    register <= 'd0;
        else        register <= {a, register[w-1:1]};

    assign val = register;

endmodule: shift

module counter #(
    parameter s = 6
)(
    input   logic   clk, rst    ,
    input   logic   init        ,
    output  logic   last
);
    logic [$clog2(s-1) - 1:0] count;
    always_ff @(posedge clk, posedge rst)
        if (rst)        count <= (s-1);
        else if (init)  count <= (s-1);
        else            count <= count - 1;

    assign last = ~(|count);

endmodule: counter

module test;
    logic clk, rst, a, b, start, done, cout, zero;
    logic [5:0] sum;

    adderFlow #(6) dut (.*);

    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(0, test);

        clk = 0;
        rst = 1;
        a = 0;
        b = 0;
        start = 0;

        #64 $finish;
    end

    always #1 clk = ~clk;

    initial begin
        #2  rst = 0;
            a = 1;
        #2  start = 1;
        #2  b = 1;
            start = 0;
        #2  a = 0;
        #2  b = 0;
        #2  a = 1;
            b = 1;
        #2  a = 0;
    end

endmodule: test 