module test();
    reg [0:31] a, b;
    wire [0:31] o;

    ieee754adder testee(.a(a), .b(b), .o(o));

    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(0, test);
    end
    initial #32 $finish;

    initial a = 32'h41600000; // 14
    initial b = 32'h40600000; // 3.5

endmodule