
class salu_packet extends uvm_sequence_item;

  `uvm_object_utils(salu_packet)

  parameter cmd_width = 3;
  parameter data_width = 16;

  logic[cmd_width-1:0] cmd;
  rand logic[data_width-1:0] a;
  rand logic[data_width-1:0] b;
  logic[data_width-1:0] out;

  //write some constraints to keep the a and b in a small range (say 0 to 20)
  
  constraint data { a inside{[0 : 20]}; 
                   b inside{[0 : 20]};} // added by me
  //if your simulator does not support randomize() (such as ModelSim/QuestaSim) use the 
  // $urandom_range functions in the sequence body (seen bellow) to randomize your data in the range 0 to 20.

  function new (string name = "");
    super.new(name);
  endfunction

endclass: salu_packet

class salu_sequence extends uvm_sequence#(salu_packet);

  `uvm_object_utils(salu_sequence)
  
  salu_packet pkt; //added by me 

  function new (string name = "");
    super.new(name);
  endfunction

  task body;
	// body of the sequence. Where you must generate 5 random patterns for each of the 5 commands
    `uvm_info ("BASE_SEQ", $sformatf ("Generating sequence"), UVM_MEDIUM); // added by me
    //pkt = salu_packet::type_id::create("pkt", this); // added by me
    
	for (int i = 0; i < 5; i++) begin
       pkt = salu_packet::type_id::create("pkt");
       pkt.cmd = i;
       
		repeat(5) begin

		  //you need to 1) create a transaction packet object, 2) randomize its fields, 
		  // you will need to call start_item() and finish_item() on your transaction object 
		  // before and after randomization/configuration respectively;
		  // you should use the i variable to configure the cmd field. Remember only a and b are randomized.
          
          start_item(pkt); // added by me 
          assert(pkt.randomize()); // added by me 
          finish_item(pkt); // added by me 
		end
	end
  endtask: body

endclass: salu_sequence
