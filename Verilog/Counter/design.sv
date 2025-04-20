module counter ( input wire clk,
                input wire rst,
                input wire load,
                input wire [3:0] load_val,
                output reg [3:0] count);
  always @(posedge clk) begin
    if (!rst)
      count <= 4'b0;
    if (load && rst)
      count <= load_val;
    if (count == 4'b1111 && rst)
      count <= load_val;
    if(rst && (!load))
      count <= count + 1;
  end
endmodule
                