
class spi_packet extends uvm_sequence_item;

  `uvm_object_utils(spi_packet);
  
  randc bit wr;
  randc bit [7:0] din;
  randc bit [7:0] addr;
  bit done;
  bit err;
  bit [7:0]dout;
  static int count = 0;


  //write some constraints to keep the addr small range (say 0 to 35)
  
  constraint data{addr <= 35;}
  constraint cmd {if (count <20) wr == 1; }
  //if your simulator does not support randomize() (such as ModelSim/QuestaSim) use the 
  // $urandom_range functions in the sequence body (seen bellow) to randomize your data in the range 0 to 20.

  function new (string name = "");
    super.new(name);
  endfunction
  
  function void post_randomize();
    count = count + 1;
  endfunction

  endclass: spi_packet

class spi_sequence extends uvm_sequence#(spi_packet);

  `uvm_object_utils(spi_sequence)
  
  spi_packet pkt; 
  int count = 0;

  function new (string name = "");
    super.new(name);
  endfunction

  task body;
	// body of the sequence. Where you must generate 5 random patterns for each of the 5 commands
    `uvm_info ("BASE_SEQ", $sformatf ("Generating sequence"), UVM_MEDIUM); 
    //pkt = salu_packet::type_id::create("pkt", this); 
    
    for (int i = 0; i < count; i++) begin
       pkt = spi_packet::type_id::create("pkt");
		  //you need to 1) create a transaction packet object, 2) randomize its fields, 
		  // you will need to call start_item() and finish_item() on your transaction object 
		  // before and after randomization/configuration respectively;
		  // you should use the i variable to configure the cmd field. Remember only a and b are randomized.
          
          start_item(pkt); 
          assert(pkt.randomize());
          finish_item(pkt); 
	end
  endtask: body

endclass: spi_sequence
