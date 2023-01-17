module ssdec_ext (input logic enable,
                  input logic [4:0] in,
                  output logic [6:0] out);
  logic [6:0] segment [31:0];
  //logic [6:0] segment_new;
  //ssdec sd (.in(in[3:0]), .enable(enable), .out(segment_new));

  assign segment[5'h10] = 7'b1101111;
  assign segment[5'h11] = 7'b1110110;
  assign segment[5'h12] = 7'b0010000;
  assign segment[5'h13] = 7'b0011110;
  assign segment[5'h14] = 7'b0111000;
  assign segment[5'h15] = 7'b1010100;
  assign segment[5'h16] = 7'b1010000;
  assign segment[5'h17] = 7'b1111000;
  assign segment[5'h18] = 7'b1101110;
  assign segment[5'h19] = 7'b1010011;

  assign segment[5'h1a] = 0;
  assign segment[5'h1b] = 0;
  assign segment[5'h1c] = 0;
  assign segment[5'h1d] = 0;
  assign segment[5'h1e] = 0;
  assign segment[5'h1f] = 0;

  assign segment[5'h0] = 7'b0111111;
  assign segment[5'h1] = 7'b0000110;
  assign segment[5'h2] = 7'b1011011;
  assign segment[5'h3] = 7'b1001111;
  assign segment[5'h4] = 7'b1100110;
  assign segment[5'h5] = 7'b1101101;
  assign segment[5'h6] = 7'b1111101;
  assign segment[5'h7] = 7'b0000111;
  assign segment[5'h8] = 7'b1111111;
  assign segment[5'h9] = 7'b1100111;
  assign segment[5'ha] = 7'b1110111;
  assign segment[5'hb] = 7'b1111100;
  assign segment[5'hc] = 7'b0111001;
  assign segment[5'hd] = 7'b1011110;
  assign segment[5'he] = 7'b1111001;
  assign segment[5'hf] = 7'b1110001;

  assign out = (enable) ? segment[in] : 0;
endmodule
