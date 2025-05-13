
class apb_packet extends uvm_sequence_item;

  `uvm_object_utils(apb_packet);

  randc bit psel;
  randc bit [7:0] paddr;
  rand bit [7:0] pwdata;
  randc bit penable;
  randc bit pwrite;
  bit [7:0] prdata; 
  bit pready;
  bit   pslverr;
  static int rand_count = 0;
 
  constraint data { //paddr inside {[0:255]};
    pwdata dist{[0:31] :/13, [32:63] :/ 13,
                [64:95] :/13,[96:127] :/13,
                [128:159] :/13, [160:191] :/13,
                [192:223] :/13, [224:255] :/13};
               }
  constraint write { if (rand_count <200) pwrite == 1;
                   else
                   	pwrite == 0;}
  
  //if your simulator does not support randomize() (such as ModelSim/QuestaSim) use the 
  // $urandom_range functions in the sequence body (seen bellow) to randomize your data in the range 0 to 20.

  function new (string name = "");
    super.new(name);
  endfunction
  
  
  function void post_randomize();
    rand_count ++;
    $display("Itteration: %0d", rand_count);
  endfunction
                              

endclass: apb_packet

class apb_sequence extends uvm_sequence#(apb_packet);

  `uvm_object_utils(apb_sequence);
  
  apb_packet pkt; //added by me 
  int count = 0;

  function new (string name = "");
    super.new(name);
  endfunction

  task body;
	// body of the sequence. Where you must generate 5 random patterns for each of the 5 commands
    `uvm_info ("BASE_SEQ", $sformatf ("Generating sequence"), UVM_MEDIUM); // added by me
     // added by me
     
    

    repeat(count) begin

		  //you need to 1) create a transaction packet object, 2) randomize its fields, 
		  // you will need to call start_item() and finish_item() on your transaction object 
		  // before and after randomization/configuration respectively;
		  // you should use the i variable to configure the cmd field. Remember only a and b are randomized
      pkt = apb_packet::type_id::create("pkt");

      start_item(pkt); // added by me 
      assert(pkt.randomize()); // added by me 
      finish_item(pkt); // added by me 
	end
  endtask: body

endclass: apb_sequence
