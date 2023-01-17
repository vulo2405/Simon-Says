module mem (input logic clk, en,
            input logic [7:0] sel,
            output logic [11:0] btns);
  logic [11:0] memory [255:0];
  logic [11:0] btns_next;

  initial begin
    $readmemh("press.mem", memory, 0, 255);
  end

  always_ff @ (posedge clk) begin
    if (en == 1) begin
      btns <= btns_next;
    end
    else begin
      btns <= btns;
    end
  end

  always_comb begin
    btns_next = memory[sel][11:0];
  end
endmodule
