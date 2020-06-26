module top;
    localparam WIDTH = 4;
    bit [WIDTH-1:0] vec;
    bit [WIDTH-1:0] inverse;

    inv  #(WIDTH)   dut (.*);
    vec4 #(WIDTH)   tb (.*);
endmodule

module inv #(
    parameter   n = 4               ,
    localparam  w = n - 1
)(
    input   bit [w:0]   vec         ,
    output  bit [w:0]   inverse
);
    assign inverse = ~vec;
endmodule

program vec4 #(
    parameter   n = 4               ,
    localparam  w = n - 1
)(
    output  bit [w:0]   vec
);
    initial begin
        $monitor("%2t\tvec:%4b\t\tinv:%b", $stime, vec, top.inverse);
        vec = 0;
        repeat (2**n) #1 vec += 1;
        $finish;
    end
endprogram