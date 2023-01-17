module controller ( input clk, rst,
                          simon_says, sk_strobe,
                          round_passed, sd_is_empty,
                    output sd_srst, fr_en, mem_en,
                           is_wrong, is_correct,
                    output [3:0]score,
                    output [2:0]state);
  typedef enum logic [2:0] {
    READY = 0,
    PLAY = 1,
    FAIL = 2,
    PASS = 3,
    WIN = 4
  } dcl_fsm_t;
  dcl_fsm_t fsm;

  logic sd_sync, fr_enable, mem_enable, wrongs, corrects;
  logic [3:0]result;

  assign state = fsm;
  assign sd_srst = sd_sync;
  assign fr_en = fr_enable;
  assign mem_en = mem_enable;
  assign is_wrong = wrongs;
  assign is_correct = corrects;
  assign score = result;

  always_ff @ (posedge clk, posedge rst) begin
    if (rst) begin
      fsm <= READY;
      sd_sync <= 1;
      fr_enable <= 1;
      mem_enable <= 1;
      wrongs <= 0;
      corrects <= 0;
      result <= 0;
    end
    else begin
      case (fsm)
        READY:  begin
                  fr_enable <= 1;
                  mem_enable <= 1;
                  sd_sync <= 0;
                  if (sd_is_empty) begin
                    fsm <= PLAY;
                    sd_sync <= 1;
                    fr_enable <= 0;
                    mem_enable <= 0;
                    corrects <= 0;
                  end
                end
        PLAY:   begin
                  fr_enable <= 0;
                  if (~sd_is_empty) begin
                    sd_sync <= 0;
                  end
                  if (sd_is_empty & (sd_sync == 0)) begin
                    sd_sync <= 1;
                    if (~simon_says | round_passed)
                      fsm <= PASS;
                    else
                      fsm <= FAIL;
                  end
                  else if (sk_strobe) begin
                    if (~simon_says) begin
                      fsm <= FAIL;
                    end
                    fr_enable <= 1;
                  end
                end
        FAIL:   wrongs <= 1'b1;
        PASS:   begin
                  corrects <= 1'b1;
                  if (result == 9) begin
                    fsm <= WIN;
                  end
                  else begin
                    sd_sync <= 1;
                    if (~sd_is_empty) begin
                      sd_sync <= 0;
                      result <= result + 1;
                      fsm <= READY;
                    end
                  end
                end
        WIN:    corrects <= 1'b1;
        default: fsm <= fsm;
      endcase
    end
  end
endmodule
