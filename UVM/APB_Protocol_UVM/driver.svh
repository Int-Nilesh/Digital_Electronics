      
// driver class. gets items from sequencer and drives them into the dut
class apb_driver extends uvm_driver #(apb_packet);

  `uvm_component_utils(apb_driver)
  
  virtual apb_if apbif;
  event drvdone, mondone; //added by me
  apb_packet pkt; /////////Added by me

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    if(!uvm_config_db#(virtual apb_if)::get(this, "", "apb_if", apbif)) begin
      `uvm_error("", "uvm_config_db::get failed");
    end
    `uvm_info("TEST", $sformatf("DRV build Passed"), UVM_MEDIUM);
  endfunction 
  
  task reset();
    apbif.prst <= 0;
    apbif.psel <= 0;
    apbif.penable <= 0;
    apbif.pwdata <= 0;
    apbif.paddr <= 0;
    apbif.pwrite <= 0;
    repeat(5) @(posedge apbif.pclk);
    apbif.prst <= 1'b 1;
    `uvm_info("TEST", $sformatf("Reset is Done"), UVM_MEDIUM);
    $display("-----------------------------------------------------------------------");
  endtask

  task run_phase(uvm_phase phase);
    reset();
    `uvm_info("TEST", $sformatf("DRV run start"), UVM_MEDIUM);
    
    // drive the packet into the dut
    forever begin
	  //call get_next_item() on seq_item_port to get a packet. 2) configure the intreface signals using the packet.
      seq_item_port.get_next_item(pkt); //added by me
      
	  // packet pkt received from the seq_item_port is printed here
      `uvm_info("DRV", $sformatf("Data Writing paddr:%0d  pwdata:%0d pwrite:%0b  prdata:%0d pslverr:%0b @ %0t", pkt.paddr, pkt.pwdata, pkt.pwrite, pkt.prdata, pkt.pslverr,$time), UVM_MEDIUM);


	  
	  //configure the intreface signals using the packet. This involves place
	  // the values of a and b onto the interface and then toggling the clock.
      if ( pkt.pwrite) begin 
        @(posedge apbif.pclk);
        apbif.psel <= 1;
        apbif.penable <= 0;
        apbif.pwdata <= pkt.pwdata;
        apbif.paddr <= pkt.paddr;
        apbif.pwrite <= 1;
        @(posedge apbif.pclk);
        apbif.penable <= 1;
        -> drvdone;
        @(posedge apbif.pclk);
        //-> drvdone;
        apbif.psel <= 0;
        apbif.penable <= 0;
        apbif.pwrite <= 0;
        //t.display("DRV");
        //-> drvnext;
      end else begin
        apbif.psel <= 1;
        apbif.penable <= 0;
        apbif.pwdata <= 0;
        apbif.paddr <= pkt.paddr;
        apbif.pwrite <= 0;
        @(posedge apbif.pclk);
        apbif.penable <= 1;
        -> drvdone;
        @(posedge apbif.pclk);
        //->drvdone;
        apbif.psel <= 0;
        apbif.penable <= 0;
        apbif.pwrite <= 0;
        //t.display("DRV");
        //-> drvnext;
      end 
  
	  
	  //call item_done() on the seq_item_port to let the sequencer know you are ready for the next item.
      seq_item_port.item_done(); //added by me
      
	  
	  //communicate to the monitor to let it know the signals have been written and the output is ready to received (use drvdone event)
      //repeat(2)@(posedge apbif.pclk); //added by me 
      //`uvm_info ("write", $sformatf("DRV driving item time: %0t, a=%0b, b=%0b, cmd=%b", $time, pkt.a, pkt.b, pkt.cmd), UVM_MEDIUM) //added by me 
      //->drvdone; //added by me
	  //wait to make sure that monitor is done reading the output before loading the next item into the dut (you may create a new event, or simply wait some time)
      @(mondone); //added by me

    end
  endtask

endclass: apb_driver
