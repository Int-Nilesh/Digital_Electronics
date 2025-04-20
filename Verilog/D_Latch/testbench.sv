module dlatch_tb;
  reg d, en, rst;
  wire q;
  
  dlatch dut(.d(d), .en(en), .rst(rst), .q(q));
  
  initial begin
    $dumpfile("dumpfile.vcd");
    $dumpvars();
  end
  
  initial  begin
    rst = 1'b 0;
    en = 0;
    #10;
    $display("d :%d q:%d", d, q);
    
    rst = 1;
    d = 1;
    en = 1;
    #10;
    $display("d :%d q:%d", d, q);
    
    rst = 1;
    d = 0;
    en = 0;
    #10;
    $display("d :%d q:%d", d, q);
    
  end
endmodule
