module div3_tb;
  reg clk = 0, rst = 1;
  wire clk_out;
  
  
  div3 dut( .clk(clk), .rst(rst), .clk_out(clk_out));
  
  always #5 clk = ~ clk;
  
  initial begin
    $dumpfile("dump.vcd");
    $dumpvars();
    #300;
    $finish();
  end
  
  initial begin
    rst = 0;
    #20;
    
    rst = 1;
  end
  
endmodule
            
    
  