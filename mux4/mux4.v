module mux4(
    input [1:0] s,
    input       d0, d1, d2, d3,
    output reg  y
);
    always @(*) begin
        case (s)
            2'd0: y = d0; 
            2'd1: y = d1; 
            2'd2: y = d2; 
            2'd3: y = d3; 
        endcase
    end
endmodule