`timescale 1ns / 1ps

// different command possibilites
// in your test bench for each of these 5 options test the ALU on 5 random input pairs
`define ALU_ADD 3'b000
`define ALU_SUB 3'b001
`define ALU_XOR 3'b010
`define ALU_AND 3'b011
`define ALU_OR  3'b100

module salu(
    cmd,
	clk,
    ain,
    bin,
    outr
    );
    
    // use the default parameters for your testbench
    parameter data_width = 16;
    parameter cmd_width = 3;
    
	input wire clk;
    input wire [cmd_width-1:0]cmd;
    input wire [data_width-1:0]ain;
    input wire [data_width-1:0]bin;
	
    reg [data_width-1:0]a;
    reg [data_width-1:0]b;
    
    output reg [data_width-1:0] outr;
	
    // update the register outr based on the commands
    always @(posedge clk) begin
	a <= ain;
	b <= bin;
    case (cmd)
    `ALU_ADD : outr <= a + b;
    `ALU_SUB : outr <= a - b;
    `ALU_AND : outr <= a & b;
    `ALU_OR : outr <= a | b;
    `ALU_XOR : outr <= a ^ b;
    endcase
    end
    
endmodule
