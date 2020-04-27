module test_fullAdd4;
    logic [3:0] a, b, o;
    logic cin, cout;

    fullAdd4 dut (o, cout, a, b, cin);

    vectorGen #(9,1) vd ({a, b, cin});
    initial $monitor("%b + %b (%b) = %b (%b)", a, b, cin, o, cout);

endmodule: test_fullAdd4


module fullAdd4(
    output logic [3:0] o,
    output logic carryOut,
    input logic [3:0] a, b,
    input logic carryIn
);
    fullAdd fa1(o[0], c1, a[0], b[0], carryIn);
    fullAdd fa2(o[1], c2, a[1], b[1], c1);
    fullAdd fa3(o[2], c3, a[2], b[2], c2);
    fullAdd fa4(o[3], carryOut, a[3], b[3], c3);

endmodule: fullAdd4


module fullAdd(
    output logic o, c,
    input logic a, b, ci
);
    xor xor1(f1, a, b);
    xor xor2(o, f1, ci);

    and and1(f2, a, b);
    and and2(f3, f1, ci);

    or or1(c, f2, f3);

endmodule: fullAdd
