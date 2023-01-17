module shiftdown (input logic clk, rst,
                              srst,
                  output logic [15:0] out);
  always_ff @ (posedge clk, posedge rst) begin
    if (rst) begin
      out <= 16'hFFFF;
    end
    else if (srst) begin
      out <= 16'hFFFF;
    end
    else if (!rst) begin
      out <= (out >> 1);
    end
  end
endmodule
