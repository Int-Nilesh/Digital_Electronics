// d latch with synchronus reset

module dlatch( input d, input en, input rst, output reg q);
  always @(en, q)  begin // always block triggeres only when en or q changes there value
    if (!rst) begin
      q = 1'b 0;
    end
    if (en && rst)
      q = d;
  end
endmodule