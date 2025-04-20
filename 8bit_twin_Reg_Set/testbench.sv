module twin_reg_tb;
  reg [7:0] d1, d2;
  reg clk = 0, rst = 1;
  wire [7:0] q1, q2;
  
  twin_reg dut(.d1(d1), .d2(d2), .clk(clk), .rst(rst), .q1(q1), .q2(q2));
  
  initial begin
    $dumfile("dumofile.vcd");
    $dumpvars();
    #500;
    $finish();
  end
  initial begin
    $monitor("time: %0t d1: %0b d2: %0b rst: %0d q1: %0d q2: %0d ", $time, d1, d2, rst, q1, q2);
  end
  
  initial begin
    
    rst = 0;
    #50;
    
    rst = 1;
    d1 = 67;
    d2 = 99;
    #50;
    
    d1 = 43;
    d2 = 32;
    #50;
    
  end
endmodule
    