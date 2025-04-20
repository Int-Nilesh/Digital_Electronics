module mod12_counter(input clk, input reset, ouput reg [3:0] count);
  always @(posedge clk) begin
    if(reset)
      count<= 4'b0000;
    else if(count ==4'b1011)
      count <= 4'b0000;
    else
      count <= count +1;
  end