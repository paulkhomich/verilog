module test;
    reg x, y;
    wire z;
    sum testee(.x(x), .y(y), .z(z));
    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(0, test);
    end

    initial #5 $finish;
    initial {x, y} = 0;
    always #1 {x, y} += 1;
endmodule