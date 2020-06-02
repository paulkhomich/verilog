module fsm(
    input   bit clk, rst, i   ,
    output  bit x, y
);
    // STATE
    enum logic [1:0] { A, B, C } state, nextstate;
    always_ff @(posedge clk, posedge rst)
        if (rst)    state <= A;
        else        state <= nextstate;
    // NEXTSTATE
    always_comb
        unique case (state)
            A: nextstate = (i) ? C : B;
            B: nextstate = (i) ? C : B;
            C: nextstate = (i) ? C : A;
        endcase
    // OUT
    always_comb
        unique case (state)
            A: {x,y} = {i, 1'b1};
            B: {x,y} = 2'b10;
            C: {x,y} = {~i, i};
        endcase

endmodule: fsm