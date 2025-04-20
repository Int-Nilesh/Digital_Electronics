 // An edge detector

module day3 (
  input     wire    clk,
  input     wire    reset,

  input     wire    a_i,

  output    wire    rising_edge_o,
  output    wire    falling_edge_o
);
  reg temp;
  
  always @(posedge clk) begin
    if (!reset)
      temp <= 0;
    temp <= a_i;
  end
  
  assign rising_edge_o = a_i & (~temp);
  assign falling_edge_o = (~a_i) & temp;
  
endmodule