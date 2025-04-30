//SPI Protocol 
//SPI protocol is used for communication between Microcontroller and Peripheral devices
// It is used for OFF chip communication unlike APB which is used for ON chip communication
// SPI is Master slave Full duplex serial communication protocol 
// here Memory is used as peripheral device connected to SPI master


///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
/////////////////////                    //////////////////////////
/////////////////////   SPI Controller   //////////////////////////
/////////////////////                    //////////////////////////
///////////////////////////////////////////////////////////////////


module spi_controller (
  input clk, rst, wr, ready, op_done, miso,
  input [7:0] addr, din,
  output [7:0] dout, // to store value read from mem
  output reg mosi, cs, done, err
);
  
  reg [16:0] din_reg; // 16-8 data, 7-1 addrsss, 0 wr/rd
  reg [7:0] dout_reg = 0;
  
  int count = 0;
  
  typedef enum bit [2:0] {idle = 0, load = 1, check_op = 2, send_data = 3,
                          read_data1 = 4, read_data2 = 5, error = 6, check_ready = 7} state_type;
  state_type state = idle;
  
  /////////// CS logic
  
  always @(posedge clk) begin
    if (!rst) begin
      state <= idle;
      count <= 0;
      cs <= 1'b 1;
      mosi <= 0;
      err <= 0;
      done <= 0;
      //$display("Reset done");
    end
    else begin 
      case (state)
        idle: begin
          cs <= 1'b 1;
          mosi <= 0;
          count <= 0;
          state <= load;
          err <= 1'b 0;
          done <= 0;
          //$display("In Idle state");
        end
        load : begin
          din_reg <= {din, addr, wr}; // making packet to send
          state <= check_op;
          //$display("In load state");
        end
        
        check_op: begin
          if (wr == 1 && addr < 32) begin
            cs <= 1'b 0;
            err <=0;
            state <= send_data;
            //$display("In check op write");
          end 
          else if (wr == 0 && addr <32) begin
            cs <= 1'b 0;
            err <= 0;
            state <= read_data1;
            //$display("checl operation read");
          end
          else begin
            state <= error;
            cs <= 1'b 1;
            //$display("Check operation error");
          end
        end
          
        send_data: begin
          if (count <= 16) begin
            mosi <= din_reg[count];
            count <= count + 1;
            state <= send_data;
            //$display("data sending in process");
          end
          else begin
            cs <= 1'b 1;
            mosi <= 0;
            //$display("Sedning data done");
            if (op_done) begin
              done <= 1;
              state <= idle;
              //count <= 0;
              //$display("Writing data done");
            end
            else begin 
              state <= send_data; // it will skip the sending data again as count is 17 at this point
                                  // and wait till op_done becomes 1
            end
          end
        end
        read_data1: begin
          if(count <= 8) begin
            mosi <= din_reg[count];
            count <= count + 1;
            state <= read_data1;
          end
          else begin
            count <= 0;
            cs <= 1'b 1;
            state <= check_ready;
            //$display("Sending address done");
          end
        end
          
        check_ready: begin
          if (ready)
            state <= read_data2;
          else
            state <= check_ready;
        end 
          
        read_data2: begin
          if (count <= 7) begin
            dout_reg[count] <= miso;
            count <= count +1;
            state <= read_data2;
          end
          else begin
            count <= 0;
            done <= 1'b 1;
            state <= idle;
            //$display("Reading data is done");
          end
        end
          
        error: begin
          err <= 1'b 1;
          state <= idle;
          done <= 1;
          //$display("In error state");
        end
          
        default: begin
          state <= idle;
          count <= 0;
          //$display("In default state");
        end
      endcase
    end
  end
  
  assign dout = dout_reg;
endmodule

///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
/////////////////////                 /////////////////////////////
/////////////////////   SPI MEMORY    /////////////////////////////
/////////////////////                 /////////////////////////////
///////////////////////////////////////////////////////////////////

module spi_mem (
  input clk, rst, cs, miso,
  output reg ready, mosi, op_done);
  
  reg [7:0]mem[31:0] = '{default:8'b 0};
  int count = 0;
  reg [15 : 0] datain;
  reg [7:0] dataout;
  
  typedef enum bit [2:0] {idle = 0, detect = 1, store = 2, send_addr = 3,
                          send_data = 4} state_type;
  state_type state = idle;
  
  always @(posedge clk) begin
    if (!rst) begin
      count <= 0;
      state <= idle;
      mosi <= 0;
      ready <= 0;
      op_done <= 0;
      //$display("mem rst done");
      
    end 
    else begin
      case (state)
        idle: begin
          count <= 0;
          mosi <= 0;
          ready <= 0;
          op_done <= 0;
          //$display("Mem Idle state");
          if (!cs)
            state <= detect;
          else
            state <= idle;
        end
        
        detect: begin
          if (miso) begin // we are consuming 1st bit of din_reg data from master here 
            state <= store; // write , on next clock cycle it will jump on store case
            //$display("MEM write detected ");
          end
          else begin
            state <= send_addr;
            //$display("Mem read dected ");
          end
        end
        
        store: begin
          if (count <= 15) begin
            datain[count] <= miso; // 1st bit got consumed at detect stage
            count <= count + 1;
            state <= store;
            //$display("Mem writing in process");
          end
          else begin
            mem [datain[7:0]] <= datain[15:8];
            state <= idle;
            count <= 0;
            op_done <= 1;
            //$display("Mem write complete");
          end
        end
        
        send_addr: begin
          if (count <= 7) begin
            datain[count] <= miso;
            count <= count + 1;
            state <= send_addr;
          end
          else begin
            state <= send_data;
            count <= 0;
            ready <= 1;
            dataout <= mem[datain[7:0]];
            //$display("Mem Address recived");
          end
        end
        
        send_data: begin
          ready <= 1'b 0;
          if (count <= 7) begin
            mosi <= dataout[count];
            count <= count +1;
            state <= send_data;
          end
          else begin
            count <= 0;
            state <= idle;
            op_done <= 1'b 1;
            //$display("Mem Data sent");
          end
        end
        
        default : begin
          state <= idle;
          count <= 0;
        end 
      endcase
    end
  end
endmodule

///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
/////////////////////                 /////////////////////////////
/////////////////////   TOP MODULE    /////////////////////////////
/////////////////////                 /////////////////////////////
///////////////////////////////////////////////////////////////////

module top (
  input clk, rst, wr,
  input [7:0] din, addr,
  output done, err,
  output [7:0] dout);
  
  wire csreg, mosireg, misoreg, readyreg, op_donereg;
  
  spi_controller spi_contr(clk, rst, wr, readyreg, op_donereg, misoreg,
                          addr, din, dout, mosireg, csreg, done, err);
  
  spi_mem spi_m(clk, rst, csreg, mosireg, readyreg, misoreg, op_donereg);
  
endmodule



            
          
          
            
            
          
  
  
        
           
          
          