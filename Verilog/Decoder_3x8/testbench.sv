module decoder3_8_tb;
  reg[2:0] in= 0;
  reg en;
  wire [7:0] out;
  
  decoder3_8 dut (.in(in), .en(en), .out(out));
  
  initial begin 
    $dumpfile("dumpvars.vcd");
    $dumpvars();
  end
  
  initial begin
    en = 1;
    
    repeat(8) begin
      in = in +1;
      #10;
      $display("out: %b", out );
    end
    
    en = 0;
    repeat(8) begin
      in = in +1;
      #10;
      $display("out: %0b", out );
    end
  end
endmodule