//Unit to generate sequence 0000, 0001, 0011, 0111, 1111
//							1111, 1110, 1100, 1000, 0000


module seq #(parameter int WIDTH = 8)
  (input logic clk,
   input logic rst,
   output logic [WIDTH-1 : 0]out);
  logic shift_bit;
  logic [WIDTH-1 : 0]out_reg;
  always_ff @(posedge clk) begin
    if (!rst) begin
      shift_bit <= 0;
      out_reg <= 0;
    end 
    else if (out_reg == {WIDTH{1'b 1}}) begin
      shift_bit <= 0;
      out_reg <= shift_bit | (out_reg <<1); //  to assert "0" in all "1"
    end
    else if (out_reg == {WIDTH{1'b 0}}) begin
      shift_bit <= 1;
      out_reg <= shift_bit | (out_reg <<1); // to assert "1" in all "0"
    end
    else 
      out_reg <= shift_bit | (out_reg << 1); // shift and add "0" or "1" depending on last operation
    $display("%b", out_reg); // to synthesize remove this statement
  end
  
  assign out = out_reg;
endmodule