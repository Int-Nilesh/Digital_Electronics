`timescale 1ns / 1ps

// different command possibilites
// in your test bench for each of these 5 options test the ALU on 5 random input pairs
`define ALU_ADD 3'b000
`define ALU_SUB 3'b001
`define ALU_XOR 3'b010
`define ALU_AND 3'b011
`define ALU_OR  3'b100

module alu(
    alu_cmd,
    alu_operand0,
    alu_operand1,
    alu_out
    );
    
    // use the default parameters for your testbench
    parameter data_width = 32;
    parameter cmd_width = 3;
    
    input wire [cmd_width-1:0]alu_cmd;
    input wire [data_width-1:0]alu_operand0;
    input wire [data_width-1:0]alu_operand1;
    
    output reg [data_width-1:0] alu_out;
    
    // combinational always block with case
    always @(*) begin
    case (alu_cmd)
    `ALU_ADD : alu_out = alu_operand0 + alu_operand1;
    `ALU_SUB : alu_out = alu_operand0 - alu_operand1;
    `ALU_AND : alu_out = alu_operand0 & alu_operand1;
    `ALU_OR : alu_out = alu_operand0 | alu_operand1;
    `ALU_XOR : alu_out = alu_operand0 ^ alu_operand1;
    endcase
    end
    
endmodule
