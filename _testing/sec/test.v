module test();
    reg clk;
    wire light;
    sec testee(.clk(clk), .light(light));

    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(0, test);
    end
    initial #1000 $finish;

    initial clk = 0;
    always #1 clk = !clk;
    

endmodule