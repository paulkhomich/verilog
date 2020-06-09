module test;
    reg [3:0] in;
    wire [6:0] out;

    disp7s testee(.in(in), .out(out));
    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(0, test);
    end

    always #1 in += 1;
    initial #1 in = 0;
    initial #17 $finish;
endmodule