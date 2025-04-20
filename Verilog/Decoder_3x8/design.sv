module decoder3_8 (input [2:0] in,
                   output reg [7:0] out,
                   input en);
  
  always @(*) begin
    if (en) begin
      case (in)
        3'b 000: out = 8'b 00000001;
        3'b 001: out = 8'b 00000010;
        3'b 010: out = 8'b 00000100;
        3'b 011: out = 8'b 00001000;
        3'b 100: out = 8'b 00010000;
        3'b 101: out = 8'b 00100000;
        3'b 110: out = 8'b 01000000;
        3'b 111: out = 8'b 10000000;
      endcase
    end
    else
      out = 8'b 00000000;
  end
endmodule



          
        