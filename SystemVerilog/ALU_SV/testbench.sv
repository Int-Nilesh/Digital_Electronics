`include "alu.v";

class transaction;
  randc bit [2:0] alu_cmd;
  randc bit [31:0] alu_operand0, alu_operand1;
  bit [31:0] alu_out;
  
  function transaction copy (input transaction t);
    copy = new();
    copy.alu_cmd = this.alu_cmd;
    copy.alu_operand0 = this.alu_operand0;
    copy.alu_operand1 = this.alu_operand1;
    copy.alu_out = this.alu_out;
  endfunction
  
  constraint data_cmd {alu_cmd < 5;}
  constraint data_ab {alu_operand0 inside {[0:16]}; alu_operand1 inside {[0:16]};}
  
  function void display(string path);
    $display("[%s] alu_cmd: %b alu_operand0: %0d alu_operand1: %0d alu_out: %0d", path, alu_cmd, alu_operand0, alu_operand1, alu_out);
  endfunction
  
endclass

interface alu_if;
  logic [2:0]alu_cmd;
  logic [31:0] alu_operand0;
  logic [31:0] alu_operand1;
  logic [31:0] alu_out;
endinterface
  

class generator;
  transaction t;
  mailbox #(transaction) mbx;
  //mailbox #(transaction) mbxref;
  event scnext;
  event done;
  
  function new (input mailbox #(transaction) mbx);
    this.mbx = mbx;
    //this.mbxref = mbxref;
    t = new();
  endfunction
  
  task run();
    for( int i = 0; i <25; i++) begin
      assert(t.randomize()) else
        $display("Randomization is not possible");
      mbx.put(t.copy(t));
      t.display("GEN");
      @(scnext);
    end
    -> done;
  endtask
endclass

class driver;
  transaction t;
  event done;
  mailbox #(transaction) mbx;
  virtual alu_if aif;
  
  function new (mailbox #(transaction) mbx);
    this.mbx = mbx;
  endfunction
  
  task run();
    forever begin
      mbx.get(t);
      t.display("DRV");
      aif.alu_cmd = t.alu_cmd;
      aif.alu_operand0 = t.alu_operand0;
      aif.alu_operand1 = t.alu_operand1;
      #10;
    end
  endtask
endclass

class monitor;
  transaction t;
  virtual alu_if aif;
  mailbox #(transaction) mbx;
  
  function new(mailbox #(transaction) mbx);
    this.mbx = mbx;
  endfunction
  
  task run();
    forever begin
      #10;
      t= new();
      t.alu_cmd = aif.alu_cmd;
      t.alu_operand0 = aif.alu_operand0;
      t.alu_operand1 = aif.alu_operand1;
      t.alu_out = aif.alu_out;
      mbx.put(t);
      t.display("MON");
    end
  endtask
endclass

class scoreboard;
  transaction t;
  mailbox #(transaction) mbx;
  event scnext;
  
  function new (mailbox #(transaction) mbx);
    this.mbx = mbx;
  endfunction
  
  function void check (input transaction t);
     case (t.alu_cmd)
      3'b 000: $display((t.alu_out == (t.alu_operand0 + t.alu_operand1))? "result matched" : "Result not matched"); 
      3'b 001: $display((t.alu_out == (t.alu_operand0 - t.alu_operand1))? "result matched" : "Result not matched");
      3'b 010: $display((t.alu_out == (t.alu_operand0 ^ t.alu_operand1))? "result matched" : "Result not matched");
      3'b 011: $display((t.alu_out == (t.alu_operand0 & t.alu_operand1))? "result matched" : "Result not matched");
      3'b 100: $display((t.alu_out == (t.alu_operand0 | t.alu_operand1))? "result matched" : "Result not matched");
    endcase
  endfunction
  
  task run();
    forever begin
      mbx.get(t);
      t.display("SCO");
      check (t);
      ->scnext;
    end
  endtask
endclass

class enviroment;
  generator gen;
  driver drv;
  monitor mon;
  scoreboard sco;
  
  //event done;
  event scnext;
  
  mailbox #(transaction) gdmbx;
  mailbox #(transaction) msmbx;
  
  virtual alu_if aif;
  
  function new (virtual alu_if aif);
    gdmbx = new();
    msmbx = new();
    
    gen = new (gdmbx);
    drv = new(gdmbx);
    mon = new(msmbx);
    sco = new(msmbx);
    
    gen.scnext = sco.scnext;
    
    this.aif = aif;
    drv.aif = this.aif;
    mon.aif = this.aif;
  endfunction
  
  task run();
    fork
      gen.run();
      drv.run();
      mon.run();
      sco.run();
    join_none
    wait(gen.done.triggered);
    $finish();
  endtask
  
endclass

module alu_tb;
  enviroment env;
  alu_if aif();
  
  alu dut (
    .alu_cmd(aif.alu_cmd), 
    .alu_operand0(aif.alu_operand0), 
    .alu_operand1(aif.alu_operand1), 
    .alu_out(aif.alu_out)
  );
    
  initial begin
    env = new(aif);
    env.run();
  end
  
endmodule
  
  
              
    
    
    
    
    
      
      
  
  
  
    