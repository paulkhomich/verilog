module adderFlowBCD(
    input   logic           clk, rst    ,
    input   logic           start, done ,
    input   logic [3:0]     a, b        ,
    output  logic [3:0]     sum         ,
    output  logic           overflow
);
    logic ci, co;

    adderBCD    adder (.cin(co), .o(ci), .*);
    register    register (.in(ci), .out(co), .*);

    assign overflow = co;

endmodule: adderFlowBCD

module adderBCD(
    input   logic [3:0]     a, b        ,
    input   logic           cin         ,
    output  logic [3:0]     sum         ,
    output  logic           o
);
    logic [4:0] temp;
    assign temp = a + b + cin;
    
    assign sum = temp > 5'd9 ? temp + 5'd6 : temp;
    assign o = temp[4];

endmodule: adderBCD

module register(
    input   logic   clk, rst    ,
    input   logic   in          ,
    output  logic   out 
);
    always_ff @(posedge clk, posedge rst)
        if (rst)    out <= '0;
        else        out <= in;

endmodule: register