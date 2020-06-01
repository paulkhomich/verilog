module registerPro
#(parameter w = 8)(
    input   logic [w-1:0]   d                               ,
    input   logic           clk, rst, clr, ld, shl, shlIn   ,
    output  logic [w-1:0]   q
);
    localparam logic [w-1:0] DEFAULT = 'b0;

    always_ff @(posedge clk, posedge rst) begin
        if (rst || clr)     q <= DEFAULT;
        else if (ld)        q <= d;
        else if (shl)       q <= {d[w-2:0], shlIn};
    end

endmodule: registerPro