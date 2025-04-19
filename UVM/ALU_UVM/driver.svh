      
// driver class. gets items from sequencer and drives them into the dut
class salu_driver extends uvm_driver #(salu_packet);

  `uvm_component_utils(salu_driver)
  
  virtual salu_dut dut_vif;
  event drvdone, mondone; //added by me
  salu_packet pkt; /////////Added by me

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    if(!uvm_config_db#(virtual salu_dut)::get(this, "", "dut_vif", dut_vif)) begin
      `uvm_error("", "uvm_config_db::get failed");
    end
    `uvm_info("TEST", $sformatf("DRV build Passed"), UVM_MEDIUM);
  endfunction 

  task run_phase(uvm_phase phase);
    `uvm_info("TEST", $sformatf("DRV run start"), UVM_MEDIUM);

    
    // drive the packet into the dut
    forever begin
	  //call get_next_item() on seq_item_port to get a packet. 2) configure the intreface signals using the packet.
      seq_item_port.get_next_item(pkt); //added by me
      
	  // packet pkt received from the seq_item_port is printed here


	  
	  //configure the intreface signals using the packet. This involves place
	  // the values of a and b onto the interface and then toggling the clock.
      dut_vif.a <= pkt.a;//added by me
      dut_vif.b <= pkt.b;//added by me
      dut_vif.cmd <= pkt.cmd;//added by me
  
	  
	  //call item_done() on the seq_item_port to let the sequencer know you are ready for the next item.
      seq_item_port.item_done();//added by me
      
	  
	  //communicate to the monitor to let it know the signals have been written and the output is ready to received (use drvdone event)
      repeat(2)@(posedge dut_vif.clock); //added by me 
      `uvm_info ("write", $sformatf("DRV driving item time: %0t, a=%0b, b=%0b, cmd=%b", $time, pkt.a, pkt.b, pkt.cmd), UVM_MEDIUM) //added by me 
      ->drvdone; //added by me
	  //wait to make sure that monitor is done reading the output before loading the next item into the dut (you may create a new event, or simply wait some time)
      @(mondone); //added by me

    end
  endtask

endclass: salu_driver
