class transaction;
  randc bit [3:0] a,b;
  bit [4:0] sum;
  bit clk;
  
  constraint data {a <15; b >5;}
  
  function transaction copy();
    copy = new();
    copy.a = this.a;
    copy.b = this.b;
    copy. sum = sum;
    copy. clk = clk;
  endfunction
  
  function void display(input string tag);
    $display("[%0s] a: %0d \t b: %0d", tag, a, b);
  endfunction
endclass

interface add_if;
  logic [3:0] a, b;
  logic [4:0] sum;
  logic clk;
  
  modport DRV (output a, b, input sum, input clk);
  //modport MON ( input a, b, sum, clk);
endinterface

class generator;
  transaction t;
  mailbox #(transaction) mbx;
  mailbox #(transaction) mbxref;
  event done;
  event sconext;
  
  function new (mailbox #(transaction) mbx, mailbox #(transaction) mbxref);
    this.mbx = mbx;
    this.mbxref = mbxref;
    t = new();
  endfunction
  int count;
  
  task run();
    for ( int i = 0; i < count; i ++) begin
      assert ( t.randomize()) else begin
        $display("Randomization failed");
      end
      mbx.put(t.copy());
      mbxref.put(t.copy);
      t.display("GEN");
      @(sconext);
    end
    -> done;
  endtask
endclass

class driver;
  virtual add_if.DRV aif;
  mailbox #(transaction) mbx;
  transaction t;
  
  function new(mailbox #(transaction) mbx);
    this.mbx = mbx;
  endfunction
  
  task run();
    forever begin
      mbx.get(t);
      aif.a <= t.a;
      aif.b <= t.b;
      t.display("DRV");
      @(posedge aif.clk);
    end
  endtask 
endclass

class monitor;
  virtual add_if aif;
  mailbox #(transaction) mbx;
  transaction t;
  
  function new(mailbox #(transaction) mbx);
    this.mbx = mbx;
  endfunction
  
  task run();
    t = new();
    forever begin
      repeat(2)@(posedge aif.clk);
      t.a = aif.a;
      t.b = aif.b;
      t.sum = aif.sum;
      mbx.put(t);
      t.display ("MON");
    end
  endtask
endclass

class scoreboard;
  mailbox #(transaction) mbx;
  mailbox #(transaction) mbxref;
  transaction t;
  transaction tref;
  event sconext;
  
  function new (mailbox #(transaction) mbx,  mailbox #(transaction) mbxref);
    this.mbx = mbx;
    this.mbxref = mbxref;
  endfunction
  function void compare ( input transaction t, tref);
    if (t.sum == (tref.a + tref.b)) begin
      $display("Result Matched sum: %0d", t.sum);
    end
    else begin
      $display("Result dont matched sum: %0d", t.sum);
    end
  endfunction
  
  task run();
    forever begin
      //@(posedge aif.clk)
      mbx.get(t);
      mbxref.get(tref);
      t.display ("SCO");
      tref.display ("REF");
      compare(t, tref);
      ->sconext;
    end
  endtask
endclass


class enviroment;
  generator gen;
  driver drv;
  monitor mon;
  scoreboard sco;
  event done;
  event sconext;
  mailbox #(transaction) gdmbx;
  mailbox #(transaction) msmbx;
  mailbox #(transaction) mbxref;
  
  virtual add_if aif;
  
  function new (virtual add_if aif);
    gdmbx = new();
    msmbx = new();
    mbxref = new();
    
    gen = new( gdmbx, mbxref);
    drv = new(gdmbx);
    mon = new(msmbx);
    sco = new( msmbx, mbxref);
    
    this.aif = aif;
    drv.aif = this.aif;
    mon.aif = this.aif;
    
    gen.sconext = sconext;
    sco.sconext = sconext;
    gen.done = done;
  endfunction
  
  task run();
    fork
      gen.run();
      drv.run();
      mon.run();
      sco.run();
    join_none
    @(done);
    $finish();
  endtask
endclass
     
  
module add_tb;
  //transaction t;
  add_if aif();
  event done;
  enviroment env;
  
  add dut (.a(aif.a), .b(aif.b), .sum(aif.sum), .clk(aif.clk));
  
  initial begin
    aif.clk = 0;
  end
  
  always #10 aif.clk = ~ aif.clk;
  
  initial begin
    $dumpfile("dump.vcd");
    $dumpvars;
  end
  
  initial begin
    env = new(aif);
    env.gen.count = 10;
    env.run();
  end
  
endmodule
      

    
    