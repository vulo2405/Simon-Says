module clkdiv( input logic clk, rst,
                  input logic [7:0] lim,
                  output logic hzX);
  logic [7:0]Q;
  logic [7:0]next_Q;
  logic flash;

  always_ff @ (posedge clk, posedge rst) begin
    if (rst == 1) begin
      Q <= 0;
    end
    else begin
      Q <= next_Q;
    end
  end

  always_ff @ (posedge clk, posedge rst) begin
    if(rst == 1) begin
      flash <= 0;
    end
    else begin
      flash <= (Q == (lim));
    end
  end

  always_ff @ (posedge flash, posedge rst) begin
    if(rst == 1) begin
      hzX <= 0;
    end
    else begin
      hzX <= ~hzX;
    end
  end
 
  always_comb begin
    if (Q == lim) begin
      next_Q = 8'd00;
    end
    else begin
      next_Q[0] = ~Q[0];
      next_Q[1] = Q[1] ^ Q[0];
      next_Q[2] = Q[2] ^ (&Q[1:0]);
      next_Q[3] = Q[3] ^ (&Q[2:0]);
      next_Q[4] = Q[4] ^ (&Q[3:0]);
      next_Q[5] = Q[5] ^ (&Q[4:0]);
      next_Q[6] = Q[6] ^ (&Q[5:0]);
      next_Q[7] = Q[7] ^ (&Q[6:0]);
    end
  end
endmodule
