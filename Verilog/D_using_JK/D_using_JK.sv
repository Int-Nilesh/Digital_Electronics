// create D FF using JK FF

module d_jk ( input d, clk, rst, output reg q);
  wire j, k;
  assign j = d;
  assign k = ~d;
  
  always @(posedge clk) begin    
    case({j,k})
      2'b 00 : q <= q;
      2'b 01 : q <= 0;
      2'b 10 : q <= 1;
      2'b 11 : q <= ~q;
    endcase
  end
endmodule
    
      
  