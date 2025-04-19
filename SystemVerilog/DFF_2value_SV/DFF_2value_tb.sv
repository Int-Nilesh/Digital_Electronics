class transaction;
  rand bit d;
  bit rst;
  bit q;
  bit clk;
  
  function transaction copy( input transaction t);
    copy = new();
    copy.d = this.d;
    copy.rst = this.rst;
    copy.clk = this.clk;
    copy.q = this.q;
  endfunction
  
  function void display (input string tag);
    $display("[%0s] D: %0d \t Q: %0d", tag, d, q);
  endfunction
  
endclass

class generator;
  transaction t;
  mailbox #(transaction) mbx;
  mailbox #(transaction) mbxref;
  event done;
  event sconext;
  int count;
  
  function new(mailbox #(transaction) mbx, mbxref);
    this.mbx = mbx;
    this.mbxref = mbxref;
    t = new();
  endfunction
  
  task run();
    repeat(count) begin
      assert( t.randomize()) else begin
      $display("Randomiztion Failed");
      end
      mbx.put(t.copy(t));
      mbxref.put ( t.copy(t));
      t.display("GEN");
      @(sconext);
    end
    -> done;
  endtask
  
endclass

class driver;
  virtual dff_if dif;
  mailbox #(transaction) mbx;
  transaction t;
  
  function new( mailbox #(transaction) mbx);
    this.mbx = mbx;
  endfunction
  
  task reset();
    dif.rst <= 1'b 1;
    repeat (5) @(posedge dif.clk);
    dif.rst <= 1'b 0;
    @(posedge dif.clk);
    $display("[DRV] Reset Done");
  endtask
  
  task run();
    forever begin
      mbx.get(t);
      dif.d <= t.d;
      @(posedge dif.clk);
      t.display("DRV");
      dif.d <= 1'b 0;
      @(posedge dif.clk);
    end
  endtask 
endclass

class monitor;
  transaction t;
  mailbox #(transaction) mbx;
  virtual dff_if dif;
  
  function new(mailbox #(transaction) mbx);
    this.mbx = mbx;
  endfunction
  
  task run();
    t = new();
    forever begin
      repeat (2) @(posedge dif.clk);
      t.q = dif.q;
      mbx.put(t);
      t.display("MON");
    end
  endtask
endclass

class scoreboard;
  transaction t, tref;
  mailbox #(transaction) mbx, mbxref;
  event sconext;
  
  function new(mailbox #(transaction) mbx, mbxref);
    this.mbx = mbx;
    this.mbxref = mbxref;
  endfunction
  
  task run();
    forever begin
      mbx.get(t);
      t.display("SCO");
      mbxref.get(tref);
      tref.display("SCO");
      if( t.q == tref.d) begin
        $display("Result Matched");
      end else
        $display("Result Dont Matched");
      $display("-------------------------------------");
      -> sconext;
    end
  endtask
endclass

class environment;
  generator gen;
  driver drv;
  monitor mon;
  scoreboard sco;
  event done;
  event sconext;
  
  virtual dff_if dif;
  
  mailbox #(transaction) gdmbx;
  mailbox #(transaction) gsmbx;
  mailbox #(transaction) msmbx;
  
  function new(virtual dff_if dif);
    gdmbx = new();
    gsmbx = new();
    msmbx = new();
    
    gen = new( gdmbx, gsmbx);
    drv = new(gdmbx);
    mon = new(msmbx);
    sco = new( msmbx, gsmbx);
    
    gen.sconext = sconext;
    sco.sconext = sconext;
    
    this.dif = dif;
    drv.dif = this.dif;
    mon.dif = this.dif;
    
  endfunction
  
  task reset();
    drv.reset();
  endtask
  
  task test();
    fork
      gen.run();
      drv.run();
      mon.run();
      sco.run();
    join_none
  endtask
  
  task post_test();
    @(gen.done);
    $finish();
  endtask
  
  task run();
    reset();
    test();
    post_test();
  endtask
endclass

module dff_tb;
  environment env;
  
  dff_if dif();
  
  dff dut (.dif);
  
  initial begin
    dif.clk <= 1'b 0;
  end
  
  always #10 dif.clk <= ~dif.clk;
  
  initial begin
    $dumpfile("dump.vcd");
    $dumpvars;
  end
  
  initial begin
    env = new(dif);
    env.gen.count = 10;
    env.run();
  end
endmodule
  
  
        
     
    
    


      
  
  
  
  

    
    
  
  



