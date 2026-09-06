`timescale 1ns / 1ps

// ==============================================================================
//  MODULE     : Extend (Immediate Generation Unit)
//  DESCRIPTION: Extracts and sign-extends immediate values for RISC-V ISA (I, S, B, J, U)
// ==============================================================================
module extend(
    input [31:7] Instr,
    input [2:0] ImmSrc,
    output reg [31:0] ImmExt
  );
  always @(*) begin
    case(ImmSrc)
      3'b000: begin // I-type (addi, lw, jalr)
        ImmExt = {{20{Instr[31]}},Instr[31:20]};
      end
      3'b001: begin // S-type (sw)
       ImmExt = {{20{Instr[31]}},Instr[31:25],Instr[11:7]};
      end
      3'b010: begin // B-type (branch)
        ImmExt = {{20{Instr[31]}},Instr[7],Instr[30:25],Instr[11:8],1'b0};
      end
      3'b011: begin // J-type (jal)
        ImmExt = {{12{Instr[31]}},Instr[19:12],Instr[20],Instr[30:21],1'b0};
      end
      3'b100: begin // U-type (lui, auipc)
       ImmExt = {Instr[31:12],12'b0};
      end
      default: begin
       ImmExt = 32'b0;
      end
    endcase
  end
endmodule

// ==============================================================================
//  MODULE     : testbench (Extend IP Unit Test)
//  DESCRIPTION: Rigorous verification environment for Immediate Extractor
// ==============================================================================
module testbench;
  reg[31:7] Instr;
  reg[2:0] ImmSrc;
  wire [31:0] ImmExt;

  extend uut (
    .Instr(Instr), .ImmSrc(ImmSrc), .ImmExt(ImmExt)
  );

initial begin 
  // Initial state
  Instr = 25'b0; ImmSrc = 3'b000;
  #10;

  // Test 1: I-type
  ImmSrc = 3'b000;
  Instr = {12'hFFF, 13'b0}; #5;
  $display("I-type test --> ImmExt = 0x%0h (Expected: 0xffffffff)", ImmExt); #5;

  // Test 2: S-type
  ImmSrc = 3'b001;
  Instr = {7'h01, 5'h1F, 13'b0}; #5;
  $display("S-type test --> ImmExt = 0x%0h (Expected: 0x20)", ImmExt); #5;

  // Test 3: B-type
  ImmSrc = 3'b010;
  Instr = {1'b1, 6'h3F, 1'b1, 4'hF, 13'b0}; #5;
  $display("B-type test --> ImmExt = 0x%0h (Expected: 0xfffff7e0)", ImmExt); #5;

  // Test 4: J-type
  ImmSrc = 3'b011;
  Instr = {1'b1, 8'hAA, 1'b1, 10'h3FF, 5'b0}; #5;
  $display("J-type test --> ImmExt = 0x%0h (Expected: 0xfffffd56)", ImmExt); #5;

  // Test 5: U-type
  ImmSrc = 3'b100;
  Instr = {20'h12345, 5'b0}; #5;
  $display("U-type test --> ImmExt = 0x%0h (Expected: 0x12345000)", ImmExt); #5;

  $display(" Extend test complete! ");
  $finish;
end
endmodule