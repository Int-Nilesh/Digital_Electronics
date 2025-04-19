module jk_d_tb;
  reg j,k,clk =0, rst =1;
  
  jk_d dut(.j (j), .k(k), .clk(clk), .rst(rst), .q(q));
  
  always #5 clk = ~clk;
  
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
    j = 0;
    k = 0;
    #20;
    
    j = 0;
    k = 1;
    #20;
        
    j = 1;
    k = 0;
    #20;
        
    j = 1;
    k = 1;
    #20;
  end
endmodule
        
            