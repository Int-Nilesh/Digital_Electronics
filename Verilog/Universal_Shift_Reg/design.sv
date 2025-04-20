// 5 bit universal shift reg

module uni_shift ( input sin,input dir, clk, rst, output reg [4:0] out);
  always @(posedge clk) begin
    if (!rst) 
      out <= 5'b 0;
    else if ( dir ) // dir ==1 left shift
      out <= {out[3:0], sin};
    else 
      out <= {sin, out[4:1]};; // dir == 0 right shift
  end
endmodule