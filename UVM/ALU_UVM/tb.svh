// In Vivado 2022 don't include this line. On EdaPlaygrounds do.
import uvm_pkg::*; 

`include "uvm_macros.svh"
`include "test.svh"
`include "interface.svh"

// Top module in the hierarchy. includes all the testing
module top;

  // Instantiate the interface
  salu_dut dut_ifl();
  
  // Instantiate the DUT and connect it to the interface
  salu dut1 (
  //connect the dut to the interface
    .clk(dut_ifl.clock),
    .cmd(dut_ifl.cmd),
    .ain(dut_ifl.a),
    .bin(dut_ifl.b),
    .outr(dut_ifl.out)
  );
    
  initial begin
    dut_ifl.clock <= 1'b 0;
    // Place the interface into the UVM configuration database
    uvm_config_db#(virtual salu_dut)::set(null, "*", "dut_vif", dut_ifl);
    // Start the test
    run_test("salu_test");
  end
  
  always #5 dut_ifl.clock <= ~dut_ifl.clock; 
  
  // Dump waves
  initial begin
    $dumpfile("dump.vcd");
    $dumpvars(0, top);
  end
  
endmodule
