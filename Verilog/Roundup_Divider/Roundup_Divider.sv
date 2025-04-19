
//Divide an input number by a configurable power of two (2^n) and round the result to the nearest integer. If there’s a remainder of 0.5 or greater, round up. In case of overflow, saturate the output.

module divider (input [7:0] in, input [3:0] n, output reg [7:0] out);
  always @(in or n) begin
    if (n > 0 && in[n-1])begin // if (n-1)th bit is 1 means reminder will be >0.5 
      out = in >> n;
      out = out + 1; // round UP if reminder is >0.5
    end
    else
      out = in >> n; // reminder is < 0.5
  end
endmodule
    
