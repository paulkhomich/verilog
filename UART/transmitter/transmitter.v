`timescale 1ns/1ns
module transmitter(
    input [7:0] x,
    input start, clk, rst,
    output tx, ready
);

wire msb, next, load;

transmitter_cn cn(.clk(clk), .rst(rst), .msb(msb), .next(next), .load(load), .ready(ready), .start(start));
transmitter_op op(.clk(clk), .rst(rst), .msb(msb), .next(next), .load(load), .x(x), .tx(tx));

endmodule // transmitter