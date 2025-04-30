
`include "agent.svh"
`include "scoreboard.svh"

// our environment class
class spi_env extends uvm_env;
  `uvm_component_utils(spi_env)

  //instantiate the environment's constituents (scoreboard and monitor)
  spi_agent agent; 
  spi_scoreboard sco; 

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
   //initialize the environment's constituents
    agent = spi_agent::type_id::create("agent", this); 
    sco = spi_scoreboard::type_id::create("sco", this); 
    `uvm_info("TEST", $sformatf("ENV build Passed"), UVM_MEDIUM); 
  endfunction
  
  function void connect_phase(uvm_phase phase);
    //connect the agent and the monitor's analysis_port to each other using the .connect function.
    agent.mon.mon_analysis_port.connect(sco.ap_imp);
    `uvm_info("TEST", $sformatf("ENV connect Passed"), UVM_MEDIUM); 
   
  endfunction

endclass