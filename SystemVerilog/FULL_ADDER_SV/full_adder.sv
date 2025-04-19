module add (
  input bit [3:0] a,b,
  output reg [4:0] sum,
  input clk
);
  always @(posedge clk) begin
    sum <= a + b;
  end
endmodule

