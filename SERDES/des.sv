module des #(					// DESERIALIZER (N to M)
	parameter n = 1			,	// DATA SIZE
	parameter m = 8
)(
	input	logic		clk	,	// CLOCK
	input	logic		rst	,	// RESET
	input	logic		en	,	// ENABLE (RECEIVE)
	input	logic [n-1:0]	rx	,	// INPUT (N)
	output	logic [m-1:0]	data	,	// OUTPUT (M)
	output	logic		rdy		// READY FLAG (FULL DATA READ)
);
	logic [$clog2($ceil(m/n))-1:0]	cnt;	// STATE COUNTER
	always_ff @(posedge clk, posedge rst, posedge en)
		if (rst || en)		cnt <= $ceil(m/n) - 1;
		else			cnt <= cnt - 1;

	logic [m-1:0]			buffer;	// SHIFT REGISTER
	always_ff @(posedge clk, posedge rst)
		if (rst)		buffer <= '0;
		else			buffer <= { rx, buffer[m-1:m-1-n] };

	assign rdy = (cnt == '0);
	assign data = buffer;

endmodule
