module comparitor_tb;
  reg [3:0] a,b;
  wire eq, gr, less;
  
  comparitor dut (.a(a), .b(b), .eq(eq), .gr(gr), .less(less));
  
  initial begin
    $dumpfile("dumpfile.vcd");
    $dumpvars();
  end
  
  initial begin
    a = 4'b 0000;
    b = 4'b 0000;
    #10;
    $display("eq: %d gr: %od less: %od", eq, gr, less);
    a = 4'b 1010;
    b = 4'b 1101;
    #10;
    $display("eq: %d gr: %od less: %od", eq, gr, less);
  end
endmodule
    