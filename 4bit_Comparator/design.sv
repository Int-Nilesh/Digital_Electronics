// 4 bit compariter

module comparitor(input [3:0] a, b,
                  output reg eq, gr, less);
  
  always @(*) begin
    eq = (a == b);
    gr = (a > b);
    less = (a < b);
  end
  
endmodule
