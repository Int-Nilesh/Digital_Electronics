module dff(dff_if dif);
  always @(posedge dif.clk) begin
    if (dif.rst == 1'b 1) 
      dif.q <= 1'b 0;
    else 
      dif.q <= dif.d;
  end 
endmodule

interface dff_if;
  logic rst;
  logic clk;
  logic d;
  logic q;
  

endinterface