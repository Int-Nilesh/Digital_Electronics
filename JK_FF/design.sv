// JK FF Design

module JK_ff ( input j, k, clk, rst, output reg q);
  
  always @(posedge clk) begin
    if (!rst)
      q <= 0;
    case ({j , k})
      2'b 00: q <= q;
      2'b 01: q <= 0;
      2'b 10: q <= 1;
      2'b 11: q <= ~q;
    endcase
  end
endmodule