
`include "agent.svh"
`include "scoreboard.svh"

// our environment class
class apb_env extends uvm_env;
  `uvm_component_utils(apb_env);

  //instantiate the environment's constituents (scoreboard and monitor)
  apb_agent agent; //added by me
  apb_scoreboard sco; //added by me

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
   //initialize the environment's constituents
    agent = apb_agent::type_id::create("agent", this); //added by me
    sco = apb_scoreboard::type_id::create("sco", this); //added by me
    `uvm_info("TEST", $sformatf("ENV build Passed"), UVM_MEDIUM); //added by me
  endfunction
  
  function void connect_phase(uvm_phase phase);
    //connect the agent and the monitor's analysis_port to each other using the .connect function.
    agent.mon.mon_analysis_port.connect(sco.ap_imp); // aaded by me
    `uvm_info("TEST", $sformatf("ENV connect Passed"), UVM_MEDIUM); //added by me
   
  endfunction

endclass