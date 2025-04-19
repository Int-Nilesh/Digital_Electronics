
module dff (dff_if dif);
  
  always@(posedge dif.clk)
    begin
      if(dif.rst == 1'b1)
        dif.q <= 1'b0;
      else if (dif.d >= 1'b0)
         dif.q <= dif.d;
      else
         dif.q <= 1'b0;
    end
  
endmodule
 
 
interface dff_if;
  logic clk;
  logic rst;
  logic d;
  logic q;
  
endinterface