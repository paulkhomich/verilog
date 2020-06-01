module test_bcdAdd;
    logic [3:0] a, b, sum;
    logic carryIn, carryOut;
    logic [8:0] counter;
    assign {a, b, carryIn} = counter;

    bcdAdd dut (.*);

    initial begin
        $monitor("%d + %d + %d = %d (%d)", a, b, carryIn, sum, carryOut);
        for (counter = 9'b0; counter != 9'd511; counter++) #1;
    end

endmodule: test_bcdAdd

module bcdAdd(
    output logic [3:0] sum,
    output logic carryOut,
    input logic [3:0] a, b,
    input logic carryIn
);
    logic [4:0] s;
    assign s = a + b + carryIn;
    assign sum = s > 5'd9 ? s - 5'd10 : s;
    assign carryOut = s > 5'd9 ? 1'b1 : 1'b0;

endmodule: bcdAdd