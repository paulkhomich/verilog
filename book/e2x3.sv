typedef enum logic [1:0] {ADD, AND, OR, XOR} ops;

module alu
#(parameter w = 4) (
    output logic [w-1:0] result,
    output logic N, Z, V,
    input logic [w-1:0] a, b,
    input ops fn
);
    logic [w:0] temp;
    always_comb
    case (fn)
        ADD: temp = a + b;
        AND: temp = a & b;
        OR:  temp = a | b;
        XOR: temp = a ^ b;
    endcase

    assign result = temp[w-1:0];
    assign N = result[w-1];
    assign Z = &result;
    assign V = result[w];

endmodule: alu