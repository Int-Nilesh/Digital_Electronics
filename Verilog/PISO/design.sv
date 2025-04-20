module PISO(input clk,
            input rst,
            input wire [3:0] p_in, 
            output reg s_out,
            output reg empty
            );
  reg [1:0] count;
  always @(posedge clk) begin
    if (!rst) begin
      count <= 0;
      s_out <= 0;
      empty <= 0;
    end
    
    if(count <= 2'b11 && rst) begin
      empty <= 0;
      s_out <= 0;
    end
    
    if(count > 2'b11 && rst) begin
      count <= 0;
      empty <= 1;
    end
    if (!empty && rst) begin
      count <= count +1;
      case (count)
        2'b00: s_out <= p_in[0];
        2'b01: s_out <= p_in[1];
        2'b10: s_out <= p_in[2];
        2'b11: s_out <= p_in[3];
        default: s_out <= 0;
      endcase
    end
    if(count == 2'b11 && rst) begin
      count <= 0;
      empty <= 1;
    end
  end
endmodule
      
  