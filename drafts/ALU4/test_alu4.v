module test_alu4();
    reg [2:0] f;
    reg [31:0] a, b;
    wire [31:0] y;
    wire zero, overflow;

    alu4 testee(.f(f), .a(a), .b(b), .y(y), .zero(zero), .overflow(overflow));

    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(0, test_alu4);
    end
    initial #64 $finish;

    initial f = 7;
    initial a = 32'd8;
    initial b = 32'd16;
endmodule