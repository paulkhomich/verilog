module transmitter_cn #(
    parameter UARTFREQ = 9600,
    parameter CLKFREQ = 76_800
)(
    input start, clk, rst, msb,
    output next, ready, load
);

localparam WAITING = CLKFREQ / UARTFREQ - 1;
localparam S0 = 1'd0, S1 = 1'd1;

reg state, nextstate;
reg [$clog2(WAITING):0] counter;

always @(posedge clk, posedge rst) begin
    if (rst) state <= S0;
    else state <= nextstate;
end

always @(posedge clk, posedge rst) begin
    if (rst) counter <= WAITING;
    else if (counter == 0) counter <= WAITING;
    else if (state == S1) counter <= counter - 8'd1;
    else counter <= counter;
end

always @(*) begin
    case (state)
        S0: nextstate = start ? S1 : S0;
        S1: nextstate = (counter == 0 && msb) ? S0 : S1;
    endcase
end

assign next = state == S1 && counter == 0;
assign load = state == S0 && start;
assign ready = state == S0;

endmodule // transmitter_cn