module PISO_tb;
  reg clk = 0;
  reg rst;
  reg [3:0] p_in;
  wire s_out;
  wire  empty = 0;
  
  PISO dut(.clk(clk), .rst(rst), .p_in(p_in), .s_out(s_out), .empty(empty));
  
  always #5 clk = ~clk;
  
  initial begin
    $dumpfile("dumpfile.vcd");
    $dumpvars();
  end
  
  initial begin
    rst = 0;
    p_in = 4'b 0000;
    #50;
    rst = 1;
    p_in = 4'b 1101;
    #50;
    p_in = 4'b 0000;
    #50;
    p_in = 4'b 1011;
    
    #50
    p_in = 4'b 0000;
    #50;
    p_in = 4'b 1010;
    #50;
    p_in = 4'b 0000;
    
  end
  
  initial begin 
    #500;
    $finish();
  end
  
endmodule
    
    