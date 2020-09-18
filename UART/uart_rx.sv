/*
 *	Simple 8-N-1 UART RX
 *	Pavel Khomich
 *	2020
 */

module uart_rx #(
	parameter CLK_HZ			= 50_000_000						,
	parameter BAUDRATE			= 9_600								,
	parameter CLK_PER_BIT		= (CLK_HZ / BAUDRATE) - 1			,
	parameter CLK_PER_BIT_HALF	= ((CLK_PER_BIT + 1) / 2) - 1		,
	parameter COUNTER_SIZE		= $clog2(CLK_PER_BIT)				,
	parameter HALF_COUNTER_SIZE = $clog2(CLK_PER_BIT_HALF)
)(
	input	logic			clk			,	// main clock (CLK_HZ)
	input	logic			rst			,	// reset signal
	input	logic			in			,	// input data (1-bit)
	
	output 	logic	[7:0]	data		,	// output byte (received)
	output	logic			get			,	// indicate byte receiving 
	output	logic			error			// indicate error during receiving
);
	/*			
		INTERNAL SIGNALS AND REGISTERS
	*/
	logic 	start;		// signal about finding half-startbit => start receiving
	logic 	next;		// signal for next step for receiving state machine (+ reset baud clock)
	
	logic	reset;		// signal to reset baudrate clock counter
	logic 	shift;		// signal to shift data in data register
	
	
	/*
		WATCHDOG FOR FINDING STARTBIT (for time of 0.5 * BITTIME)
	*/
	logic [HALF_COUNTER_SIZE - 1:0] watchdog;
	always_ff @(posedge clk, posedge rst) begin
		if (rst)			watchdog <= '0;
		else if (!in)		watchdog <= watchdog + 1'b1;
		else				watchdog <= '0;
	end
	assign start = watchdog == CLK_PER_BIT_HALF;

	/*
		COUNTER FOR MAKE REQUIRED BAUDRATE 
	*/
	logic [COUNTER_SIZE - 1:0] counter;
	always_ff @(posedge clk, posedge rst) begin
		if (rst)			counter <= '0;
		else if (reset)		counter <= '0;
		else if (next)		counter <= '0;
		else				counter <= counter + 1'b1;
	end
	assign next = counter == CLK_PER_BIT;
	
	/* 
		CONTOROL STATE MACHINE 
	*/
	enum logic [3:0] { WAIT, B0, B1, B2, B3, B4, B5, B6, B7, STOP } state;
	// 	JUMP TABLE
	always_ff @(posedge clk, posedge rst) begin
		if (rst) 			state <= WAIT;
		else case (state)
			WAIT: 			state <= (start) 	? B0 	: WAIT;
			B0:				state <= (next)		? B1 	: B0;
			B1:				state <= (next) 	? B2 	: B1;
			B2:				state <= (next) 	? B3 	: B2;
			B3:				state <= (next) 	? B4 	: B3;
			B4:				state <= (next) 	? B5 	: B4;
			B5:				state <= (next) 	? B6 	: B5;
			B6:				state <= (next) 	? B7 	: B6;
			B7:				state <= (next) 	? STOP 	: B7;
			STOP: 			state <= (next)		? WAIT	: STOP;
			default: 		state <= WAIT;
		endcase
	end
	// OUTPUT TABLE (GET AND ERROR SIGNALS)
	always_ff @(posedge clk, posedge rst) begin
		if (rst) begin
			get 	<= 1'b0;
			error 	<= 1'b0;
		end
		else if (state == WAIT) begin
			get 	<= (start)  ? 1'b0	: get;
			error 	<= (start) 	? 1'b0 	: error;
		end 
		else if (state == STOP) begin
			get 	<= (next) 		 ? 1'b1 : 1'b0;
			error 	<= (next && !in) ? 1'b1 : 1'b0;
		end
	end
	assign reset = state == WAIT && start;
	assign shift = state != WAIT && state != STOP && next;
	
	/* 
		DATA SHIFT REGISTER 
	*/
	always_ff @(posedge clk, posedge rst) begin
		if (rst)			data <= '0;
		else if (shift)		data <= { in, data[7:1] };
	end

endmodule: uart_rx