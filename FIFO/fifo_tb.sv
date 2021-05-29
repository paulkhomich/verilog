module fifo_tb;
	bit		clk, rst;
	wire [7:0]	data_in, data_out;
	wire		write, read, rdy_in, rdy_out;

	initial rst = 1;
	initial #2 rst = 0;
	initial repeat (2000) #1 clk <= ~clk;
	initial	begin
		$dumpfile("test.vcd");
		$dumpvars(0, fifo_tb);
	end

	fifo #(8,8) dut (.*);
	tb #(8) tb (.*);

endmodule

program tb #(
	parameter N = 8
)(
	input   logic                   clk             ,       // CLOCK
	input   logic                   rst             ,       // RESET

	output  logic [N-1:0]           data_in         ,       // DATA TO WRITE
	output  logic                   write           ,       // WRITE SIGNAL
	input	logic                   rdy_in          ,       // READY TO WRITE (FLAG)

	input	logic [N-1:0]           data_out        ,       // DATA TO READ
	input	logic                   rdy_out         ,       // READY FOR READ DATA (FLAG)
	output	logic                   read                    // READ SIGNAL
);
	// MAIN IDEA — SEND RANDOM ARRAY OF DATA THROUGH THE FIFO AND COMPARE IN/OUT ARRAYS	
	
	task send;
		wait(rdy_in && ~clk);
		data_in = dataTO[to++];
		write = 1'b1;
		#2;
		write = 1'b0;
	endtask	

	task receive;
		wait(rdy_out && ~clk);
		read = 1'b1;
		dataFROM[from++] = data_out;
		#2;
		read = 1'b0;
		if ($urandom%10 > 7)
			#6;
	endtask

	int to = 0;
	int from = 0;
	logic [N-1:0] dataTO	[256];
	logic [N-1:0] dataFROM	[256];
	initial for (int i = 0; i < 256; i++) begin
		dataTO[i] = $urandom%256;
		dataFROM[i] = ~dataTO[i];
	end

	initial read = 0;
	initial write = 0;
	initial begin
		#2;
		fork
			while (to < 256)
				send;
			while (from < 256)
				receive;
		join

		for (int i = 0; i < 256; i++)
			assert(dataTO[i] == dataFROM[i]);

		$display("done: dataTO == dataFROM");
	end

endprogram








