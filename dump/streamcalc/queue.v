module queue #(parameter W = 8) (
    input clk, rst, apply,
    input [W - 1:0] in,
    input [2:0] op,
    output [W - 1:0] first, second, tail,
    output empty,
    output reg valid
);
    reg [11*W - 1:0] queue;           // Сама очередь
    reg [3:0] size;             // Размер очереди 0~11 

    assign first = queue[W - 1:0];
    assign second = queue[2*W - 1:W];
    assign tail = size > 0 ? queue[(size - 1)*W +: W] : queue[W - 1:0];
    assign empty = !(|size);

    always @(posedge clk, posedge rst) begin
        if (rst) begin
            size <= 0;
            queue <= 0;
            valid <= 1;
        end
        else begin
            if (apply) begin
                case (op)
                    3'd0, 3'd1, 3'd2, 3'd3, 3'd4: begin
                        if (size < 2) valid = 0;
                        else begin
                            queue <= queue >> 2*W;
                            queue[(size - 2)*W +: W] <= in;
                            size <= size - 4'd1;
                        end
                    end
                    3'd5: begin
                        if (size == 11) valid = 0;
                        else begin
                            queue[size*W +: W] <= in;
                            size <= size + 4'd1;
                        end
                    end
                    3'd6: begin
                        if (size == 0) valid = 0;
                        else begin
                            queue <= queue >> W;
                            size <= size - 4'd1;
                        end
                    end
                    default: valid = 0;
                endcase
            end
        end
    end
endmodule