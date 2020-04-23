module test();
    reg [5:0]   s;
    wire [63:0] y;

    dmux660 testee(.s(s), .y(y));
    initial begin
        $dumpfile("dump");
        $dumpvars(0, test);
    end

    initial #16 $finish;
    initial s = 6'd0;
    initial #1 s = 6'd4;
    initial #2 s = 6'd60;
    initial #3 s = 6'd1;
    initial #4 s = 6'd43;
    initial #5 s = 6'd63;
endmodule