
// scoreboard object
class apb_scoreboard extends uvm_scoreboard;
  `uvm_component_utils (apb_scoreboard)
  
  bit [7:0] pwdata[256];
  int err =0;
	
  function new (string name = "apb_scoreboard", uvm_component parent);
		super.new (name, parent);
	endfunction

	//define analysis port
  uvm_analysis_imp #(apb_packet, apb_scoreboard) ap_imp; // added by me 
	
	function void build_phase (uvm_phase phase);
		ap_imp = new ("ap_imp", this);
      `uvm_info("TEST", $sformatf("SCO build Passed"), UVM_MEDIUM);
	endfunction
	
	// this function gets called when the monitor sends data to the scoreboard. We read the data and perform checks here
  virtual function void write (apb_packet t);
    `uvm_info("SCO", $sformatf("Data reading paddr:%0d  pwdata:%0d pwrite:%0b  prdata:%0d pslverr:%0b @ %0t", t.paddr, t.pwdata, t.pwrite, t.prdata, t.pslverr,$time), UVM_MEDIUM);
		//write some checks to check whether the data.out result is equal 
      if ((t.pwrite == 1'b 1) && (t.pslverr == 1'b 0)) begin
        pwdata[t.paddr] = t.pwdata;
        `uvm_info("SCO", $sformatf("[SCO] Data stored : %0d at address: %0d", t.pwdata, t.paddr), UVM_MEDIUM);
      end else if ((t.pwrite == 1'b 0) && (t.pslverr == 1'b 0)) begin
        if (pwdata[t.paddr] == t.prdata) begin  
          `uvm_info("SCO", $sformatf(" DATA matched Data: %0d Address: %0d", t.prdata, t.paddr), UVM_MEDIUM);
          end else begin
          err ++;
          `uvm_info("SCO", $sformatf("DATA MISS-MATCHED  Data: %0d Address: %0d", t.prdata, t.paddr), UVM_MEDIUM);
        end
      end else begin
        `uvm_info("SCO", $sformatf("[SCO] SLV Error Dectected"), UVM_MEDIUM);
      end
      //$display("------------------------------------------------------------");
      //-> sconext;
		// to the ADD/AND/XOR/XNOR of data.a, and data.b when data.cmd is set to the right command
      `uvm_info("SCO", $sformatf("Total nNumber of missmatch: %0d", err), UVM_MEDIUM);              
      $display("----------------------------------------------------------------------------------------------------------------");
	endfunction
endclass
