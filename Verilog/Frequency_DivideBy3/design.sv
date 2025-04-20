// frquency divider by 3

module div3 ( input clk, rst, output clk_out);
  reg [1:0] pos2, neg2;
  
  always @ ( posedge clk) begin
    if (!rst)
      pos2 <= 0;
    else if (pos2 == 2)
      pos2 <= 0;
    else
      pos2 <= pos2 +1;
  end
  
  always @ (negedge clk) begin
    if (!rst)
      neg2 <= 0;
    else if ( neg2 == 2)
      neg2 <= 0;
    else
      neg2 <= neg2 + 1;
  end
  
  assign clk_out = ((pos2 == 2) | (neg2 == 2));
  
endmodule