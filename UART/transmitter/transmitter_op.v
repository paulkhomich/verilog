module transmitter_op(
    input load, next, rst, clk,
    input [7:0] x,
    output tx, msb
);

localparam TIMER = 4'd10 - 1;

reg [9:0] memory;
reg [3:0] counter;

always @(posedge clk, posedge rst) begin
    if (rst) counter <= TIMER;
    else if (load) counter <= TIMER;
    else if (next) counter <= counter - 4'd1;
    else counter <= counter;
end

always @(posedge clk, posedge rst) begin
    if (rst) memory <= {9'd0, 1'd1};
    else if (load) memory <= {1'd1, x, 1'd0};
    else if (next) memory = memory >>> 1;
    else memory <= memory;
end

assign msb = counter == 0;
assign tx = memory[0];

endmodule // transmitter_op