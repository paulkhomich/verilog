module fsm(
    input   bit   clk, rst, i, j   ,
    output  bit   x, y
);
    // STATE
    enum logic [1:0] {A, B, C, D} state, nextstate;
    always_ff @(posedge clk, posedge rst) begin
        if (rst)    state <= A;
        else        state <= nextstate;
    end
    // NEXTSTATE
    always_comb case (state)
        A: nextstate =  (i) ? B : A;
        B: nextstate =  (j) ? D : C;
        C: nextstate =  (i) ? B : 
                        (j) ? C : D;
        D: nextstate =  (i) ? D :
                        (j) ? C : A;
    endcase
    // OUTPUT
    always_comb case (state)
        A: {x,y} = {1'b1,   i};
        B: {x,y} = {~j,     j};
        C: {x,y} = {~i, ~i&~j};
        D: {x,y} = {~i&j,1'b0};
    endcase

endmodule: fsm