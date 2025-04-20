module mux21_tb;
  ma_if maif();
  
  mux21 dut (.maif);
  
  initial begin
    $dumpfile("dumvars.vcd");
    $dumpvars();
  end
  
  initial begin
    maif.a = 23;
    maif.b = 37;
    
    maif.s = 0;
    #10;
    $display("output : %0d", maif.out);
    
    maif.s = 1;
    #10;
    $display("output : %0d", maif.out);
    
  end
endmodule
    
               
             