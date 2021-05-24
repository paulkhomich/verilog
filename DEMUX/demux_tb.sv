module demux_sv ();
	logic		in;
	logic [2:0]	sel;
	logic [7:0]	out;

	demux #(8) dut (.*);

	initial begin
		for (logic [4:0] i = 5'd0; i < 5'd16; i++) begin
			sel =	i[2:0];
			in  =	i[3];
			assert(out[0] == (sel == 0) ? in : '0);
			assert(out[1] == (sel == 1) ? in : '0);
			assert(out[2] == (sel == 2) ? in : '0);
			assert(out[3] == (sel == 3) ? in : '0);
			assert(out[4] == (sel == 4) ? in : '0);
			assert(out[5] == (sel == 5) ? in : '0);
			assert(out[6] == (sel == 6) ? in : '0);
			assert(out[7] == (sel == 7) ? in : '0);
		end

		$display("done");
		$finish;
	end

endmodule
