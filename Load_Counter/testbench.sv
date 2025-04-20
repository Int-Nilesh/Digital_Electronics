module counter_tb;
  reg clk = 1, rst = 1, load;
  reg [7:0] load_value, mod_value;
  wire [7:0] count;
  
  counter dut(.clk(clk), .rst(rst), .load(load), .load_value(load_value), .mod_value(mod_value), .count(count));
  
  always #5 clk = ~clk;
  
  initial begin
    $dumpfile("dump.vcd");
    $dumpvars();
    
    $monitor("time : %0t rst: %b load: %b load_value: %0d mod_value: %0d count: %0d", $time, rst, load, load_value, mod_value, count);
  end
  
  initial begin
    rst = 0;
    load = 1;
    load_value = 5;
    mod_value = 18;
    #20;
    
    rst = 1;
    load = 1;
    #1000;
    
    $finish();
  end
endmodule
    
    
  