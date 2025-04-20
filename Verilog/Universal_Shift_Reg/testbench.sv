module uni_shift_tb;
  reg  sin;
  reg dir, clk= 1, rst = 0;
  wire [4:0] out;
  
  uni_shift dut ( .sin(sin), .dir(dir), .clk(clk), .rst(rst), .out(out));
  
  always #5 clk = ~clk;
  
  initial begin
    $dumpfile ("dumpfile.vcd");
    $dumpvars();
    #500;
    $finish();
  end
  initial begin
    $monitor("time: %0t sin: %b dir: %b out: %b", $time, sin, dir, out);
  end
  
  initial begin
    rst = 0;
    #50;
    rst = 1;
    for( int i = 0; i <10; i++) begin
      if ( i % 2)begin 
        dir = 1;
      	sin = 1;
        #10;
      end
      else begin
        dir = 0;
        sin = 1;
        #10;
      end
    end
  end
endmodule
    
    
    
            
    