      
// driver class. gets items from sequencer and drives them into the dut
class spi_driver extends uvm_driver #(spi_packet);

  `uvm_component_utils(spi_driver)
  
  virtual spi_dut spi_if;
  event drvdone, mondone; 
  spi_packet pkt; 

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    if(!uvm_config_db#(virtual spi_dut)::get(this, "", "spi_if", spi_if)) begin
      `uvm_error("", "uvm_config_db::get failed");
    end
    `uvm_info("TEST", $sformatf("DRV build Passed"), UVM_MEDIUM);
  endfunction 
  
  task reset();
    spi_if.rst <= 0;
    spi_if.addr     <= 'h0;
    spi_if.din      <= 'h0;
    spi_if.wr       <= 1'b0; 
   `uvm_info("DRV", "System Reset : Start of Simulation", UVM_MEDIUM);
    repeat(5) @(posedge spi_if.clk);
  endtask

  task run_phase(uvm_phase phase);
    `uvm_info("TEST", $sformatf("DRV run start"), UVM_MEDIUM);
    reset();
    $display("------------------- Reset Done --------------------------------");
    // drive the packet into the dut
    forever begin
	  //call get_next_item() on seq_item_port to get a packet. 2) configure the intreface signals using the packet.
      seq_item_port.get_next_item(pkt);
      
	  // packet pkt received from the seq_item_port is printed here
      `uvm_info ("DRV", $sformatf("driving item time: %0t, W/R: %0b | Din: %0d | Addr: %0d | Dout: %0d | Done: %0b | Err: %0b", $time, pkt.wr, pkt.din, pkt.addr, pkt.dout, pkt.done, pkt.err), UVM_MEDIUM);

	  //configure the intreface signals using the packet. This involves place
	  // the values of a and b onto the interface and then toggling the clock.
      if(pkt.wr == 1'b 1 && pkt.err < 32) begin
        @(posedge spi_if.clk);
        spi_if.rst <= 1'b 1;
        spi_if.wr <= pkt.wr;
        spi_if.din <= pkt.din;
        spi_if.addr <= pkt.addr;
        spi_if.dout <= pkt.dout;
        spi_if.done <= pkt.done;
        spi_if.err <= pkt.err;
        @(posedge spi_if.clk);
      end
      else if (pkt.wr == 1'b 0 && pkt.err < 32) begin
        @(posedge spi_if.clk);
        spi_if.rst <= 1'b 1;
        spi_if.wr <= pkt.wr;
        spi_if.din <= pkt.din;
        spi_if.addr <= pkt.addr;
        spi_if.dout <= pkt.dout;
        spi_if.done <= pkt.done;
        spi_if.err <= pkt.err;
        @(posedge spi_if.clk);
      end
      else begin
        @(posedge spi_if.clk);
        spi_if.rst <= 1'b 1;
        spi_if.wr <= pkt.wr;
        spi_if.din <= pkt.din;
        spi_if.addr <= pkt.addr;
        spi_if.dout <= pkt.dout;
        spi_if.done <= pkt.done;
        spi_if.err <= pkt.err;
        @(posedge spi_if.clk);
      end
      
	  //call item_done() on the seq_item_port to let the sequencer know you are ready for the next item.
      seq_item_port.item_done();
      
	  
	  //communicate to the monitor to let it know the signals have been written and the output is ready to received (use drvdone event)
      //repeat(2)@(posedge spi_if.clk); /
      //`uvm_info ("write", $sformatf("DRV driving item time: %0t, a=%0b, b=%0b, cmd=%b", $time, pkt.a, pkt.b, pkt.cmd), UVM_MEDIUM)  
      ->drvdone; 
	  //wait to make sure that monitor is done reading the output before loading the next item into the dut (you may create a new event, or simply wait some time)
      @(mondone); 

    end
  endtask

endclass

