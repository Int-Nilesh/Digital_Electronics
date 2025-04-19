// Create Jk FF using D FF

module jk_d (input j , k, clk, rst, output reg q);
  wire d;
  reg temp;
  
  assign d = (j & (~temp)) | ((~k) & temp);
  
  always @(posedge clk) begin
    if (!rst) begin   
      temp <= 0;     
      q <= 0;         
    end  
    else begin     
      q <= d;  
      temp <= q;       
    end         
  end             
endmodule
              
              
                
  
              
              