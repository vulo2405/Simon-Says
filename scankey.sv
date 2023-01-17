module scankey(input logic clk, rst,
               input logic [19:0] in,
               output logic strobe,
               output logic [4:0] out);
  logic [1:0] delay;
  always_ff @ (posedge clk, posedge rst) begin
    if (rst == 1) begin
      delay <= 0;
    end
    else begin
      delay <= (delay << 1) | {1'b0, |in[19:0]};
    end
  end
  
  assign strobe = delay[1];
  
  assign out[0] = in[1] | in[3] | in[5] | in[7] | in[9] | in[11] | in[13] | in[15] | in[17] | in[19];
  assign out[1] = |in[3:2] | |in[7:6] | |in[11:10] | |in[15:14] | |in[19:18];
  assign out[2] = |in[7:4] | |in[15:12];
  assign out[3] = |in[15:8];
  assign out[4] = |in[19:16];
endmodule
