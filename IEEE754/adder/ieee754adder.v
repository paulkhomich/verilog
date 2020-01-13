// Adder for two float32 numbers with ieee754 standard
module ieee754adder(
    input [0:31] a,
    input [0:31] b,
    output [0:31] o
);

// Declaration
wire [0:7] aord, bord, _oord, oord, _shift, shift;
wire [0:23] amnt, bmnt, _omnt, omnt;
wire shiftsign, oflw;


// Decomposition
assign aord = a[1:8], amnt = {1'b1, a[9:31]};
assign bord = b[1:8], bmnt = {1'b1, b[9:31]};
// Comparation
assign {shiftsign, _shift} = aord - bord;
assign shift = shiftsign ? ~_shift + 1'b1 : _shift; // shift for orders
assign _oord = shiftsign ? bord : aord; // output temp order
// Mantissa adding (with shifting) + normalizing
assign {oflw, _omnt} = shiftsign ? bmnt + (amnt >> shift) : amnt + (bmnt >> shift);  // output temp mnt
assign omnt = oflw ? {oflw, _omnt[0:22]} : _omnt; // output mnt
// Order shifting
assign oord = oflw ? _oord + 1'b1 : _oord; // output order


// Collecting 
assign o = {1'b0, oord, omnt[1:23]};

endmodule