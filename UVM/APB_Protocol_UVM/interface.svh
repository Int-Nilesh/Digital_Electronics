
interface apb_if;
  logic pclk; //clock 
  logic prst; // negative reset
  logic psel; // select line each peripheral have its own select line master set psel high while communicating with slave 
  logic [31:0] paddr; // address line master put address of slave, if slave consisits of multiple reg we can access specific reg with this addr
  logic [7:0] pwdata; // the data master wants to write on slave
  logic penable; // enable line set high on next clock cycle when master is ready to send / recive data
  logic pwrite;// set high while write operation / LOW on read operation
  logic [7:0] prdata; // read data from slave 
  logic pready; // becomes high when slave is ready to accept new data (in this zero wait state assuming slave is always ready to accept data)
  logic   pslverr;
  
  //A1: assert property(@(posedge pclk) psel |=> penable) else $error("Slave %0h is not ready yet", paddr);
    
endinterface
    
  