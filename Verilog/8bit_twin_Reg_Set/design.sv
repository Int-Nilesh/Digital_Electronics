// 8 bit twin resgiter set

module twin_reg ( input [7:0] d1, d2, input clk, input rst, output reg [7:0] q1, q2);
  always @(posedge clk) begin
    if (!rst)begin
      q1 <= 8'b 0;
      q2 <= 8'b 0;
    end
    else begin 
      q1 <= d1; // this will create 8 1 bit dff
      q2 <= d2; // this will create 8 1 bit dff
    end 
  end 
endmodule