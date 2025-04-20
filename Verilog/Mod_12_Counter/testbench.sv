// Code your testbench here
// or browse Examples
module mod12_tb;
  
  reg clk, reset;
  wire [3:0] count;
  
  mod12_counter dut(.clk(clk), .reset(reset), .count(count));
  
  always #5 clk = ~clk;
  initial 
    
    begin
      clk = 0;
      reset = 1;
      #10;
      reset = 0;
      
      #150;
      
      
      #10 reset = 1;
      #10 reset = 0;
      
      #120;
      
    end
  initial begin
    #400;
    $finish
  end
  
  initial begin
    $monitor("Time: %0t, RESET: %0b, Count = %0d", $time, reset, count);
    
  end
  
  
endmodule