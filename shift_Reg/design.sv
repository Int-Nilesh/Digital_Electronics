
module shift_reg(
  input     wire        clk,
  input     wire        reset,
  input     wire        x_i,      // Serial input

  output    reg [3:0]   sr_o
);
  always @(posedge clk) begin
    if (!reset)
      sr_o <= 4'b0;
    else
      //@(x_i) begin // keep this if we want to shift the value only when x_i is changing
        sr_o <= {sr_o[2:0], x_i};
      //end
  end
 
endmodule