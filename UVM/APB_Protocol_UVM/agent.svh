// The uvm sequence, transaction item, and driver are in these files:
`include "sequencer.svh"
`include "monitor.svh"
`include "driver.svh"
`include "coverage.svh"

// The agent contains sequencer, driver, and monitor
class apb_agent extends uvm_agent;
   
   //register agent using uvm_macros
  `uvm_component_utils(apb_agent);

  //declare the monitor and driver objects
  apb_driver drv; //added by me 
  apb_monitor mon; //added by me 
  apb_sequence seq; //added by me 
  apb_coverage cov;

  
  
  // our sequencer initialized
  uvm_sequencer#(apb_packet) sequencer;

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    // driver, sequencer, and monitor objects initialized
	//initialize driver, sequencer, and monitor objects
    drv = apb_driver::type_id::create("drv", this); //added by me
    mon = apb_monitor::type_id::create("mon", this); //added by me
    seq = apb_sequence::type_id::create("seq", this); //added by me
    cov = apb_coverage::type_id::create("cov", this); // added by me
    sequencer = uvm_sequencer#(apb_packet)::type_id::create("sequencer", this); //added by me
    `uvm_info("TEST", $sformatf("Agent build Passed"), UVM_MEDIUM); //added by me
  endfunction    

  // connect_phase of the agent
  function void connect_phase(uvm_phase phase);
	//connect the driver and the sequencer
    drv.seq_item_port.connect(sequencer.seq_item_export);//added by me
	// make the monitor and driver drvdone events point to the same thing
    //monitor.drvdone = driver.drvdone; // added by pro is wrong
    mon.drvdone = drv.drvdone; // added by me
    mon.mondone = drv.mondone; // added by me
    mon.mon_analysis_port.connect(cov.apb_cover_imp); //added by me
    `uvm_info("TEST", $sformatf("Agent connect Passed"), UVM_MEDIUM); //added by me
  endfunction

  task run_phase(uvm_phase phase);
    // We raise objection to keep the test from completing
    phase.raise_objection(this);
    `uvm_info("TEST", $sformatf("Agent run Started"), UVM_MEDIUM); // added by me


	//create sequence and start it.
    seq.start(sequencer);
    
    // We drop objection to allow the test to complete
    phase.drop_objection(this);
  endtask

endclass
