module zeroTo99(
    input   logic       clk, rst    ,
    input   logic       enable      ,
    output  logic [3:0] U1, U10     ,
    output  logic       overflow
);
    logic cout;
    decadeCTR d1 (.last(cout), .value(U1), .*);
    decadeCTR d2 (.last(overflow), .value(U10), .enable(cout), .*);

endmodule: zeroTo99

module decadeCTR(
    input   logic       clk, rst    ,
    input   logic       enable      ,
    output  logic       last        ,
    output  logic [3:0] value
);
    enum logic [3:0] { S0, S1, S2, S3, S4, S5, S6, S7, S8, S9 } state;
    always_ff @(posedge clk, posedge rst)
        if (rst)    state <= S0;
        else if (enable) case (state)
            S0:     state <= S1;      
            S1:     state <= S2;      
            S2:     state <= S3;      
            S3:     state <= S4;      
            S4:     state <= S5;      
            S5:     state <= S6;      
            S6:     state <= S7;      
            S7:     state <= S8;      
            S8:     state <= S9;      
            S9:     state <= S0;     
        default:    state <= S0; 
        endcase

    assign value = state;
    assign last = enable && (state == S9);

endmodule: decadeCTR

module test;
    logic clk, rst, enable, overflow;
    logic [3:0] U1, U10;

    zeroTo99 dut (.*);

    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(0, test);
        clk = 0;
        rst = 1;
        #640 $finish;
    end

    always #1 clk = ~clk;
    initial begin
        enable = 1;
        #2 rst = 0;
    end

endmodule: test