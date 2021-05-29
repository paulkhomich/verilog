/*	
 *	FIFO BUFFER
 *	
 */
module fifo #(
	parameter			S = 8		,	// QUEUE SIZE
	parameter			N = 8			// DATA SIZE
)(
	input	logic			clk		,	// CLOCK 
	input	logic			rst		,	// RESET
	
	input	logic [N-1:0]		data_in		,	// DATA TO WRITE
	input	logic			write		,	// WRITE SIGNAL
	output	logic			rdy_in		,	// READY TO WRITE (FLAG)
	
	output	logic [N-1:0]		data_out	,	// DATA TO READ
	output	logic			rdy_out		,	// READY FOR READ DATA (FLAG)
	input	logic			read			// READ SIGNAL
);
								// STATE COUNTER
	logic [$clog2(S)-1:0]		cnt;			// WRITE POSITION
	logic [$clog2(S)-1:0]		cnt_next;		// NEXT WRITE POSITION (FOR UPDATE)
	logic [$clog2(S)-1:0]		cnt_prev;		// PREVIOUS WRITE POSITION (FOR WRITE&READ CASE)
	always_ff @(posedge clk, posedge rst)
		if (rst)			cnt <= '0;
		else if (write && ~read)	cnt <= cnt_next;
		else if	(read && ~write)	cnt <= cnt_prev;
		else				cnt <= cnt;
	assign cnt_next = cnt + 'b1;
	assign cnt_prev = cnt - 'b1;

								// QUEUE FOR DATA
	logic [N-1:0]			queue [S];		// QUEUE FOR DATA (S) REGISTERS WITH (N)-WIDTH DATA
	genvar i;
	generate
	for (i = 0; i < S; i++) begin
	always_ff @(posedge clk, posedge rst)
		if (rst)			queue[i] <= '0;
		else if (write && ~read)	queue[i] <= (cnt == i) ? data_in : queue[i];
		else if (read && ~write)	queue[i] <= queue[(i+1)%S];
		else if (write && read)		queue[i] <= (cnt_prev == i) ? data_in : queue[(i+1)%S];
		else				queue[i] <= queue[i];
	end
	endgenerate
								// CONTROL LOGIC
	logic				empty;			// QUEUE IS REAL EMPTY (FLAG)
	always_ff @(posedge clk, posedge rst)
		if (rst)			empty <= 1'b1;
		else if (empty && ~write)	empty <= 1'b1;
		else				empty <= (cnt_prev == '0 && read && ~write) ? 1'b1 : 1'b0;
	assign rdy_out = ~empty;
	assign rdy_in  = cnt != '0 || empty;
	
	assign data_out = queue[0];

endmodule
