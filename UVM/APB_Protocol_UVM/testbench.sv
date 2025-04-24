// In Vivado 2022 don't include this line. On EdaPlaygrounds do.
// Set No of times you want to perform read/write operation from Test run phase
// it will first write  the memory fully and then randomly read and write call happens
import uvm_pkg::*; 

`include "uvm_macros.svh"
`include "test.svh"
`include "interface.svh"

// Top module in the hierarchy. includes all the testing
module top;

  // Instantiate the interface
  apb_if apbif();
  
  // Instantiate the DUT and connect it to the interface
  apb dut (
    .pclk(apbif.pclk),
    .prst(apbif.prst),
    .paddr(apbif.paddr),
    .psel(apbif.psel),
    .penable(apbif.penable),
    .pwdata(apbif.pwdata),
    .pwrite(apbif.pwrite),
    .prdata(apbif.prdata),
    .pready(apbif.pready),
    .pslverr(apbif.pslverr)
  );
    
  initial begin
    apbif.pclk = 0;
    // Place the interface into the UVM configuration database
    uvm_config_db#(virtual apb_if)::set(null, "*", "apb_if", apbif);
    // Start the test
    run_test("apb_test");
  end
  
  always #5 apbif.pclk = ~apbif.pclk;
  
  // Dump waves
  initial begin
    $dumpfile("dump.vcd");
    $dumpvars(0, top);
  end
  
endmodule
