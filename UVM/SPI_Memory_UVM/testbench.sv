// In Vivado 2022 don't include this line. On EdaPlaygrounds do.
import uvm_pkg::*; 

`include "uvm_macros.svh"
`include "test.svh"
`include "interface.svh"

// Top module in the hierarchy. includes all the testing
module top_tb;

  // Instantiate the interface
  spi_dut spi_if();
  
  // Instantiate the DUT and connect it to the interface
  top spi_dut ( .clk(spi_if.clk), .rst(spi_if.rst), .wr(spi_if.wr),
               .din(spi_if.din), .addr(spi_if.addr), .done(spi_if.done),
               .err(spi_if.err), .dout(spi_if.dout));

  initial begin
    spi_if.clk <= 0;
    // Place the interface into the UVM configuration database
    uvm_config_db#(virtual spi_dut)::set(null, "*", "spi_if", spi_if);
    // Start the test
    run_test("spi_test");
  end
  
  always #5 spi_if.clk <= ~spi_if.clk; 
  
  // Dump waves
  initial begin
    $dumpfile("dump.vcd");
    $dumpvars;
  end
  
endmodule
