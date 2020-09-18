module dmux660(
    input [5:0]         s,
    output reg [63:0]   y
);
    always @(*) begin : declPort
        integer i;
        for (i = 0; i < 64 ;i++) begin
            y[i] = s == i ? 1'b1 : 1'b0;
        end
    end
endmodule