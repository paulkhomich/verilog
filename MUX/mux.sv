module mux #(
	parameter n = 4
)(
	input	logic [n-1:0]		in	,
	input	logic [$clog2(n)-1:0]	sel	,
	output	logic			out
);
	assign out	= in[sel];

endmodule: mux


