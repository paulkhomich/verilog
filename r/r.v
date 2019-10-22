module r(
    input clk, rst,
    output reg [19:0] y
);
    always @(posedge clk, posedge rst) begin
        if (rst)
            y <= 20'd1;
        else begin
            // y[19:2] <= y[17:0];
            y <= y << 2;
            y[1] <= 1'b0;
            y[0] <= 1'b0;
        end
    end
endmodule