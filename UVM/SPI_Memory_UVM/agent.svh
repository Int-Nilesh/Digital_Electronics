// The uvm sequence, transaction item, and driver are in these files:
`include "sequencer.svh"
`include "monitor.svh"
`include "driver.svh"

// The agent contains sequencer, driver, and monitor
class spi_agent extends uvm_agent;
   
   //register agent using uvm_macros
  `uvm_component_utils(spi_agent);

  //declare the monitor and driver objects
  spi_driver drv; 
  spi_monitor mon; 
  spi_sequence seq; 

  
  
  // our sequencer initialized
  uvm_sequencer#(spi_packet) sequencer;

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    // driver, sequencer, and monitor objects initialized
	//initialize driver, sequencer, and monitor objects
    drv = spi_driver::type_id::create("drv", this); 
    mon = spi_monitor::type_id::create("mon", this); 
    seq = spi_sequence::type_id::create("seq", this); 
    sequencer = uvm_sequencer#(spi_packet)::type_id::create("sequencer", this); 
    `uvm_info("TEST", $sformatf("Agent build Passed"), UVM_MEDIUM); 
  endfunction    

  // connect_phase of the agent
  function void connect_phase(uvm_phase phase);
	//connect the driver and the sequencer
    drv.seq_item_port.connect(sequencer.seq_item_export);
	// make the monitor and driver drvdone events point to the same thing
    mon.drvdone = drv.drvdone;
    mon.mondone = drv.mondone; 
    `uvm_info("TEST", $sformatf("Agent connect Passed"), UVM_MEDIUM);
  endfunction

  task run_phase(uvm_phase phase);
    // We raise objection to keep the test from completing
    phase.raise_objection(this);
    `uvm_info("TEST", $sformatf("Agent run Started"), UVM_MEDIUM);


	//create sequence and start it.
    seq.start(sequencer);
    wait(mon.mondone.triggered);
    // We drop objection to allow the test to complete
    phase.drop_objection(this);
  endtask

endclass
