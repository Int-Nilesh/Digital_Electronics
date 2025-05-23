// The uvm sequence, transaction item, and driver are in these files:
`include "sequencer.svh"
`include "monitor.svh"
`include "driver.svh"

// The agent contains sequencer, driver, and monitor
class salu_agent extends uvm_agent;
   
   //register agent using uvm_macros
  `uvm_component_utils(salu_agent);

  //declare the monitor and driver objects
  salu_driver drv; //added by me 
  salu_monitor mon; //added by me 
  salu_sequence seq; //added by me 

  
  
  // our sequencer initialized
  uvm_sequencer#(salu_packet) sequencer;

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    // driver, sequencer, and monitor objects initialized
	//initialize driver, sequencer, and monitor objects
    drv = salu_driver::type_id::create("drv", this); //added by me
    mon = salu_monitor::type_id::create("mon", this); //added by me
    seq = salu_sequence::type_id::create("seq", this); //added by me
    sequencer = uvm_sequencer#(salu_packet)::type_id::create("sequencer", this); //added by me
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
