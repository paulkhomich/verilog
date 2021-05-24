module mux_tb ();
	logic [15:0]	in;
	logic [3:0]	sel;
	logic		out;

	mux #(16) dut (.*);

	initial begin
		for (in = 16'd0; in != ~16'd0; in++)
			for (sel = 4'd0; sel != 4'd15; sel++)
				assert(out == in[sel]);

		$display("done");
		$finish;
	end

endmodule: mux_tb
