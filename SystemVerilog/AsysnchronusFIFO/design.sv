module fifo( fifo_if fif);
  reg [7:0] mem [15:0]; // 16 slots each can sotre 8 bit
  reg [4:0] count=0;
  
  reg [3:0] wptr = 0, rptr = 0;
  
  always @(posedge fif.clk) begin
    if (fif.rst == 1'b 1) begin
      wptr <= 0;
      rptr <= 0;
      count <= 0;
    end
    else if (fif.wr && !fif.full) begin
      mem [wptr] <= fif.din;
      wptr <= wptr +1;
      count <= count+1;
    end
    else if (fif.rd && !fif.empty) begin
      fif.dout <= mem[rptr];
      rptr <= rptr+1;
      count <= count -1;
    end
  end 
  
  assign fif.full = (count == 16) ? 1'b 1 : 1'b 0; 
  assign fif.empty = (count == 0) ? 1'b 1: 1'b 0;
  
  A1: assert property(@(posedge fif.clk) fif.empty |=> !fif.rd) else $error("FIFO is empty, but read attempted");
      
endmodule

interface fifo_if;
  logic rd; 
  logic wr;
  logic clk;
  logic rst;
  logic [7:0] din;
  logic [7:0] dout;
  logic empty;
  logic full;
endinterface
  
  