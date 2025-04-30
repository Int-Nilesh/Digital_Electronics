
// our monitor class
class spi_monitor extends uvm_monitor;
  `uvm_component_utils (spi_monitor)
   
   //virtual dut_if   vif; //commentout by me
  virtual spi_dut spi_if; 
  event mondone;

   // this event is used to signal from the driver that a drive operation has concluded
   event drvdone;

   // this is the analysis port that is used to send the data to the scoreboard
  uvm_analysis_port #(spi_packet)   mon_analysis_port;
   
   function new (string name, uvm_component parent= null);
      super.new (name, parent);
   endfunction

   virtual function void build_phase (uvm_phase phase);
      super.build_phase (phase);

      //Get virtual interface handle from the configuration DB
     if(!uvm_config_db#(virtual spi_dut)::get(this, "", "spi_if", spi_if)) begin  //added by me 
      `uvm_error("", "uvm_config_db::get failed")
    end

      // Create an instance of the analysis port
      mon_analysis_port = new ("mon_analysis_port", this);
     `uvm_info("TEST", $sformatf("MON build Passed"), UVM_MEDIUM);
            
   endfunction

 virtual task run_phase (uvm_phase phase);
   
   spi_packet  pkt = spi_packet::type_id::create ("pkt", this);
      forever begin
	  
	  
	  //you need to 1) wait for the drvdone event, 2) once the driver is done, reconstruct the data_obj packet by reading 


        @(drvdone);
        @(posedge spi_if.done);    
        pkt.wr = spi_if.wr;  
        pkt.din = spi_if.din;
        pkt.addr = spi_if.addr;
        pkt.dout = spi_if.dout;
        pkt.done = spi_if.done;
        pkt.err = spi_if.err; 
        
	  // after reading the object from the interface print we read its contents
        `uvm_info ("MON", $sformatf("reading item time: %0t, W/R: %0b | Din: %0d | Addr: %0d | Dout: %0d | Done: %0b | Err: %0b", $time, pkt.wr, pkt.din, pkt.addr, pkt.dout, pkt.done, pkt.err), UVM_MEDIUM);
		
		
       //write data object to the analysis port to the scoreboard
        mon_analysis_port.write(pkt);  
        -> mondone;
       
      end
   endtask

endclass