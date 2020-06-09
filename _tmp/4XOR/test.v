module test;
    reg [3:0] a;
    wire y;

    xor4 testee(.a(a), .y(y));
    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(0, test);
    end

    initial a = 0;
    initial #17 $finish;
    always #1 a += 1;

endmodule // testinput reg [3:0] a