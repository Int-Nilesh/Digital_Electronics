//Priority Encoder

module priority_encoder (input [3:0] m, // one hot 4 bit input signal 
                output reg [1:0] n, // encoded 2 bit out signal
                         output reg v); //valid bit set when input M is all zero
  
  always @(*) begin
    if (m[3]) {v,n} = 3'b 111;
    else if (m[2]) {v,n} = 3'b 110;
    else if (m[1]) {v,n} = 3'b 101;
    else if (m[0]) {v,n} = 3'b 100;
    else {v,n} = 3'b 000;
  end
endmodule