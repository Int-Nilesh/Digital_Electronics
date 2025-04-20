module tb_ff;
  reg j,k,clk = 0, rst;
  wire q;
  
  JK_ff dut (.j(j), .k(k), .clk(clk), .rst(rst), .q(q));
  
  always #5 clk = ~clk;
  
  initial begin
    $dumpfile("dump.vcd");
    $dumpvars();
    #500;
    $finish();
  end
  
  initial begin
    rst = 0;
    #20;
    
    rst =1;
    j = 1;
    k = 0;
    #20;
    
    j = 0;
    k = 0;
    #20;
    
    j = 1;
    k = 1;
    #20;
    
    j = 0;
    k = 1;
    #20;
    
  end
endmodule
  
  
              