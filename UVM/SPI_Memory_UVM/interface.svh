
// the DUT interface
interface spi_dut;
  logic clk;
  logic rst;
  logic wr;
  logic [7:0] din;
  logic [7:0] addr;
  logic done;
  logic err;
  logic [7:0] dout;
endinterface
