module main #(parameter W = 8) (
    input clk, rst, apply,
    input [W - 1:0] in,
    input [2:0] op,
    output [W - 1:0] tail,
    output empty, valid
);
    reg [W - 1:0] inToQueue;        // значение для записи в queue
    reg validMain;              // проверка корректности деления на 0

    wire [W - 1:0] first, second;   // информация о первом и втором элементе
    wire validQueue;            // информация о корректности внутри queue

    queue #(W) q(
        .clk(clk), .rst(rst), .apply(apply), .in(inToQueue), .op(op),
        .first(first), .second(second), .tail(tail), .empty(empty), .valid(validQueue)
    );


    assign valid = validQueue & validMain;  // корректно если очередь и операция корректны

    always @(posedge clk) begin // Как я понял — операция некорректна, если деление на ноль хотят применить(!)
        case (op)
            3'd3: if (first == 0 && apply) validMain = 0;
            3'd4: if (first == 0 && apply) validMain = 0;
        endcase
    end

    always @(*) begin
        if (rst) validMain = 1;
        else begin
            case (op)
                3'd0: inToQueue = first + second; 
                3'd1: inToQueue = first - second;
                3'd2: inToQueue = first * second; 
                3'd3: inToQueue = second / first; 
                3'd4: inToQueue = second % first; 
                default: inToQueue = in;
            endcase
        end
    end
endmodule