module vectorGen #(parameter n = 4, d = 1)(
    output logic [n - 1:0] vector
);
    // vector changes from 0...0 to 1...1 (size n) with delay (d)
    initial for (vector = {(n - 1){1'b0}}; vector != {(n - 1){1'b1}}; vector++) #d;
endmodule: vectorGen
