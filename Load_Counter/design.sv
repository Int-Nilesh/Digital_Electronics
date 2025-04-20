// designing load counter with mod vlaue

module counter( input clk, rst, load, input [7:0] load_value, [7:0] mod_value, output reg [7:0] count);
  always @ (posedge clk) begin
    if (!rst)
      count <= 8'b 0;
    if (load)
      count <= load_value;
    if (count == mod_value)
        count <= load_value;
    if (rst && count != mod_value)
      count <= count + 1;
  end
endmodule
    