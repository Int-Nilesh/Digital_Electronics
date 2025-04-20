interface ma_if;
  logic [7:0] a;
  logic [7:0] b;
  bit s;
  logic [7:0] out;
endinterface

module mux21 ( ma_if maif);
  
  assign maif.out = (maif.s) ? maif.a : maif.b;
  
endmodule