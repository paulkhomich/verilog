module twofive(
    input   logic   clk, rst, in    ,
    output  logic   valid
);
    // ---  GLOBAL WIRES    ---
    logic last; // is 5-th bit 
    // ---  CLOCK COUNTER   ---
    enum logic [2:0] {C0, C1, C2, C3, C4} counter;
    always_ff @(posedge clk, posedge rst)
        if (rst)    counter <= C0;
        else case(counter)
            C0:     counter <= C1;
            C1:     counter <= C2;
            C2:     counter <= C3;
            C3:     counter <= C4;
            C4:     counter <= C0;
        default:    counter <= C0;
        endcase
    assign last = counter == C4;
    // ---  '1' COUNTER     ---
    enum logic [1:0] {U0, U1, U2, OVER} units;
    always_ff @(posedge clk, posedge rst)
        if (rst)    units <= U0;
        else case (units)
            U0:     units <= (last) ? U0 : (in) ? U1      : U0;
            U1:     units <= (last) ? U0 : (in) ? U2      : U1;
            U2:     units <= (last) ? U0 : (in) ? OVER    : U2;
            OVER:   units <= (last) ? U0 : (in) ? OVER    : OVER;
        endcase
    assign valid = (units == U2 && last && !in) || (units == U1 && last && in);

endmodule: twofive

module test;
    logic   clk, rst, in;
    logic   valid;

    twofive dut (.*);

    initial     $dumpfile("dump.vcd");
    initial     $dumpvars(0, test);
    initial     clk = 0;
    initial     rst = 1;
    initial     in  = 0;
    always  #1  clk = ~clk;
    initial #40 $finish;

    initial #2  rst = 0;

    initial #2 begin
        in = 1;
    #2  in = 0;
    #2  in = 0;
    #2  in = 1;
    #2  in = 0;

    #2  in = 0;
    #2  in = 1;
    #2  in = 1;
    #2  in = 1;
    #2  in = 1;

    #2  in = 0;
    #2  in = 0;
    #2  in = 0;
    #2  in = 1;
    #2  in = 1;
    end

endmodule: test