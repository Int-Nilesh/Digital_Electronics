
// our monitor class
class  apb_monitor extends uvm_monitor;
  `uvm_component_utils ( apb_monitor)
   
   //virtual dut_if   vif; //commentout by me
  virtual apb_if apbif; //added by me
  event mondone;//added by me

   // this event is used to signal from the driver that a drive operation has concluded
   event drvdone;

   // this is the analysis port that is used to send the data to the scoreboard
  uvm_analysis_port #( apb_packet)   mon_analysis_port;
   
   function new (string name, uvm_component parent= null);
      super.new (name, parent);
   endfunction

   virtual function void build_phase (uvm_phase phase);
      super.build_phase (phase);

      //Get virtual interface handle from the configuration DB
     if(!uvm_config_db#(virtual  apb_if)::get(this, "", "apb_if", apbif)) begin  //added by me 
      `uvm_error("", "uvm_config_db::get failed")
    end

      // Create an instance of the analysis port
      mon_analysis_port = new ("mon_analysis_port", this);
     `uvm_info("TEST", $sformatf("MON build Passed"), UVM_MEDIUM);
            
   endfunction

 virtual task run_phase (uvm_phase phase);
   
       apb_packet  data_obj =  apb_packet::type_id::create ("data_obj", this);
      forever begin
	  
	  
	  //you need to 1) wait for the drvdone event, 2) once the driver is done, reconstruct the data_obj packet by reading 
	  // the a,b,cmd, and most importantly the out fields of the interface

        @(drvdone); // added by me
        repeat(1)@(posedge apbif.pclk);
        if(apbif.pready) begin  
        data_obj.psel = apbif.psel;
        data_obj.penable = apbif.penable;
        data_obj.pwdata = apbif.pwdata;
        data_obj.pwrite = apbif.pwrite;
        data_obj.prdata = apbif.prdata;
        data_obj.paddr = apbif.paddr;
        data_obj.pslverr = apbif.pslverr;
        //@(posedge apbif.pclk);
        //mbx.put(t);
        //data_obj.display("MON");
      end
        
	  // after reading the object from the interface print we read its contents
        `uvm_info("MON", $sformatf("Data reading paddr:%0d  pwdata:%0d pwrite:%0b  prdata:%0d pslverr:%0b @ %0t", data_obj.paddr, data_obj.pwdata, data_obj.pwrite, data_obj.prdata, data_obj.pslverr,$time), UVM_MEDIUM);  //added by me 
		
		
       //write data object to the analysis port to the scoreboard
        mon_analysis_port.write(data_obj);  //added by me
        -> mondone; //added by me
       
      end
   endtask

endclass