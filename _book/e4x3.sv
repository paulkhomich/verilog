module flowSum(
    input   bit             clk, rst    ,
    input   bit             go          ,
    input   logic [15:0]    in          ,
    output  bit             done, error ,
    output  logic [15:0]    sum
);
    // --- CONTROL VARIABLES ---
    bit enable, clear;
    // --- STATUS VARIABLES ---
    bit zero, ovf;
    // --- CONTROL FLOW ---
    enum logic [1:0] { WAIT, WORK, WORKERR } state, nextstate;
    always_ff @(posedge clk, posedge rst)
        if (rst)            state <= WAIT;
        else                state <= nextstate;
    always_comb
        unique case (state)
            WAIT:           nextstate = (~go)   ? WAIT  : WORK;
            WORK:           nextstate = (zero)  ? WAIT  : (ovf) ? WORKERR : WORK;
            WORKERR:        nextstate = (zero)  ? WAIT  : WORKERR;
            default:        nextstate = WAIT;
        endcase

    assign enable = go || ovf || ~zero;
    assign done   = (state == WORK || state == WORKERR) && zero;
    assign clear  = done;
    // --- DATA FLOW ---
    logic [15:0] sumReg;
    logic overflow;
    wire [16:0] nextsum = in + sumReg; // Сумма
    always_ff @(posedge clk, posedge rst)
        if (rst)            {overflow, sumReg} <= 'd0;
        else if (clear)     {overflow, sumReg} <= 'd0;
        else if (enable)    begin
                            sumReg <= nextsum;
                            overflow <= (overflow) ? overflow : nextsum[16];
        end
    
    assign zero     = in == 'd0;
    assign ovf      = overflow;
    assign sum      = sumReg;
    assign error    = (state == WORK) && ovf || (state == WORKERR);

endmodule: flowSum


module test;
    logic clk, rst, go, done, error;
    logic [15:0] in, sum;

    flowSum dut (.*);

    initial begin
        clk = 0;
        rst = 1;
        go  = 0;
        in  = 'd0;

        $dumpfile("dump.vcd");
        $dumpvars(0, test);
        #64 $finish;
    end

    always #1 clk = ~clk;
    initial begin
        #2 rst = 0;
        #2 go = 1;
           in = 'd7;
        #2 go = 0;
           in = 'd3;
        #2 in = 'd0;

    end

endmodule: test 