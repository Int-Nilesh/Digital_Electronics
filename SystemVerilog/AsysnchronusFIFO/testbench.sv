class transaction;
  rand bit rd, wr;
  rand bit [7:0] din;
  bit [7:0] dout;
  bit empty, full;
  
  constraint data { wr == 1 <-> rd == 0;}
  
  function transaction copy (transaction t);
    copy = new();
    copy.rd = this.rd;
    copy.wr = this.wr;
    copy.din = this.din;
    copy.dout = this.dout;
    copy.empty = this.empty;
    copy.full = this.full;
  endfunction
  
  function void display(string tag= "");
    $display("[%0s] WR: %0d RD: %0d Din: %0d Dout: %0d", tag, wr, rd, din, dout);
  endfunction
  
endclass

class generator;
  transaction t;
  mailbox #(transaction) mbx;
  mailbox #(transaction) mbxref;
  event done;
  event next;
  int i = 0;
  int count;
  
  function new(mailbox #(transaction) mbx, mbxref);
    this.mbx = mbx;
    this.mbxref = mbxref;
    t = new();
  endfunction
  
  task run();
    repeat (count) begin
      assert (t.randomize()) else begin
        $display("Randomization is not possible");
      end
      i++;
      mbx.put(t.copy(t));
      mbxref.put(t.copy(t));
      t.display("GEN");
      @(next);
    end
    -> done;
  endtask
endclass

class driver;
  transaction t;
  mailbox #(transaction) mbx;
  virtual fifo_if fif;
  
  function new (mailbox #(transaction) mbx);
    this.mbx = mbx;
  endfunction
  
  task reset();
    fif.rst <= 1'b 1;
    fif.wr <= 0;
    fif.rd <= 0;
    fif.din <= 0;
    fif.dout <= 0;
    repeat (5) @(posedge fif.clk);
    fif.rst <= 0;
    @(posedge fif.clk);
  endtask
  
  task run();
    forever begin
      mbx.get(t);
      if( t.wr) begin
        fif.rst <= 1'b 0;
        fif.wr <= t.wr;
        fif.rd <= t.rd;
        fif.din <= t.din;
        @(posedge fif.clk);
        t.display("DRV WRITE");
        fif.wr <= 1'b 0;
        @(posedge fif.clk);
      end
      if(t.rd) begin
        fif.rst <= 1'b 0;
        fif.wr <= t.wr;
        fif.rd <= t.rd;
        @(posedge fif.clk);
        t.display("DRV READ");
        fif.rd <= 1'b 0;
       @(posedge fif.clk);
      end
    end
  endtask
endclass

class monitor;
  transaction t;
  virtual fifo_if fif;
  mailbox #(transaction) mbx;
  
  function new(mailbox #(transaction) mbx);
    this.mbx = mbx;
  endfunction
  
  task run();
    t = new();
    forever begin
      repeat (3)@(posedge fif.clk);
      t.dout = fif.dout;
      t.full = fif.full;
      t.empty = fif.empty;
      t.wr = fif.wr;
      t.rd = fif.rd;
      t.din = fif.din;
      mbx.put(t);
      t.display("MON");
    end
  endtask
endclass

class scoreboard;
  transaction t;
  transaction tref;
  mailbox #(transaction) mbx;
  mailbox #(transaction) mbxref;
  event next;
  bit [7:0] arr[$];
  int err = 0;
  
  function new(mailbox #(transaction) mbx, mailbox #(transaction) mbxref);
    this.mbx = mbx;
    this.mbxref = mbxref;
  endfunction
  
  task run();
    forever begin
      mbx.get(t);
      mbxref.get(tref);
      t.display("SCO");
      tref.display("SCO");
      
      if (tref.wr) begin
        if (!t.full) begin
          if (t.din == tref.din) begin
            arr.push_front(t.din);
            $display("-----------------------------");
          end else begin
            $display("Data mismatch on write");
            $display("-----------------------------");
            err++;
          end
        end else begin
          $display("FIFO is full during write");
          $display("-----------------------------");
        end
      end 
      else if  (tref.rd) begin
          if (t.dout == arr.pop_back()) begin
            $display("DATA MATCHED");
            $display("-----------------------------");
          end else begin
            $display("DATA NOT MATCHED");
            $display("-----------------------------");
            err++;
          end
        if (t.empty) begin
          $display("FIFO IS EMPTY during read");
          $display("-----------------------------");
        end
      end

      -> next;
    end
  endtask
endclass

class enviroment;
  virtual fifo_if fif;
  generator gen;
  driver drv;
  monitor mon;
  scoreboard sco;
  
  event next;
  event done;
  
  mailbox #(transaction) gdmbx;
  mailbox #(transaction) gsmbx;
  mailbox #(transaction) msmbx;
  
  function new(virtual fifo_if fif);
    gdmbx = new();
    gsmbx = new();
    msmbx = new();
    
    gen = new(gdmbx, gsmbx);
    drv = new(gdmbx);
    mon = new(msmbx);
    sco = new(msmbx, gsmbx);
    
    this.fif = fif;
    
    drv.fif = this.fif;
    mon.fif = this.fif;
    
    
    sco.next = this.next;
    gen.next = this.next;
  endfunction
  
  task pre_test();
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
    @(gen.done.triggered);
    $display("-------------------------------");
    $display("Error count: %0d", sco.err);
    $display("-------------------------------");
    $finish();
  endtask
  
  task run();
    pre_test();
    test();
    post_test();
  endtask
endclass

module fifo_tb;
  fifo_if fif();
  enviroment env;
  
  fifo dut (.fif);
  
  initial begin
    fif.clk = 1'b 0;
  end
  
  always #10 fif.clk = ~fif.clk;
  
  initial begin 
    $dumpfile("dump.vcd");
    $dumpvars;
  end
  
  initial begin
    env = new(fif);
    env.gen.count = 50;
    env.run();
  end
endmodule
  
  
  
      
      
            
            
            
          

      
  
  
  
    
    
    
    
      
      
      
      
      
    
    
  