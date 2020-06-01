module fsm(
    input   bit     clk, rst, i, j      ,
    output  bit     x, y
);
    // STATE
    enum logic [1:0] {D,C,B,A} state, nextstate;
    always_ff @(posedge clk, posedge rst)
        if (rst)    state <= A;
        else        state <= nextstate;
    // NEXTSTATE
    always_comb case (state)
        A: nextstate =  (i) ? B : A;
        B: nextstate =  (i) ? C : D;
        C: nextstate =  (i) ? B : 
                        (j) ? C : D;
        D: nextstate =  (i) ? D :
                        (j) ? C : A;
    endcase
    // OUTPUT
    assign {x,y} = state;

endmodule: fsm