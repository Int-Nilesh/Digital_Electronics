module day3_tb;
  reg clk = 0;
  reg reset;
  reg a_i;
  
  wire rising_edge_o, falling_edge_o;
  
  day3 dut ( .clk(clk), .reset(reset), .a_i(a_i), .rising_edge_o(rising_edge_o), . falling_edge_o( falling_edge_o));
  
  always #5 clk = ~clk;
  
  initial begin
    reset = 1;
    #5;
    reset = 0;
    #5;
    a_i = 0;
    #20;
    a_i = 1; 
    
    #5;
    a_i = 1;
    #20;
    a_i = 0;
  end
  
  initial begin
    $dumpfile("dumpfile.vcd");
    $dumpvars();
    
    #100;
    $finish();
    
  end 
  
endmodule
    
    
    