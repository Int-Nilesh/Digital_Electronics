module apb (
  input pclk, //clock 
  input prst, // negative reset
  input psel, // select line each peripheral have its own select line master set psel high while communicating with slave 
  input [7:0] paddr, // address line master put address of slave, if slave consisits of multiple reg we can access specific reg with this addr
  input [7:0] pwdata, // the data master wants to write on slave
  input penable, // enable line set high on next clock cycle when master is ready to send / recive data
  input pwrite, // set high while write operation / LOW on read operation
  output reg [7:0] prdata, // read data from slave 
  output reg pready, // becomes high when slave is ready to accept new data (in this zero wait state assuming slave is always ready to accept data)
  output  pslverr // error flag set high when address/ data is not valid 
);
  
  
  localparam [1:0] idle = 0, write = 1, read = 2;
  reg [7:0] mem[256];
  reg [1:0] state, nstate;
  
  bit addr_err; // address range error if address is outside specifiled rage it will set high in this case  above 15
  bit addv_err; // address value error set high if address is X or Z 
  bit data_err; // data error set high if  data is X or Z
  
  
  always @(posedge pclk, negedge prst) begin
    if (prst == 1'b 0) // negative asynchronus reset
      state <= idle;
    else 
      state <= nstate;
  end
  
  // next state, output decoder
  
  always @(*) begin
    case (state)
      idle: begin
        prdata = 8'h 00;
        pready = 1'b 0;
        
        if( psel == 1'b1 && pwrite == 1'b1) // write operation
          nstate = write;
        else if ( psel == 1'b1 && pwrite == 1'b0) // read operation
          nstate = read;
        else
          nstate = idle;
      end
      
      write: begin
        if (psel == 1'b1 && penable == 1'b1) begin // write only when enable is high on next clock cycle
          if (!addr_err && !addv_err && !data_err ) begin
            pready = 1'b 1; 
            mem[paddr] = pwdata;
            nstate = idle;
          end else begin
            nstate = idle;
            pready = 1'b1;
          end
        end
      end
      
      read: begin
        if(psel == 1'b1 && penable == 1'b1) begin // read only when enable is high on nect clock cycle
          if (!addr_err && !addv_err && !data_err) begin
            pready = 1'b 1;
            prdata = mem[paddr];
            nstate = idle;
          end else begin
            pready = 1'b 1;
            prdata = 8'h 00;
            nstate = idle;
          end
        end
      end
      default: begin 
        nstate = idle;
        prdata = 8'h 00;
        pready = 1'b 0;
      end
    endcase
  end
  
  // checking valid value of add
  
  reg add_value = 0;
  
  always @(*) begin
    if (paddr >= 0)
      add_value = 1'b 0;
    else
      add_value = 1'b 1;
  end
  
  reg data_value = 0;
  
  always @(*) begin
    if (pwdata >= 0)
      data_value = 1'b 0;
    else
      data_value = 1'b 1;
  end
  
  assign addr_err = ((nstate == write || read) && (paddr > 200)) ? 1'b 1 : 1'b 0;
  assign addv_err = ((nstate == write || read) && add_value) ? 1'b 1 : 1'b 0;
  assign data_err = ((nstate == write || read) && data_value) ? 1'b 1 : 1'b 0; 
  
  assign pslverr = (psel == 1'b 1 && penable == 1'b 1) ? (addr_err || addv_err || data_err) : 1'b 0; 
  
endmodule
