module scanreg4(
    input clk,
    input test, sin,
    input [3:0] data,
    output sout,
    output reg [3:0] out
);

assign sout = out[3];

always @(posedge clk) begin
    if(test) out <= {out[2:0], sin};
    else out <= data;
end

endmodule