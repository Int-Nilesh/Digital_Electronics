//`include "sequencer.svh"

class apb_coverage extends uvm_subscriber#(apb_packet);
  `uvm_component_utils(apb_coverage);
  
  uvm_analysis_imp #(apb_packet, apb_coverage) apb_cover_imp;
  apb_packet pkt;
	
  
  function void build_phase (uvm_phase phase);
    super.build_phase(phase);
    apb_cover_imp = new ("apb_cover_imp", this);
    `uvm_info("TEST", $sformatf("COVER build Passed"), UVM_MEDIUM);
  endfunction

  
  covergroup check;
    option.per_instance = 1;
    option.name = "cover_addr_data";
    option.goal = 80;
    //option.at_least = 8;
    option.auto_bin_max = 8;
    coverpoint pkt.paddr{
      option.at_least = 50;
    
    }
    coverpoint pkt.pwdata{
     option.at_least = 8;
    }
    coverpoint pkt.prdata{
      option.at_least = 8;
    }
    coverpoint pkt.pwrite{
    option.at_least = 200;
    }
    
  endgroup
  
  
  
  //cg_bus cover1;
  
  //function void build_phase(uvm_phase phase);
   // cover1 = new();
  //endfunction
    
    
  function new (string name = "apb_coverage", uvm_component parent);
    super.new(name, parent);
    check = new();
  endfunction
  
  virtual function void write (apb_packet t); // write method automatically gets called when monitor pushes data in analysis port 
	pkt = t;
    //`uvm_info("TEST", $sformatf("Inside Cover write"), UVM_MEDIUM);
    check.sample();
  endfunction
  
endclass
  