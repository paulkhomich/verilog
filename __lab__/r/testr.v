module test;
    reg clk, rst;
    wire [19:0] y;
    r testee(.clk(clk), .rst(rst), .y(y));
    initial begin
        $dumpfile("r.vcd");
        $dumpvars(0, test);
    end

    initial #20 $finish;
    initial clk = 0;
    initial rst = 0;
    initial #1 rst = 1;
    initial #2 rst = 0;
    always #1 clk = !clk;
endmodule