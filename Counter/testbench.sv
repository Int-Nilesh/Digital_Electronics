module count_tb;
  reg clk = 0;
  reg rst, load;
  
  reg [3:0] load_val;
  wire [3:0] count;
  
  counter dut (.clk(clk), .rst(rst), .load(load), .load_val(load_val), .count(count));
  
  always #5 clk = ~clk;
  
  initial begin
    rst = 0;
    #20;
    $display ("%0d", count);
    #20;
    rst = 1;
    load = 1'b1;
    load_val = 4'b1100;
    #20;
    $display ("%0d", count);
    load = 0;
    
    #50;
    $display ("%0d", count);
    
    $finish();
  end
  
  initial begin
    $dumpfile("dumpfile.vcd");
    $dumpvars();
  end
    
  
endmodule
    