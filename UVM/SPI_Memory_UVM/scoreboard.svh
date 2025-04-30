
// scoreboard object
class spi_scoreboard extends uvm_scoreboard;
  `uvm_component_utils (spi_scoreboard);
  
  reg [7:0]mem[31:0] = '{default: 8'b 0};
	
  function new (string name = "spi_scoreboard", uvm_component parent);
		super.new (name, parent);
	endfunction

	//define analysis port
  uvm_analysis_imp #(spi_packet, spi_scoreboard) ap_imp;
	
	function void build_phase (uvm_phase phase);
		ap_imp = new ("ap_imp", this);
      `uvm_info("TEST", $sformatf("SCO build Passed"), UVM_MEDIUM);
	endfunction
	
	// this function gets called when the monitor sends data to the scoreboard. We read the data and perform checks here
  virtual function void write (spi_packet pkt);
    `uvm_info ("SCO", $sformatf("Recived item time: %0t, W/R: %0b | Din: %0d | Addr: %0d | Dout: %0d | Done: %0b | Err: %0b", $time, pkt.wr, pkt.din, pkt.addr, pkt.dout, pkt.done, pkt.err), UVM_MEDIUM);
    if( (pkt.wr == 1'b 1) && (!(pkt.err == 1'b 1))) begin
      mem[pkt.addr] = pkt.din;
      `uvm_info ("SCO", $sformatf("Data Stored: %0t, Din: %0d | Addr: %0d | Err: %0b", $time, pkt.din, pkt.addr,  pkt.err), UVM_MEDIUM);
      $display("-------------------------  Data Stored  --------------------------------");
    end 
    else if ( (pkt.wr == 1'b 0) && (!(pkt.err == 1'b 1))) begin
      if (mem[pkt.addr] == pkt.dout) begin
        $display("***************************Data Macthed**************************");
      end
      else
        $display("XXXXXXXXXXXXXXXXXXXXXXXXXX  Data Not Macthed XXXXXXXXXXXXXXXXXXXXXXXXXXX");
    end
    else 
      $display("XXXXXXXXXXXXXXXXXXXXXXXXXX  Address Invalid XXXXXXXXXXXXXXXXXXXXXXXXXXX");
    
	endfunction

endclass
