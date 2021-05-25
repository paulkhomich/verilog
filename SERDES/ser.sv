module ser #(						// SERIALIZER (N by M)
	parameter n = 8				,	// DATA SIZE
	parameter m = 1
)(
	input	logic			clk	,	// CLOCK
	input	logic			rst	,	// RESET
	input	logic [n-1:0]		data	,	// DATA TO TRANSFER (N)
	input	logic			snd	,	// SEND DATA SIGNAL
	output	logic			rdy	,	// READY FLAG
	output	logic [m-1:0]		tx		// OUTPUT (M)
);
	logic [$clog2($ceil(n/m))-1:0]	cnt;		// STATE COUNTER (N/M STATES)
	always_ff @(posedge clk, posedge rst)
		if (rst)		cnt <= '0;
		else if (snd)		cnt <= $ceil(n/m) - 1;
		else			cnt <= cnt - 1;
	
	logic [n-1:0]			buffer;		// SHIFT REGISTER
	always_ff @(posedge clk, posedge rst)
		if (rst)		buffer <= '0;
		else if (snd)		buffer <= data;
		else			buffer <= { {m{1'b0}}, buffer[n-m:1] };

	assign rdy = (cnt == '0);
	assign tx  = buffer[m-1:0];

endmodule
