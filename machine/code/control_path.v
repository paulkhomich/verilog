// Имена новых управляющих портов добавить после соответствующего комментария в первой строке объявления модуля.
// Сами объявления дописывать под соответствующим комментарием после имеющихся объявлений портов. Комментарий не стирать.
// Реализацию управляющего автомата дописывать под соответствующим комментарием в конце модуля. Комментарий не стирать.
// По необходимости можно раскомментировать ключевые слова "reg" в объявлениях портов.
module control_path(on, start, regime, active, y_select_next, s_step, y_en, s_en, y_store_x, s_add, s_zero, clk, rst, sIs6 /* , ... (ИМЕНА НОВЫХ УПРАВЛЯЮЩИХ ПОРТОВ */);
  input [1:0] on;
  input start, clk, rst;
  output reg [1:0] regime;
  output reg active;
  output /* reg */ [1:0] y_select_next;
  output /* reg */ [1:0] s_step;
  output /* reg */ y_en;
  output /* reg */ s_en;
  output /* reg */ y_store_x;
  output /* reg */ s_add;
  output /* reg */ s_zero;
  
  /* ОБЪЯВЛЕНИЯ НОВЫХ УПРАВЛЯЮЩИХ ПОРТОВ */

  input sIs6;
  
  localparam R0 = 2'd0, R1 = 2'd1, R2 = 2'd2, R3 = 2'd3; // regime
  localparam C_R3 = 2'd3, C_R1 = 2'd3; // Счетчики для режима обновления + для режима перечисления
  reg [1:0] next_regime; // regime
  reg [1:0] counter_r3; // Счетчик для режима обновления
  reg [1:0] counter_r1; // Счетчик для режима перечисления
  reg next_active; // следующий active
  
  /* КОД УПРАВЛЯЮЩЕГО АВТОМАТА */

  // регистр режима
  always @(posedge clk, posedge rst) begin
    if (rst) regime <= R0;
    else if (clk) regime <= next_regime;
  end

  // регистр активности
  always @(posedge clk, posedge rst) begin
    if (rst) active <= 0;
    else if(clk) active <= next_active;
  end

  // счетчик этапа в режиме обновления (R3)
  always @(posedge clk, posedge rst) begin
    if (rst) counter_r3 <= C_R3;
    else if (counter_r3 == 0) counter_r3 <= C_R3;
    else if (regime == R3) counter_r3 <= counter_r3 - 2'd1;
    else counter_r3 <= counter_r3;
  end

  // счетчик такта в режиме перечисления (R1)
  always @(posedge clk, posedge rst) begin
    if (rst) counter_r1 <= C_R1;
    else if(counter_r1 == 0) counter_r1 <= C_R1;
    else if(active) counter_r1 <= counter_r1 - 2'd1;
    else counter_r1 <= counter_r1;
  end

  // записываем Х если режим обновления (R3) и это его первый этап
  assign y_store_x = (regime == R3) && (counter_r3 == C_R3);

  // следующий режим
  always @(*) begin
    case(regime)
      R0: case(on)
        0: next_regime = R0;
        1: next_regime = R1;
        2: next_regime = R2;
        3: next_regime = R3;
        default: next_regime = R0;
      endcase
      R1: if (sIs6 && counter_r1 == 0) next_regime = R0;
      else next_regime = R1;
      R2: if (start == 0) next_regime = R0;
      else next_regime = R2;
      R3: if (counter_r3 == 0) next_regime = R0;
      else next_regime = R3;
      default next_regime = R0;
    endcase
  end

  // следующее состояние активности
  always @(*) begin
    if (regime == R1 && active == 0 && start) begin
       next_active = 1'd1;
       s_zero = 1'd1;
    end
    else if (sIs6 && counter_r1 == 0) next_active = 0;
    else next_active = active;
  end

  // s_step: шаг для изменения s
  always @(*) begin
    case(regime) begin
      R1: if (active) s_step = 2'd2;
      else s_step = 2'd0;
      R2: s_step = 2'd1;
      R3: s_step = 2'd1;
      default: s_step = 2'd0;
    end 
  end

  // s_add: сложение или вычитание шага и s
  always @(*) begin
    case(regime) begin
      R1, R3: s_add = 1'b1;
      default: s_add = 1'b0;
    end
  end

  // y_select_next: операция со следующим значением y
  always @(*) begin
    case(regime) begin
      R2: y_select_next = 2'd1;
      R3: if (counter_r3 == 2'd2) y_select_next = 2'd3;
      else y_select_next = 2'd0;
      default: y_select_next = 2'd0;
    end
  end

  // s_en: Разрешаем запись в S-регистр 
  assign s_en = (counter_r1 == 0) || (regime == R1) || (counter_r3 == 2'd1);

  // y_en: Разрешаем запись в Y-регистр
  assign y_en = sIs6 || (counter_r3 > 2'd1);
  
endmodule
