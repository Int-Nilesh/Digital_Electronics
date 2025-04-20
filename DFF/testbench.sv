module dff_tb;
  reg d, clk = 0, rst, set;
  wire q;
  
  always #5 clk = ~clk;
  dff dut(.d(d), .clk(clk),.set(set), .rst(rst), .q(q));
  
  initial begin
    $dumpfile("dumpfile.vcd");
    $dumpvars();
    #300;
    $finish();
  end
  
  initial begin
    
    rst = 0;
    d =1;
    set = 0;
    #50;
    $display("d: %b q: %b", d, q);
    
    rst = 1;
    d = 1;
    set = 0;
    #50;
    $display("d: %b q: %b", d, q);
    
    d = 0;
    set = 0;
    #50;
    $display("d: %b q: %b", d, q);
    
    d = 0;
    set = 1;
    #50;
    $display("d: %b q: %b", d, q);
    
  end
endmodule
    