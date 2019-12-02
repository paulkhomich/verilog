module test_transmitter();
    reg [7:0] x;
    reg start, clk, rst;
    wire tx, ready;

    transmitter testee(.x(x), .start(start), .clk(clk), .rst(rst), .tx(tx), .ready(ready));

    initial begin
        $dumpfile("test_transmitter.vcd");
        $dumpvars(0, test_transmitter);
    end

    initial #512 $finish;
    initial #2 rst = 0;
    initial begin
        clk = 0;
        start = 0;
        rst = 1;
        x = 8'd119;
    end
    always #1 clk = !clk;

    initial #10 start = 1'd1;
    initial #12 start = 0;

    initial #66 start = 1'd1;
    initial #68 start = 0;

    initial #194 x = 8'd129;
    initial #194 start = 1'd1;
    initial #196 start = 0;
endmodule