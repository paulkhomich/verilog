module ex4_36(
    input clk, rst,
    input one, two, five,
    output pour, ret1, ret2, ret22
);

reg [3:0] state, nextstate;
localparam  S0          = 0,
            S1          = 1,
            S2          = 2,
            S3          = 3,
            S4          = 4,
            POUR        = 5,
            POUR_R1     = 6,
            POUR_R2     = 7,
            POUR_R22    = 8,
            POUR_R1_R2  = 9;

always @(posedge clk, posedge rst) begin
    if (rst)    state <= S0;
    else        state <= nextstate;
end

always @(*) begin
    case(state)
        S0: begin
            if (one) nextstate = S1;
            else if (two) nextstate = S2;
            else if (five) nextstate = POUR;
        end
        S1: begin
            if (one) nextstate = S2;
            else if (two) nextstate = S3;
            else if (five) nextstate = POUR_R1;
        end
        S2: begin
            if (one) nextstate = S3;
            else if (two) nextstate = S4;
            else if (five) nextstate = POUR_R2;
        end
        S3: begin
            if (one) nextstate = S4;
            else if (two) nextstate = POUR;
            else if (five) nextstate = POUR_R1_R2;
        end
        S4: begin
            if (one) nextstate = POUR;
            else if (two) nextstate = POUR_R1;
            else if (five) nextstate = POUR_R22;
        end
        POUR, POUR_R1, POUR_R1_R2, POUR_R2, POUR_R22: nextstate = S0;
        default: nextstate = S0;
    endcase
end

assign pour = state >= 5;
assign ret1 = state == POUR_R1 || state == POUR_R1_R2;
assign ret2 = state == POUR_R2 || state == POUR_R1_R2;
assign ret22 = state == POUR_R22;

endmodule