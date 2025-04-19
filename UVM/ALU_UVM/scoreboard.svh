
// scoreboard object
class salu_scoreboard extends uvm_scoreboard;
	`uvm_component_utils (salu_scoreboard)
	
	function new (string name = "salu_scoreboard", uvm_component parent);
		super.new (name, parent);
	endfunction

	//define analysis port
  uvm_analysis_imp #(salu_packet, salu_scoreboard) ap_imp; // added by me 
	
	function void build_phase (uvm_phase phase);
		ap_imp = new ("ap_imp", this);
      `uvm_info("TEST", $sformatf("SCO build Passed"), UVM_MEDIUM);
	endfunction
	
	// this function gets called when the monitor sends data to the scoreboard. We read the data and perform checks here
	virtual function void write (salu_packet data);
		//write some checks to check whether the data.out result is equal 
      `uvm_info("SCO", $sformatf("read Started a=%0b, b=%0b, cmd=%b out=%0b",data.a, data.b, data.cmd, data.out ), UVM_MEDIUM);
      
      case (data.cmd) //added by me 
        3'b 000: begin
          `uvm_info("SCO", $sformatf("%s", (data.out == (data.a + data.b)) ? "Result matched" : "Result not matched"), UVM_MEDIUM); 
        end
        3'b 001:  begin
          `uvm_info("SCO", $sformatf("%s", (data.out == (data.a - data.b)) ? "Result matched" : "Result not matched"), UVM_MEDIUM); 
        end
        3'b 010:  begin
          `uvm_info("SCO", $sformatf("%s", (data.out == (data.a ^ data.b)) ? "Result matched" : "Result not matched"), UVM_MEDIUM); 
        end 
        3'b 011:  begin
          `uvm_info("SCO", $sformatf("%s", (data.out == ((data.a & data.b))) ? "Result matched" : "Result not matched"), UVM_MEDIUM); 
        end
        3'b 100:  begin
          `uvm_info("SCO", $sformatf("%s", (data.out == (data.a | data.b)) ? "Result matched" : "Result not matched"), UVM_MEDIUM); 
        end
    endcase
		// to the ADD/AND/XOR/XNOR of data.a, and data.b when data.cmd is set to the right command
      `uvm_info ("write", $sformatf("Data received = 0x%0b", data.out), UVM_MEDIUM)
      $display("----------------------------------------------------------------------------------------------------------------");
	endfunction

endclass
