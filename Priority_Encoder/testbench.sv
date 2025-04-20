module priority_encoder_tb;
  reg [3:0] m;
  wire [1:0] n;
  wire v;
  
  priority_encoder dut (.m(m), .n(n), .v(v));
  
  initial begin
    $dumpfile("dumpfile.vcd");
    $dumpvars();
  end
  
  initial begin
    m = 4'b 000;
    #10;
    $display("m: %b v: %b n: %b", m, v, n);
    for( int i = 0; i <4; i++) begin
      m[i] = 1;
      #10;
      $display("m: %b v: %b n: %b", m, v, n);
    end
  end
endmodule
    