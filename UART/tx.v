module tx(
	input clk, rst,
	input send,
	input [7:0] data,
	output busy,
	output tx
);

reg [3:0] counter; // Счетчик передачи битов
reg [9:0] row; // Сдвиговый регистр передачи
assign busy = |counter; // Занят, если передача в процессе (Не последний бит)
assign tx = row[0];

always @(posedge clk) begin
	if (rst) begin
		counter <= 4'd0;
		row <= ~10'd0;
	end
	else if (send) begin
		counter <= 4'd9;
		row <= {1'd1, data, 1'd0}; 
	end
	else if (busy) begin
		counter <= counter - 1;
		row = {1'd1, row[9:1]};
	end
end

endmodule
