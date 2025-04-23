class transaction;
  randc bit psel;
  randc bit [31:0] paddr;
  randc bit [7:0] pwdata;
  randc bit penable;
  randc bit pwrite;
  bit [7:0] prdata; 
  bit pready;
  bit   pslverr;
 
  constraint data { paddr inside {[0:15]};
                   pwdata inside {[0 : 255]};
                  }
  
  function void display( input string tag);
    $display("[%0s] :  paddr:%0d  pwdata:%0d pwrite:%0b  prdata:%0d pslverr:%0b @ %0t",tag,paddr,pwdata, pwrite, prdata, pslverr,$time);
  endfunction
  
endclass

class generator;
  transaction t;
  mailbox #(transaction) mbx;
  
  event sconext; // scoreboard is done with corrent data checks
  event drvnext; // driver is done with current data write to dut
  event done; // operation is done
  
  int count = 0;
  
  function new(mailbox#(transaction) mbx);
    this.mbx = mbx;
    t = new();
  endfunction
  
  task run();
    repeat (count) begin
      assert(t.randomize()) else $error("randomization failed");
      mbx.put(t);
      t.display("GEN");
      @(drvnext);
      @(sconext);
    end
    -> done;
  endtask
endclass

class driver;
  transaction t;
  mailbox #(transaction) mbx;
  virtual apb_if apbif;
  event drvnext;
  
  function new(mailbox #(transaction) mbx);
    this.mbx = mbx;
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
    $display("[DRV]: Reset is done");
    $display("-----------------------------------------------------------------------");
  endtask
  
  task run();
    forever begin
      mbx.get(t);
      if ( t.pwrite) begin 
        @(posedge apbif.pclk);
        apbif.psel <= 1;
        apbif.penable <= 0;
        apbif.pwdata <= t.pwdata;
        apbif.paddr <= t.paddr;
        apbif.pwrite <= 1;
        @(posedge apbif.pclk);
        apbif.penable <= 1;
        @(posedge apbif.pclk);
        apbif.psel <= 0;
        apbif.penable <= 0;
        apbif.pwrite <= 0;
        t.display("DRV");
        -> drvnext;
      end else begin
        apbif.psel <= 1;
        apbif.penable <= 0;
        apbif.pwdata <= 0;
        apbif.paddr <= t.paddr;
        apbif.pwrite <= 0;
        @(posedge apbif.pclk);
        apbif.penable <= 1;
        @(posedge apbif.pclk);
        apbif.psel <= 0;
        apbif.penable <= 0;
        apbif.pwrite <= 0;
        t.display("DRV");
        -> drvnext;
      end 
    end
  endtask
endclass 

class monitor;
  transaction t;
  mailbox #(transaction) mbx;
  virtual apb_if apbif;
  
  function new (mailbox #(transaction) mbx);
    this.mbx = mbx;
  endfunction
  
  task run();
    t = new();
    forever begin
      @(posedge apbif.pclk);
      if(apbif.pready) begin  
        t.psel = apbif.psel;
        t.penable = apbif.penable;
        t.pwdata = apbif.pwdata;
        t.pwrite = apbif.pwrite;
        t.prdata = apbif.prdata;
        t.paddr = apbif.paddr;
        t.pslverr = apbif.pslverr;
        @(posedge apbif.pclk);
        mbx.put(t);
        t.display("MON");
      end
    end
  endtask
endclass

class scoreboard;
  transaction t;
  mailbox #(transaction) mbx;
  event sconext;
  bit [7:0] pwdata[16];
  int err =0;
  
  
  function new(mailbox#(transaction) mbx);
    this.mbx = mbx;
  endfunction
  
  task run();
    forever begin
      mbx.get(t);
      t.display("SCO");
      if ((t.pwrite == 1'b 1) && (t.pslverr == 1'b 0)) begin
        pwdata[t.paddr] = t.pwdata;
        $display("[SCO] Data stored : %0d at address: %0d", t.pwdata, t.paddr);
      end else if ((t.pwrite == 1'b 0) && (t.pslverr == 1'b 0)) begin
        if (pwdata[t.paddr] == t.prdata) 
          $display("[SCO] DATA MATCHED Data: %0d Address: %0d", t.prdata, t.paddr);
        else begin
          err ++;
          $display("DATA MISS-MATCHED  Data: %0d Address: %0d", t.prdata, t.paddr);
        end
      end else begin
        $display("[SCO] SLV Error Dectected");
      end
      $display("------------------------------------------------------------");
      -> sconext;
    end
  endtask
endclass

class enviroment;
  generator gen;
  driver drv;
  monitor mon;
  scoreboard sco;
  
  event drvnext, sconext, done;
  
  mailbox #(transaction) gdmbx;
  mailbox #(transaction) msmbx;
  
  virtual apb_if apbif;
  
  function new (virtual apb_if apbif);
    gdmbx = new();
    msmbx = new();
    
    gen = new(gdmbx);
    drv = new(gdmbx);
    mon = new(msmbx);
    sco = new(msmbx);
    
    this.apbif = apbif;
    drv.apbif = this.apbif;
    mon.apbif = this.apbif;
    
    gen.sconext = sconext;
    sco.sconext = sconext;
    
    gen.drvnext = drvnext;
    drv.drvnext = drvnext;
  endfunction
  
  task pretest();
    drv.reset();
  endtask
  
  task test();
    fork
      gen.run();
      drv.run();
      mon.run();
      sco.run();
    join_any
  endtask
  

  
  task post_test();
    wait( gen.done.triggered);
    $display("Total nNumber of missmatch: %0d", sco.err);
    $finish();
  endtask
  
  task run();
    pretest();
    test();
    post_test();
  endtask
endclass

module apb_tb;
  apb_if apbif();
  
  enviroment env;
  
  apb dut (
    .pclk(apbif.pclk),
    .prst(apbif.prst),
    .paddr(apbif.paddr),
    .psel(apbif.psel),
    .penable(apbif.penable),
    .pwdata(apbif.pwdata),
    .pwrite(apbif.pwrite),
    .prdata(apbif.prdata),
    .pready(apbif.pready),
    .pslverr(apbif.pslverr)
  );
  
  initial begin
    env = new(apbif);
    apbif.pclk = 0;
    env.gen.count = 20;
    env.run();
  end
  
  always #5 apbif.pclk = ~ apbif.pclk;
  
  initial begin
    $dumpfile("dump.vcd");
    $dumpvars;
  end
  
endmodule
  
  
           
      
    
  
    
    
    
    
    


  
  
  
  	