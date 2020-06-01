module init;
    bit a, b;

    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(0, init);

        a = 0; b = 1;
        #3
        a = 1; b = 0;
        #3;
        b = 1;
        #2;
        a = 0;
        #3;
        a = 1; b = 0;
        #1;
        a = 0;

        #10 $finish;
    end

endmodule: init