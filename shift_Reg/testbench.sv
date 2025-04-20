module shift_reg_tb;
  reg clk =0;
  reg reset, x_i;
  
  wire [3:0] sr_o;
  
  shift_reg dut (.clk(clk), .reset(reset), .x_i(x_i), .sr_o(sr_o));
  
  always #5 clk = ~ clk;
  initial begin
    $monitor("%b", sr_o);
  end
  
  initial begin
    reset = 0;
    #20;
    
    reset = 1;
    
    #10;
    
    x_i = 1'b1;
    
    # 10;
    
    x_i = 1'b0;
    
    #10;
    x_i = 1'b1;
    
  end
  
  initial begin
    $dumfile("dumpfile.vcd");
    $dumpvars();
    #300;
    
    $finish();
  end
endmodule