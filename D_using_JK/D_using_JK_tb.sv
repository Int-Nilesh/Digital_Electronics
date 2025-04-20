module d_jk_tb;
  reg d, clk = 0, rst = 1;
  wire q;
  
  always #5 clk = ~clk;
  
  d_jk dut(.d(d), .clk(clk), .rst(rst), .q(q));
  
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
    
    d = 1;
    #20;
    
    d = 0;
    #20;
    
    d= 1;
    #20;
  end 
endmodule