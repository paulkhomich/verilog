/*
 *	Simple 8-N-1 UART TX
 *	Pavel Khomich
 *	2020
 */

module uart_tx #(
	parameter CLK_HZ			= 50_000_000						,
	parameter BAUDRATE			= 38_400							,
	parameter CLK_PER_BIT_HALF	= (CLK_HZ / BAUDRATE / 2) - 1		,
	parameter COUNTER_SIZE		= $clog2(CLK_PER_BIT_HALF)
)(
	input	logic			clk		,	//	main clock (CLK_HZ)
	input 	logic			rst		,	// 	reset signal
	input	logic			send	,	//	signal to start transmission
	input	logic	[7:0]	data	,	// 	data to send (load to buffer)

	output	logic			ready	,	//	ready to get new data (not busy)
	output	logic			out			// 	transmission data out
);
	/*
		INTERNAL REGISTERS
	*/
	logic clk_d;	// clock for required baudrate (divider)

	/*
		COUNTER FOR MAKE REQUIRED BAUDRATE 
	*/
	logic [COUNTER_SIZE - 1:0] counter;
	always_ff @(posedge clk, posedge rst) begin
		if (rst) begin
			counter <= CLK_PER_BIT_HALF;
			clk_d 	<= '0;
		end
		else if (counter == '0) begin
			counter <= CLK_PER_BIT_HALF;
			clk_d	<= ~clk_d;
		end
		else begin
			counter <= counter - 1'b1;
		end
	end
	
	/* 
		CONTOROL STATE MACHINE 
	*/
	enum logic [3:0] { WAIT, START, B0, B1, B2, B3, B4, B5, B6, B7, STOP } state;
	// 	JUMP TABLE
	always_ff @(posedge clk_d, posedge rst) begin
		if (rst)		state <= WAIT;
		else case (state)
			WAIT:		state <= (send) ? START : WAIT;
			START:		state <= B0;
			B0:			state <= B1;
			B1:			state <= B2;
			B2:			state <= B3;
			B3:			state <= B4;
			B4:			state <= B5;
			B5:			state <= B6;
			B6:			state <= B7;
			B7:			state <= STOP;
			STOP:		state <= (send) ? START : WAIT;
			default:	state <= WAIT;
		endcase
	end
	// 	OUTPUT TABLE
	assign ready = (state == WAIT) || (state == STOP);
	assign load	 = ready && send;
	
	/* 
		DATA SHIFT BUFFER 
	*/
	logic [9:0] buffer;
	always_ff @(posedge clk_d, posedge rst) begin
		if (rst)			buffer <= '1;					
		else if (load)		buffer <= { 1'b1, data, 1'b0 }; 	// STOPBIT [data] STARTBIT
		else				buffer <= { 1'b1, buffer[9:1] };	// shift to right
	end
	
	/*
		OUTPUT
	*/
	assign out = buffer[0];
		
endmodule: uart_tx












