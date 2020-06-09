module test;
    logic clk, rst, in;
    logic send, done, OKT, OKR;
    logic [10:0] msg;

    CRCTransmitter dutTR (.OK(OKT), .*);
    CRCReceiver    dutRC (.OK(OKR), .in(send), .*);

    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(0, test);
        #128 $finish;
    end

    initial begin
        clk = 0;
        rst = 1;
        #2 rst =0;
    end
    always #1 clk = ~clk;

    initial begin
        #2 in = 0;
        #2 in = 1;
        #2 in = 0;
        #2 in = 1;
        #2 in = 1;
        #2 in = 1;
        #2 in = 0;
        #2 in = 0;
        #2 in = 1;
        #2 in = 0;
        #2 in = 1;
    end

endmodule: test 