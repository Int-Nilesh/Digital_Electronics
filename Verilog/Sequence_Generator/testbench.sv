module tb;
  logic clk, rst;
  parameter int WIDTH = 4;
  logic [WIDTH-1: 0] out;
  
  
  seq #(.WIDTH(16)) dut(.clk(clk), .rst(rst), .out(out));
  
  always #5 clk = !clk;
  
  initial begin
    clk = 0;
    rst = 0;
    #20;
    rst = 1;
    #500;
    $finish();
  end 
endmodule
    
    
    