
// our monitor class
class salu_monitor extends uvm_monitor;
   `uvm_component_utils (salu_monitor)
   
   //virtual dut_if   vif; //commentout by me
  virtual salu_dut dut_vif; //added by me
  event mondone;//added by me

   // this event is used to signal from the driver that a drive operation has concluded
   event drvdone;

   // this is the analysis port that is used to send the data to the scoreboard
   uvm_analysis_port #(salu_packet)   mon_analysis_port;
   
   function new (string name, uvm_component parent= null);
      super.new (name, parent);
   endfunction

   virtual function void build_phase (uvm_phase phase);
      super.build_phase (phase);

      //Get virtual interface handle from the configuration DB
     if(!uvm_config_db#(virtual salu_dut)::get(this, "", "dut_vif", dut_vif)) begin  //added by me 
      `uvm_error("", "uvm_config_db::get failed")
    end

      // Create an instance of the analysis port
      mon_analysis_port = new ("mon_analysis_port", this);
     `uvm_info("TEST", $sformatf("MON build Passed"), UVM_MEDIUM);
            
   endfunction

 virtual task run_phase (uvm_phase phase);
   
      salu_packet  data_obj = salu_packet::type_id::create ("data_obj", this);
      forever begin
	  
	  
	  //you need to 1) wait for the drvdone event, 2) once the driver is done, reconstruct the data_obj packet by reading 
	  // the a,b,cmd, and most importantly the out fields of the interface

        @(drvdone); // added by me
        repeat(2)@(posedge dut_vif.clock); //added by me 
        data_obj.a = dut_vif.a;  //added by me 
        data_obj.b = dut_vif.b;  //added by me 
        data_obj.cmd = dut_vif.cmd;  //added by me 
        data_obj.out = dut_vif.out; //added by me 
        
	  // after reading the object from the interface print we read its contents
        `uvm_info ("READ", $sformatf("MON reading item a=%0b, b=%0b, cmd=%0b, OUT=%0b", data_obj.a, data_obj.b, data_obj.cmd, data_obj.out), UVM_MEDIUM)  //added by me 
		
		
       //write data object to the analysis port to the scoreboard
        mon_analysis_port.write(data_obj);  //added by me
        -> mondone; //added by me
       
      end
   endtask

endclass