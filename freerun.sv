module freerun (input logic clk, rst, en,
                input logic [7:0] max,
                output logic [7:0] out);
  logic [7:0] next_out;

  always_ff @ (posedge clk, posedge rst) begin
    if (rst) begin
      out <= 0;
    end
    else if (!rst & en) begin
      if (out == max) begin
        out <= 0;
      end
      else begin
        out <= next_out;
      end
    end
    else if (!en) begin
      out <= out;
    end
  end

  always_comb begin
    next_out = out + 1;
  end
endmodule
