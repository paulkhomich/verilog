module testscanreg();
    reg clk, sin, test; 
    reg [0:3] data;
    wire sout;
    wire [0:3] out;

    scanreg4 testee(
        .clk(clk),
        .sin(sin),
        .test(test),
        .data(data),
        .sout(sout),
        .out(out)
    );

    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(0, testscanreg);
    end

    initial #24 $finish;
    initial clk = 0;
    initial data = 4'd3;
    always #1 clk = !clk;

    initial #8 test = 1;
    initial #8 sin = 1;
    initial #10 sin = 1;
    initial #12 sin = 0;
    initial #14 sin = 1;
    initial #16 test = 0;

endmodule