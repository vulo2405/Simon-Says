module simonsays #(
        parameter CLKDIV_LIM=8'd6
        // DO NOT CHANGE THE VALUE OF CLKDIV_LIM
    )(
        input logic hz100, reset,
        input logic [19:0] pb,
        output logic [7:0] left, right,
        output logic [7:0] ss7, ss6, ss5, ss4, ss3, ss2, ss1, ss0,
        output logic red, green, blue
    );
  logic hzX, sd_srst, fr_en, mem_en, simon_says, is_wrong, is_correct, sd_is_empty, strobe;
  logic [15:0] sd_out;
  logic [7:0] fr_out;
  logic [11:0] mem_out;
  logic [3:0] score;
  logic [2:0] state;

  clkdiv clkdv (.clk(hz100), .lim(CLKDIV_LIM), .rst(reset), .hzX(hzX));
  shiftdown sd (.clk(hzX), .rst(reset), .srst(sd_srst), .out(sd_out));
  freerun r1 (.clk(hz100), .rst(reset), .en(fr_en), .max(8'd255), .out(fr_out));
  mem mem1 (.clk(hz100), .en(mem_en), .sel(fr_out), .btns(mem_out));
  scankey sk (.clk(hz100), .rst(reset), .in(pb[19:0]), .strobe(strobe));

  typedef enum logic [2:0] {
    READY = 0,
    PLAY = 1,
    FAIL = 2,
    PASS = 3,
    WIN = 4
  } dcl_fsm_t;

  logic ssdec_en;
  logic [4:0] in_sd1, in_sd2, in_sd3, in_sd4, in_sd5, in_sd6, in_sd7, in_sd8;

  ssdec_ext sd1 (.enable(ssdec_en), .in(in_sd1), .out(ss0[6:0]));
  ssdec_ext sd2 (.enable(ssdec_en), .in(in_sd2), .out(ss1[6:0]));
  ssdec_ext sd3 (.enable(ssdec_en), .in(in_sd3), .out(ss2[6:0]));;
  ssdec_ext sd4 (.enable(ssdec_en), .in(in_sd4), .out(ss3[6:0]));
  ssdec_ext sd5 (.enable(ssdec_en), .in(in_sd5), .out(ss4[6:0]));
  ssdec_ext sd6 (.enable(ssdec_en), .in(in_sd6), .out(ss5[6:0]));;
  ssdec_ext sd7 (.enable(ssdec_en), .in(in_sd7), .out(ss6[6:0]));
  ssdec_ext sd8 (.enable(ssdec_en), .in(in_sd8), .out(ss7[6:0]));;

  always_comb begin
    if(state == READY) begin
      ssdec_en = 1;
      in_sd1 = {1'b0, score};
      in_sd2 = 5'h1a;
      in_sd3 = 5'h19;
      in_sd4 = 5'h18;
      in_sd5 = 5'hd;
      in_sd6 = 5'ha;
      in_sd7 = 5'he;
      in_sd8 = 5'h16;
    end
    else if (state == PLAY | state == PASS) begin
      ssdec_en = 1;
      in_sd1 = {1'b0, mem_out[3:0]};
      in_sd2 = {1'b0, mem_out[7:4]};
      in_sd3 = {1'b0, mem_out[11:8]};
      in_sd4 = 5'h1a;
      in_sd5 = 5'hd;
      in_sd6 = 5'h14;
      in_sd7 = 5'h0;
      in_sd8 = 5'h11;
    end
    else if (state == FAIL) begin
      ssdec_en = 1;
      in_sd1 = 5'h15;
      in_sd2 = 5'h12;
      in_sd3 = 5'ha;
      in_sd4 = 5'h10;
      in_sd5 = 5'ha;
      in_sd6 = 5'h18;
      in_sd7 = 5'h16;
      in_sd8 = 5'h17;
    end
    else if (state == WIN) begin
      ssdec_en = 1;
      in_sd1 = 5'hb;
      in_sd2 = 5'h0;
      in_sd3 = 5'h13;
      in_sd4 = 5'h1a;
      in_sd5 = 5'hd;
      in_sd6 = 5'h0;
      in_sd7 = 5'h0;
      in_sd8 = 5'h10;
    end
    else begin
      ssdec_en = 0;
      in_sd1 = 5'h1a;
      in_sd2 = 5'h1a;
      in_sd3 = 5'h1a;
      in_sd4 = 5'h1a;
      in_sd5 = 5'h1a;
      in_sd6 = 5'h1a;
      in_sd7 = 5'h1a;
      in_sd8 = 5'h1a;
    end
  end

  assign simon_says = ^mem_out;
  assign {left, right} = (state == PLAY | state == READY) ? sd_out : 0;
  assign blue = (state == PLAY) ? simon_says : 0;
  assign red = is_wrong;
  assign green = is_correct;

  controller ctrl (.clk(hz100), .rst(reset), .simon_says(simon_says), .sk_strobe(strobe),
                   .round_passed((pb[{1'b0, mem_out[3:0]}] == 1 & pb[{1'b0, mem_out[7:4]}] == 1 & pb[{1'b0, mem_out[11:8]}] == 1) ? 1 : 0),
                   .sd_is_empty((sd_out == 0) ? 1 : 0), .sd_srst(sd_srst),
                   .fr_en(fr_en), .mem_en(mem_en), .score(score), .state(state), .is_wrong(is_wrong), .is_correct(is_correct));
endmodule
