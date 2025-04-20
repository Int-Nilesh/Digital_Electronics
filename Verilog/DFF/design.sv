// Dff pos edge triggered with active LOW synchronus reset with synchronus active high set

module dff ( input d , input clk, input rst, input set, output reg q);
  
  always @( posedge clk) begin 
    if (!rst) 
      q <= 0;
    else if (set)
      q <= 1;
    else 
      q <= d;
  end
endmodule