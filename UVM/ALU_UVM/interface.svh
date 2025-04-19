
// the DUT interface
interface salu_dut;
  parameter data_width = 16;
  parameter cmd_width = 3;
  logic clock;
  logic [cmd_width-1:0] cmd;
  logic [data_width-1:0] a;
  logic [data_width-1:0] b;
  logic [data_width-1:0] out;
endinterface
