module top;
    bit clk, rst;
    bit i, j, x, y;

    fsm dut (.*);
    test tb (.*);

    initial begin
        clk = 0;
        rst = 1;
        rst <= #2 0;
        forever #1 clk = ~clk;
    end

endmodule

module fsm(
    input   bit     clk, rst, i, j   ,
    output  bit     x, y
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
        B: nextstate =  (j) ? C : D;
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

program test(
    input   bit     clk, rst        ,
    output  bit     i, j
);
    initial begin
        $monitor("%2t\ts:%d n:%d\t\t%d,%d\t%d,%d", $time, top.dut.state, top.dut.nextstate, top.dut.i, top.dut.j, top.dut.x, top.dut.y);
        @(posedge clk);
            step(0,0);
        @(posedge clk);
            step(0,1);
        @(posedge clk);
            step(1,1);
        @(posedge clk);
            step(0,1);
        @(posedge clk);
            step(1,0);
        @(posedge clk);
            step(1,1);
        @(posedge clk);
            step(1,1);
        @(posedge clk);
            step(0,0);
        @(posedge clk);
            step(1,0);
        @(posedge clk);
            step(1,1);
        @(posedge clk);
            step(0,1);
        @(posedge clk);
            step(0,1);
        @(posedge clk);
            step(0,0);
        @(posedge clk);
            step(0,0);
        @(posedge clk);
            $finish;
    end

    task step(bit a, b);
        i = a;
        j = b;
    endtask
endprogram