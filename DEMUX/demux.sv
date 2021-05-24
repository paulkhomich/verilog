module demux #(
	parameter n = 4
)(
	input	logic			in	,
	input	logic [$clog2(n)-1:0]	sel	,
	output	logic [n-1:0]		out
);
	genvar g;
	generate
	for (g = 0; g < n; g++)
		assign out[g] = (sel == g) ? in : '0;
	endgenerate

endmodule
