module divider_tb;
  reg[7:0] in;
  reg[3:0] n;
  wire[7:0] out;
  
  divider dut(.in(in), .n(n), .out(out));
  
  initial begin
    #10;
    in = 25;
    n = 2;
    #10;
    $display("%b %0d %b", in, n, out);
  end
endmodule
    
  