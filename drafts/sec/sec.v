module sec(
	input clk,
	output reg light
);

reg [10:0] div;

always @(posedge clk) begin
	if (div != 26'd300) div <= div + 1;
	else begin
		div <= 0;
		light <= !light;
	end
end

endmodule