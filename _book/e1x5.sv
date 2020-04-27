module test_nor;
    logic a, b, f;

    nor dut (f, a, b);


    initial begin
        logic [3:0] SIG = {1'b0, 1'b1, 1'bx, 1'bz};

        foreach (SIG[i]) begin
            a = SIG[i];
            foreach (SIG[j]) begin
                b = SIG[j];
                #1 $display("%d %d | %d", a, b, f);
            end
        end
        $finish;
    end

endmodule: test_nor