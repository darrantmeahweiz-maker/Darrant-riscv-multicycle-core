

//  ---------- INLCUDED BLOCK: IMEM2  ---------- 
// ==============================================================================
//  MODULE     : IMEM2 (Instruction Memory)
//  DESCRIPTION: 47-Instruction Full System Integration & Smoke Test
// ==============================================================================
module IMEM2(
    input wire [31:0] i_Address,     
    output reg [31:0] o_Instruction,
    input wire oe_i
);

    always @(*) begin
        if (oe_i && (i_Address >= 32'h400000 && i_Address < 32'h400400)) begin
            case ((i_Address - 32'h400000) >> 2)
                
                // === PART 1: MEMORY (LSU SURGICAL TEST) ===
                10'd0:  o_Instruction = 32'h100100b7; // lui  x1, 0x10010 (Base Address)
                10'd1:  o_Instruction = 32'ha5b4c137; // lui  x2, 0xa5b4c
                10'd2:  o_Instruction = 32'h3d210113; // addi x2, x2, 0x3d2 (Data = 0xA5B4C3D2)
                10'd3:  o_Instruction = 32'h0020a023; // sw   x2, 0(x1)
                10'd4:  o_Instruction = 32'h0000a183; // lw   x3, 0(x1)
                10'd5:  o_Instruction = 32'h00009203; // lh   x4, 0(x1)
                10'd6:  o_Instruction = 32'h0000d283; // lhu  x5, 0(x1)
                10'd7:  o_Instruction = 32'h00008303; // lb   x6, 0(x1)
                10'd8:  o_Instruction = 32'h0000c383; // lbu  x7, 0(x1)
                10'd9:  o_Instruction = 32'h00001437; // lui  x8, 0x1
                10'd10: o_Instruction = 32'h12240413; // addi x8, x8, 0x122
                10'd11: o_Instruction = 32'h00809123; // sh   x8, 2(x1)   (Mask Write)
                10'd12: o_Instruction = 32'h09900493; // addi x9, x0, 0x99
                10'd13: o_Instruction = 32'h009080a3; // sb   x9, 1(x1)   (Mask Write)
                10'd14: o_Instruction = 32'h0000ab03; // lw   x22, 0(x1)  (Store LSU final result in x22)

                // === PART 2: HARDWARE ACCELERATORS (MUL & CRC) ===
                10'd15: o_Instruction = 32'hffe00093; // addi x1, x0, -2
                10'd16: o_Instruction = 32'hffd00113; // addi x2, x0, -3
                10'd17: o_Instruction = 32'h022081b3; // mul  x3, x1, x2
                10'd18: o_Instruction = 32'h02209233; // mulh x4, x1, x2
                10'd19: o_Instruction = 32'h0220abb3; // mulhsu x23, x1, x2 (Store MULHSU in x23)
                10'd20: o_Instruction = 32'h0220b333; // mulhu x6, x1, x2
                10'd21: o_Instruction = 32'h00100393; // addi x7, x0, 1
                10'd22: o_Instruction = 32'h00000413; // addi x8, x0, 0
                10'd23: o_Instruction = 32'h808384b3; // crc8 x9, x7, x8
                10'd24: o_Instruction = 32'h80839533; // crc16 x10, x7, x8
                10'd25: o_Instruction = 32'h8083ac33; // crc32 x24, x7, x8 (Store CRC32 in x24)

                // === PART 3: CONTROL FLOW (BRANCH & JUMP COURSE) ===
                10'd26: o_Instruction = 32'h00500093; // addi x1, x0, 5
                10'd27: o_Instruction = 32'h00500113; // addi x2, x0, 5
                10'd28: o_Instruction = 32'hffb00193; // addi x3, x0, -5
                10'd29: o_Instruction = 32'h00208463; // beq  x1, x2, +8 (Pass)
                10'd30: o_Instruction = 32'h00100f93; // addi x31, x0, 1 [TRAP 1]
                10'd31: o_Instruction = 32'h00309463; // bne  x1, x3, +8 (Pass)
                10'd32: o_Instruction = 32'h00200f93; // addi x31, x0, 2 [TRAP 2]
                10'd33: o_Instruction = 32'h0011c463; // blt  x3, x1, +8 (Pass)
                10'd34: o_Instruction = 32'h00300f93; // addi x31, x0, 3 [TRAP 3]
                10'd35: o_Instruction = 32'h0030d463; // bge  x1, x3, +8 (Pass)
                10'd36: o_Instruction = 32'h00400f93; // addi x31, x0, 4 [TRAP 4]
                10'd37: o_Instruction = 32'h0030e463; // bltu x1, x3, +8 (Pass)
                10'd38: o_Instruction = 32'h00500f93; // addi x31, x0, 5 [TRAP 5]
                10'd39: o_Instruction = 32'h0011f463; // bgeu x3, x1, +8 (Pass)
                10'd40: o_Instruction = 32'h00600f93; // addi x31, x0, 6 [TRAP 6]
                10'd41: o_Instruction = 32'h00c0056f; // jal  x10, +12   (Pass)
                10'd42: o_Instruction = 32'h00700f93; // addi x31, x0, 7 [TRAP 7]
                10'd43: o_Instruction = 32'h00700f93; // addi x31, x0, 7 [TRAP 8]
                10'd44: o_Instruction = 32'h00000597; // auipc x11, 0
                10'd45: o_Instruction = 32'h00c58593; // addi x11, x11, 12
                10'd46: o_Instruction = 32'h00058667; // jalr x12, x11, 0 (Pass)

                // === PART 4: U-TYPE & EXHAUSTIVE ALU ===
                10'd47: o_Instruction = 32'h0000000f; // fence (Acts as NOP barrier)
                10'd48: o_Instruction = 32'h123450b7; // lui  x1, 0x12345
                10'd49: o_Instruction = 32'h01000117; // auipc x2, 0x1000
                10'd50: o_Instruction = 32'h00f00093; // addi x1, x0, 15
                10'd51: o_Instruction = 32'hff600113; // addi x2, x0, -10
                10'd52: o_Instruction = 32'h00200a13; // addi x20, x0, 2
                10'd53: o_Instruction = 32'h002081b3; // add  x3, x1, x2
                10'd54: o_Instruction = 32'h40208233; // sub  x4, x1, x2
                10'd55: o_Instruction = 32'h0020f2b3; // and  x5, x1, x2
                10'd56: o_Instruction = 32'hffc0f313; // andi x6, x1, -4
                10'd57: o_Instruction = 32'h0020e3b3; // or   x7, x1, x2
                10'd58: o_Instruction = 32'hff00e413; // ori  x8, x1, -16
                10'd59: o_Instruction = 32'h0020c4b3; // xor  x9, x1, x2
                10'd60: o_Instruction = 32'hfff0c513; // xori x10, x1, -1
                10'd61: o_Instruction = 32'h014095b3; // sll  x11, x1, x20
                10'd62: o_Instruction = 32'h00209613; // slli x12, x1, 2
                10'd63: o_Instruction = 32'h014156b3; // srl  x13, x2, x20
                10'd64: o_Instruction = 32'h00215713; // srli x14, x2, 2
                10'd65: o_Instruction = 32'h414157b3; // sra  x15, x2, x20
                10'd66: o_Instruction = 32'h40215813; // srai x16, x2, 2
                10'd67: o_Instruction = 32'h001128b3; // slt  x17, x2, x1
                10'd68: o_Instruction = 32'h00a0a913; // slti x18, x1, 10
                10'd69: o_Instruction = 32'h001139b3; // sltu x19, x2, x1
                10'd70: o_Instruction = 32'hfff0ba93; // sltiu x21, x1, -1

                // === PART 5: HALT SYSTEM ===
                10'd71: o_Instruction = 32'h00000073; // ecall (System Halt)
                10'd72: o_Instruction = 32'h06300f93; // addi x31, x0, 99 [TRAP 9]
                
                default: o_Instruction = 32'h00000000;
            endcase
        end else begin
            o_Instruction = 32'h00000000;
        end
    end
endmodule



//  ---------- INLCUDED BLOCK: DMEM2  ---------- 
module DMEM2 (
    input  wire        clk_i,
    input  wire        we_i,    
    input  wire        oe_i,    
    input  wire [3:0]  bw_i,   
    input  wire [31:0] address_i,
    input  wire [31:0] data_i,
    output reg  [31:0] data_o
);
    
    reg [31:0] r_RAM [0:2047]; //8KB
  
  	integer i;
    initial begin
        for (i = 0; i < 2048; i = i + 1) begin
            r_RAM[i] = 32'h00000000;
        end
    end

  	wire [10:0] word_index = (address_i - 32'h10010000) >> 2;

    always @(posedge clk_i) begin
        if (we_i) begin
            r_RAM[word_index] <= {
                bw_i[3] ? data_i[31:24] : r_RAM[word_index][31:24],
                bw_i[2] ? data_i[23:16] : r_RAM[word_index][23:16],
                bw_i[1] ? data_i[15:8]  : r_RAM[word_index][15:8],
                bw_i[0] ? data_i[7:0]   : r_RAM[word_index][7:0]
            };
        end
    end
    always @(*) begin
        if (oe_i) begin
            data_o = r_RAM[word_index];
        end else begin
            data_o = 32'h00000000;
        end
    end
endmodule



//  ---------- INLCUDED BLOCK: AddressDecoder  ---------- 
module AddressDecoder (
    //LSU
    input  wire [31:0] address_i, 
    input  wire        we_i,      
    input  wire        oe_i,      
    input  wire [3:0]  bw_i,      

    //DMEM
    output wire [31:0] dmem_address_o, 
    output wire        dmem_we_o,
    output wire        dmem_oe_o,
    output wire [3:0]  dmem_bw_o,
    input  wire [31:0] dmem_data_i,  

    //IMEM
    output wire [31:0] imem_address_o,
    output wire        imem_oe_o,
    input  wire [31:0] imem_data_i,  

    //output
    output wire [31:0] data_o
);

    // IMEM: 0x00400000 ~ 0x007FFFFF (4MB)
    wire is_imem = (address_i >= 32'h00400000 && address_i < 32'h00800000);
    
    // DMEM: 0x10010000 ~ 0x10011FFF (8kB)
    wire is_dmem = (address_i >= 32'h10010000 && address_i < 32'h10012000);

    wire [31:0] aligned_address = {address_i[31:2], 2'b00};

    assign imem_address_o = aligned_address;
    assign imem_oe_o      = oe_i & is_imem; 

    assign dmem_address_o = aligned_address;
    assign dmem_we_o      = we_i & is_dmem; 
    assign dmem_oe_o      = oe_i & is_dmem;
    assign dmem_bw_o      = is_dmem ? bw_i : 4'b0000; 

    assign data_o = is_imem ? imem_data_i :
                    is_dmem ? dmem_data_i : 
                    32'h00000000; 

endmodule



//  ---------- INLCUDED BLOCK: LSU  ---------- 
module LSU (
    // RISC_V Datapath side
    input  wire [31:0] core_data_o,     //Store
    input  wire [31:0] core_address_o,  //Address
    input  wire [2:0]  op_size_o,       //funct3
    output reg  [31:0] core_data_i,     //Load

    // Memory system side
    output wire [31:0] mem_address_i,  
    output reg  [31:0] mem_data_i,     
    output reg  [3:0]  byte_write_i,  
    input  wire [31:0] mem_data_o
);

    assign mem_address_i = core_address_o;

    wire [1:0] addr_lsb = core_address_o[1:0];

    always @(*) begin
        case (op_size_o)
            3'b000: begin // sb (Store Byte)
                mem_data_i = {4{core_data_o[7:0]}}; 
                byte_write_i = (4'b0001 << addr_lsb); 
            end
            3'b001: begin // sh (Store Halfword)
                mem_data_i = {2{core_data_o[15:0]}}; 
                byte_write_i = addr_lsb[1] ? 4'b1100 : 4'b0011;
            end
            3'b010: begin // sw (Store Word)
                mem_data_i = core_data_o;
                byte_write_i = 4'b1111;
            end
            default: begin
                mem_data_i = 32'b0;
                byte_write_i = 4'b0000;
            end
        endcase
    end

    always @(*) begin
        case (op_size_o)
            3'b000: begin // lb (Load Byte)
                case (addr_lsb)
                    2'b00: core_data_i = {{24{mem_data_o[7]}},  mem_data_o[7:0]};
                    2'b01: core_data_i = {{24{mem_data_o[15]}}, mem_data_o[15:8]};
                    2'b10: core_data_i = {{24{mem_data_o[23]}}, mem_data_o[23:16]};
                    2'b11: core_data_i = {{24{mem_data_o[31]}}, mem_data_o[31:24]};
                endcase
            end
            3'b100: begin // lbu (Load Byte Unsigned)
                case (addr_lsb)
                    2'b00: core_data_i = {24'b0, mem_data_o[7:0]};
                    2'b01: core_data_i = {24'b0, mem_data_o[15:8]};
                    2'b10: core_data_i = {24'b0, mem_data_o[23:16]};
                    2'b11: core_data_i = {24'b0, mem_data_o[31:24]};
                endcase
            end
            3'b001: begin // lh (Load Halfword)
                if (addr_lsb[1]) core_data_i = {{16{mem_data_o[31]}}, mem_data_o[31:16]};
                else             core_data_i = {{16{mem_data_o[15]}}, mem_data_o[15:0]};
            end
            3'b101: begin // lhu (Load Halfword Unsigned)
                if (addr_lsb[1]) core_data_i = {16'b0, mem_data_o[31:16]};
                else             core_data_i = {16'b0, mem_data_o[15:0]};
            end
            3'b010: begin // lw (Load Word)
                core_data_i = mem_data_o;
            end
            default: core_data_i = 32'b0;
        endcase
    end
endmodule



//  ---------- INLCUDED BLOCK: Register_file  ---------- 
module Register_file # (
    parameter p_DATA_MEM_SIZE = 2**10
)(
    input [31:0] i_Data_Rd,
    input [31:0] i_Instruction,
    input RegWrite,
    input i_Clk,
    input i_Rst,
    output [31:0] o_Data_Rs_1,
    output [31:0] o_Data_Rs_2  
);
    /* Constants */
    localparam c_SP_INDEX = 2;
    localparam c_GP_INDEX = 3;
    localparam c_GP_INITIAL_VALUE = 32'h1001_0000;
    localparam c_SP_INITIAL_VALUE = c_GP_INITIAL_VALUE + p_DATA_MEM_SIZE - 4;

    /* Instruction fields */
    wire [4:0] w_Select_Rd = i_Instruction[11:7];
    wire [4:0] w_Select_Rs_1 = i_Instruction[19:15];
    wire [4:0] w_Select_Rs_2 = i_Instruction[24:20];
  
    /* Registers Data */
    reg [31:0] r_Registers [0:31];
  
    integer i;
    always @(posedge i_Clk or posedge i_Rst) begin
        if(i_Rst) begin
            for(i = 0; i < 32; i = i + 1) begin
                case (i)
                    c_SP_INDEX: r_Registers[i] <= c_SP_INITIAL_VALUE;
                    c_GP_INDEX: r_Registers[i] <= c_GP_INITIAL_VALUE;
                    default:    r_Registers[i] <= 32'h0;
                endcase
            end
        end
        else begin 
            if(RegWrite && w_Select_Rd != 5'h0) begin
                r_Registers[w_Select_Rd] = i_Data_Rd;
            end
        end
    end
    
    assign o_Data_Rs_1 = r_Registers[w_Select_Rs_1];

    assign o_Data_Rs_2 = r_Registers[w_Select_Rs_2];

endmodule



//  ---------- INLCUDED BLOCK: Reg_A  ---------- 
module Reg_A (
    input  wire  clk,
    input  wire  reset,
    
    input  wire [31:0] i_data,
    output reg  [31:0] o_data
);

    always @(posedge clk) begin
        if (reset) begin
            o_data <= 32'h0000_0000;
        end else begin
            o_data <= i_data;
        end
    end
endmodule



//  ---------- INLCUDED BLOCK: Reg_B  ---------- 
module Reg_B (
    input  wire  clk,
    input  wire  reset,
    
    input  wire [31:0] i_data,
    output reg  [31:0] o_data
);

    always @(posedge clk) begin
        if (reset) begin
            o_data <= 32'h0000_0000;
        end else begin
            o_data <= i_data;
        end
    end
endmodule



//  ---------- INLCUDED BLOCK: IR_Reg  ---------- 
module IR_Reg (
    input  wire  clk,
    input  wire  reset,
    input  wire  IRWrite,
    input  wire [31:0] i_data,
    output reg  [31:0] o_data
);

    always @(posedge clk) begin
        if (reset) begin
            o_data <= 32'h0000_0000;
        end else if (IRWrite) begin
            o_data <= i_data;
        end
    end
endmodule



//  ---------- INLCUDED BLOCK: OldPC_Reg  ---------- 
module OldPC_Reg (
    input  wire  clk,
    input  wire  reset,
    input  wire  IRWrite,
    input  wire [31:0] i_data,
    output reg  [31:0] o_data
);

    always @(posedge clk) begin
        if (reset) begin
            o_data <= 32'h0000_0000;
        end else if (IRWrite) begin
            o_data <= i_data;
        end
    end
endmodule



//  ---------- INLCUDED BLOCK: ALUSrcA_MUX  ---------- 
module ALUSrcA_MUX (
  input [31:0] A, B, C,
  input [1:0] ALUSrcA,
  output reg [31:0] Z
);
  always @(*) begin
    case (ALUSrcA)
      2'b00: Z = A;//PC
      2'b01: Z = B;//OldPC
      2'b10: Z = C;//RegA
      2'b11: Z = 32'h00000000;//lui
      default: Z = A;
    endcase
  end
endmodule



//  ---------- INLCUDED BLOCK: ALUSrcB_MUX  ---------- 
module ALUSrcB_MUX (
  input [31:0] A, B,
  input [1:0] ALUSrcB,
  output reg [31:0] Z
);
  always @(*) begin
    case (ALUSrcB)
      2'b00: Z = A;//RegB
      2'b01: Z = B;//ImmExt
      2'b10: Z = 32'h4;//4
      default: Z = A;
    endcase
  end
endmodule



//  ---------- INLCUDED BLOCK: extend  ---------- 
module extend(
    input [31:7]Instr,
    input [2:0]ImmSrc,
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



//  ---------- INLCUDED BLOCK: Adr_Mux  ---------- 
module Adr_Mux (
    input [31:0] A, B,
    input AdrSrc,
    output reg [31:0] Z
);
    always @(*) begin
        case (AdrSrc)
            1'b0: Z = A; //PC
            1'b1: Z = B; //Result
            default: Z = A;
        endcase
    end
endmodule



//  ---------- INLCUDED BLOCK: PC_Reg  ---------- 
module PC_Reg (
    input  wire  clk,
    input  wire  reset,
    input  wire  PCWrite,
    input  wire [31:0] i_data,
    output reg  [31:0] o_data
);

    always @(posedge clk) begin
        if (reset) begin
            o_data <= 32'h0040_0000;
        end else if (PCWrite) begin
            o_data <= i_data;
        end
    end
endmodule



//  ---------- INLCUDED BLOCK: ALUOut_Reg  ---------- 
module ALUOut_Reg (
    input  wire  clk,
    input  wire  reset,
    
    input  wire [31:0] i_data,
    output reg  [31:0] o_data
);

    always @(posedge clk) begin
        if (reset) begin
            o_data <= 32'h0000_0000;
        end else begin
            o_data <= i_data;
        end
    end
endmodule



//  ---------- INLCUDED BLOCK: ALU__  ---------- 
module ALU__ (
    input wire [31:0] i_A,
    input wire [31:0] i_B,
    input wire [3:0]  i_Sel,
    output reg [31:0] o_Q,
    output o_Zero
);
    localparam c_ALU_OP_PASS = 4'h0;
    localparam c_ALU_OP_ADD  = 4'h1;
    localparam c_ALU_OP_SUB  = 4'h2;
    localparam c_ALU_OP_AND  = 4'h3;
    localparam c_ALU_OP_OR   = 4'h4;
    localparam c_ALU_OP_XOR  = 4'h5;
    localparam c_ALU_OP_SLL  = 4'h6;
    localparam c_ALU_OP_SRL  = 4'h7;
    localparam c_ALU_OP_SRA  = 4'h8;
    localparam c_ALU_OP_SLT  = 4'h9;
    localparam c_ALU_OP_SLTU = 4'hA;
 
    assign o_Zero = (o_Q == 32'b0);
  
    always @ (*) begin
        case (i_Sel)
            c_ALU_OP_PASS: o_Q = i_B;
            c_ALU_OP_SUB:  o_Q = i_A - i_B;
            c_ALU_OP_AND:  o_Q = i_A & i_B;
            c_ALU_OP_OR:   o_Q = i_A | i_B;
            c_ALU_OP_XOR:  o_Q = i_A ^ i_B;
            c_ALU_OP_SLL:  o_Q = i_A << i_B[4:0];
            c_ALU_OP_SRL:  o_Q = i_A >> i_B[4:0];
            c_ALU_OP_SRA:  o_Q = $signed(i_A) >>> i_B[4:0];
            c_ALU_OP_SLT:  o_Q = ($signed(i_A) < $signed(i_B)) ? 32'd1 : 32'd0;
            c_ALU_OP_SLTU: o_Q = ($unsigned(i_A) < $unsigned(i_B)) ? 32'd1 : 32'd0;
            default:       o_Q = i_A + i_B;
        endcase
    end
endmodule



//  ---------- INLCUDED BLOCK: CRC  ---------- 
module CRC(
    input wire clk,
    input wire rst,
    input wire CRC_Enable,
    input wire [3:0] CRC_Control,
    input wire [31:0] i_A,
    input wire [31:0] i_B, 
    output reg [31:0] CRC_Result
);

    //CRC8 logic
    function [7:0] CRC8 (input [31:0] data, input [31:0] seed); //8'h07
        reg [7:0] crc;
        integer i;
        begin
            crc = seed[7:0];
            for (i=31; i>=0; i = i -1) begin
                if(crc[7] ^ data[i]) begin
                    crc = (crc << 1) ^ 8'h07;
                end else begin
                    crc = crc << 1;
                end
            end
            CRC8 = crc;
        end
    endfunction

    //CRC16 logic
    function [15:0] CRC16 (input [31:0] data, input [31:0] seed); //16'h8005
        reg [15:0] crc;
        integer i;
        begin
            crc = seed[15:0];
            for (i=31; i>=0; i = i -1) begin
                if(crc[15] ^ data[i]) begin
                    crc = (crc << 1) ^ 16'h8005;
                end else begin
                    crc = crc << 1;
                end
            end
            CRC16 = crc;
        end
    endfunction

    //CRC32 logic
    function [31:0] CRC32 (input [31:0] data, input [31:0] seed); //32'h04C11DB7
        reg [31:0] crc;
        integer i;
        begin
            crc = seed;
            for (i=31; i>=0; i = i -1) begin
                if(crc[31] ^ data[i]) begin
                    crc = (crc << 1) ^ 32'h04C11DB7;
                end else begin
                    crc = crc << 1;
                end
            end
            CRC32 = crc;
        end
    endfunction


    // 3 independent block (process 3 inputs respectively)
    wire [7:0] crc8_out;
    wire [15:0] crc16_out;
    wire [31:0] crc32_out;

    assign crc8_out = CRC8(i_A,i_B); //CRCB
    assign crc16_out = CRC16(i_A,i_B); //CRCH
    assign crc32_out = CRC32(i_A,i_B); //CRCW

    always @(*) begin
        if (CRC_Enable == 0) begin
            CRC_Result = 32'h00000000; // zero when disabled
        end else begin 
            case (CRC_Control)
                4'h0: begin
                    CRC_Result = {24'h000000, crc8_out};
                end
                4'h1: begin
                    CRC_Result = {16'h0000, crc16_out};
                end
                4'h2: begin
                    CRC_Result = crc32_out;
                end
                default: CRC_Result = 32'h00000000;
            endcase
        end
    end
endmodule



//  ---------- INLCUDED BLOCK: MUL  ---------- 
module MUL(
    input wire clk,
    input wire rst,
    input wire MUL_Enable,
    input wire [3:0] MUL_Control,
    input wire [31:0] i_A,
    input wire [31:0] i_B, 
    output reg [31:0] MUL_Result
);

    wire signed [63:0] signed_A     = {{32{i_A[31]}},i_A};
    wire signed [63:0] signed_B     = {{32{i_B[31]}},i_B};
    wire signed [63:0] unsigned_A   = {32'h00000000,i_A};
    wire signed [63:0] unsigned_B   = {32'h00000000,i_B};

    wire [63:0] MULH_out = signed_A * signed_B;   //signed*signed
    wire [63:0] MULHSU_out = signed_A * unsigned_B; //signed*unsigned
    wire [63:0] MULHU_out = unsigned_A * unsigned_B;  //unsigned*unsigned

    always @(*) begin
        if (MUL_Enable == 0) begin
            MUL_Result = 32'h00000000; // zero when disabled
        end else begin 
            case (MUL_Control)
                4'h0: begin
                    MUL_Result = MULH_out[31:0];
                end
                4'h1: begin
                    MUL_Result = MULH_out[63:32];
                end
                4'h2: begin
                    MUL_Result = MULHSU_out[63:32];
                end
                4'h3: begin
                    MUL_Result = MULHU_out[63:32];
                end
                default: MUL_Result = 32'h00000000;
            endcase
        end
    end
endmodule



//  ---------- INLCUDED BLOCK: ExtSel_MUX  ---------- 
module ExtSel_MUX (
    input wire [31:0] ALU_Result, 
    input wire [31:0] MUL_Result, 
    input wire [31:0] CRC_Result, 
    
    input wire [1:0]  ExtSel,     
    
    output reg [31:0] Z
);

    always @(*) begin
        case (ExtSel)
            2'b00: Z = ALU_Result; 
            2'b01: Z = MUL_Result; 
            2'b10: Z = CRC_Result; 
            default: Z = ALU_Result;
        endcase
    end

endmodule



//  ---------- INLCUDED BLOCK: ResultSrc_MUX  ---------- 
module ResultSrc_MUX (
  input [31:0] A, B, C,
  input [1:0] ResultSrc,
  output reg [31:0] Z
);
  always @(*) begin
    case (ResultSrc)
      2'b00: Z = A;//ALUOut
      2'b01: Z = B;//ReadData
      2'b10: Z = C;//ALUResut
      default: Z = A;
    endcase
  end
endmodule



//  ---------- INLCUDED BLOCK: Data_Reg  ---------- 
module Data_Reg (
    input  wire  clk,
    input  wire  reset,
    
    input  wire [31:0] i_data,
    output reg  [31:0] o_data
);

    always @(posedge clk) begin
        if (reset) begin
            o_data <= 32'h0000_0000;
        end else begin
            o_data <= i_data;
        end
    end
endmodule



//  ---------- INLCUDED BLOCK: RISC_V_Multicycle_Control_Unit  ---------- 
module RISC_V_Multicycle_Control_Unit (
    input clk, rst,
    input [6:0] op,
    input [2:0] funct3,
    input [6:0] funct7,
    input Zero,
    output reg PCWrite, AdrSrc, MemWrite, IRWrite, RegWrite, MemRead,
    output reg [1:0] ResultSrc, ALUSrcA, ALUSrcB, ExtSel,
	output reg [2:0] ImmSrc,
    output reg [3:0] ALUControl,
    output reg Mul_Enable, CRC_Enable,
	output reg [3:0] Mul_Control, CRC_Control
);

// Main FSM states
localparam Fetch 	= 4'b0000;
localparam Decode 	= 4'b0001;
localparam MemAdr 	= 4'b0010;
localparam MEMRead 	= 4'b0011;
localparam MemWB 	= 4'b0100;
localparam MEMWrite = 4'b0101;
localparam ExecuteR = 4'b0110;
localparam AluWB 	= 4'b0111;
localparam Branch 	= 4'b1000;
localparam ExecuteJ_1	= 4'b1001;
localparam ExecuteU = 4'b1010;
localparam Halt 	= 4'b1011;
localparam ExecuteJ_2	= 4'b1100;

reg [3:0] state_reg, state_next;

always @ (posedge clk or posedge rst)
begin
    if (rst)
        state_reg <= Fetch;
    else
        state_reg <= state_next;
end

always @ (*)
begin
	PCWrite = 1'b0; AdrSrc =1'b0; MemWrite =1'b0;  IRWrite = 1'b0; MemRead =1'b0;
	RegWrite = 1'b0; ALUSrcA = 2'b00; ALUSrcB = 2'b00; ResultSrc = 2'b00; ExtSel = 2'b00;
	ALUControl = 4'b0000; 
	Mul_Enable = 1'b0; CRC_Enable = 1'b0; 
	Mul_Control = 4'h0; CRC_Control = 4'h0;
	state_next = state_reg;
	case (op)
        7'b0100011: ImmSrc = 3'b001; // S-Type
        7'b1100011: ImmSrc = 3'b010; // B-Type
        7'b1101111: ImmSrc = 3'b011; // J-Type
        7'b0110111, 7'b0010111: ImmSrc = 3'b100; // U-Type
        default:    ImmSrc = 3'b000; // I-Type, R-Type
   	endcase

    case(state_reg)
        Fetch:
            begin
                // logic for Fetch (RegWrite = 0; MemWrite = 0;)
				PCWrite = 1'b1; AdrSrc = 1'b0; IRWrite =  1'b1; ImmSrc = 3'b000; MemRead =1'b1;
				ALUSrcA = 2'b00; ALUSrcB = 2'b10; ALUControl = 4'h1;
				ResultSrc = 2'b10;
				state_next = Decode;
            end
		Decode:
            begin
                // State logic for Decode
				ALUSrcA = 2'b00; ALUSrcB = 2'b10; ALUControl = 4'h1;
				case (op)
					7'b0110011: begin //R-Type
						state_next = ExecuteR;
					end
					7'b0010011: begin //I-Type (addi ...)
						state_next = ExecuteR;
					end
					7'b0000011: begin //I-Type (load)
						state_next = MemAdr;
					end
					7'b0100011: begin //S-Type
						state_next = MemAdr;
					end
					7'b1100011: begin //B-Type
						state_next = Branch;
					end
					7'b1101111: begin //J-type (jal)
						state_next = ExecuteJ_1;
					end
					7'b1100111: begin //I-type (jalr)
						state_next = ExecuteJ_1;
					end
					7'b0110111, 7'b0010111: begin // U-Type
						state_next = ExecuteU;
					end	
					7'b1110011: begin //system (ecall & ebreak)
						state_next = Halt;
					end
					7'b0001111: begin //Fench
						state_next = Fetch;
					end
					default: begin
						state_next = Fetch;
					end
				endcase
            end
		ExecuteR: 
			
			begin
				ALUSrcA = 2'b10; //both same
				if (op == 7'b0110011) begin
					//R-type (normal arithmetic)
					ALUSrcB = 2'b00; 

						//R-type multiplier
						if (funct7==7'b0000001) begin
							Mul_Enable = 1'b1;
							Mul_Control = {1'b0,funct3};
							ExtSel = 2'b01;

						//R-type CRC
						end else if (funct7==7'b1000000) begin
							CRC_Enable = 1'b1;
							CRC_Control = {1'b0,funct3};
							ExtSel = 2'b10;
						end

				end else begin
					//i-type (normal arithmetic)
					ALUSrcB = 2'b01; 
				end
			
			if ((Mul_Enable == 0) && (CRC_Enable==0)) begin
				case(funct3)
					3'b000: begin
						if ((op==7'b0110011) && (funct7==7'b0100000)) begin
							ALUControl = 4'h2; //sub (no subi option)
						end else begin
							ALUControl = 4'h1; //add & addi
						end
					end
					3'b001: begin
						ALUControl = 4'h6; //sll & slli
					end
					3'b010: begin
						ALUControl = 4'h9; //slt & slti
					end
					3'b011: begin
						ALUControl = 4'hA; //sltu & sltiu
					end
					3'b100: begin
						ALUControl = 4'h5; //xor & xori
					end
					3'b101: begin
						if (funct7 ==7'b0100000) begin
						ALUControl = 4'h8; //sra & srai
						end else begin
						ALUControl = 4'h7; //srl & srli
						end
					end
					3'b110: begin
						ALUControl = 4'h4; //or & ori
					end
					3'b111: begin
						ALUControl = 4'h3; //and & andi
					end
					default: begin
						ALUControl = 4'h0;
					end
				endcase	
				end
				state_next = AluWB;				
			end
		MemAdr:
            begin
			ALUSrcA = 2'b10; ALUSrcB = 2'b01; ALUControl = 4'h1;
                case (op)
					7'b0000011: begin
						state_next = MEMRead;
					end
					7'b0100011: begin
						state_next = MEMWrite;
					end
					default: begin
						state_next = Fetch;
					end
				endcase		
            end
		MEMRead:
			begin
				ResultSrc = 2'b00; AdrSrc = 1'b1; MemRead = 1'b1;
				state_next = MemWB;
			end
		MEMWrite:
			begin
				ResultSrc = 2'b00; AdrSrc = 1'b1; MemWrite = 1'b1;
				state_next = Fetch;
			end
		MemWB:
			begin 
				ResultSrc = 2'b01; RegWrite = 1'b1;
				state_next = Fetch;
			end
        AluWB:
			begin
				ResultSrc = 2'b00; RegWrite = 1'b1;
				state_next = Fetch;
			end
		Branch:
			begin
				ALUSrcA = 2'b10; ALUSrcB = 2'b00;
				ResultSrc = 2'b00;

				case (funct3)
				3'b000: begin //beq ==
					ALUControl = 4'h2; //c_ALU_OP_SUB
					if (Zero == 1'b1) PCWrite = 1'b1;
				end
				3'b001: begin //bne !=
					ALUControl = 4'h2; //c_ALU_OP_SUB
					if (Zero == 1'b0) PCWrite = 1'b1;
				end
				3'b100: begin //blt <
					ALUControl = 4'h9; //c_ALU_OP_SLT
					if (Zero == 1'b0) PCWrite = 1'b1;
				end
				3'b101: begin //bge >=
					ALUControl = 4'h9; //c_ALU_OP_SLT
					if (Zero == 1'b1) PCWrite = 1'b1;
				end
				3'b110: begin //bltu <
					ALUControl = 4'hA; //c_ALU_OP_SLTU
					if (Zero == 1'b0) PCWrite = 1'b1;
				end
				3'b111: begin //bgeu >=
					ALUControl = 4'hA; //c_ALU_OP_SLTU
					if (Zero == 1'b1) PCWrite = 1'b1;
				end
				default: begin
					state_next = Fetch;
				end
			endcase
			state_next = Fetch;
			end
		ExecuteJ_1: begin
			ALUSrcA = 2'b01; //OldPC
			ALUSrcB = 2'b10; //4
			ALUControl = 4'h1; //add
			ResultSrc = 2'b10; //OldPC + 4
			RegWrite = 1'b1; //rd
			state_next = ExecuteJ_2;
		end
		ExecuteJ_2: begin
			if (op == 7'b1101111) begin
				ALUSrcA = 2'b01; //oldPC & JAL
			end else begin
				ALUSrcA = 2'b10; //RegA & JALR
			end
			ALUSrcB = 2'b01; //im
			ALUControl = 4'h1; //add
			ResultSrc = 2'b10;
			PCWrite = 1'b1;
			state_next = Fetch;
		end
		ExecuteU: begin
			if (op == 7'b0110111) begin
				ALUSrcA = 2'b11;//nothing
			end else begin
				ALUSrcA = 2'b01;//oldPC
			end
			ALUSrcB = 2'b01; //im
			ALUControl = 4'h1; //add
			ResultSrc = 2'b00;
			state_next = AluWB;
		end
		Halt: begin
			state_next = Halt;
		end
        default:
            begin
                state_next = Fetch;
            end 
    	endcase
	end 
endmodule



//  ---------- INLCUDED BLOCK: Instruction_Splitter  ---------- 
module Instruction_Splitter (
    input  wire [31:0] Instr_i,      

    output wire [6:0]  op_o,          
    output wire [2:0]  funct3_o,      
    output wire [6:0]  funct7_o,      
    output wire [24:0] Instr_31_7_o,  
    output wire [2:0]  op_size_o      
);

    
    assign op_o         = Instr_i[6:0];
    assign funct3_o     = Instr_i[14:12];
    assign funct7_o     = Instr_i[31:25];
    assign Instr_31_7_o = Instr_i[31:7];
    assign op_size_o    = Instr_i[14:12]; 

endmodule


// Automatically generated by ChipInventor Cloud EDA Tool - 3.15
// Careful: this file (hdl.v) will be automatically replaced
// when you ask tool to generate top Verilog code by clicking
// at BLOCKS button.

module top (

  input wire clk_i,
  input wire rst_i

);

//Internal Wires
 wire [31:0] w_1;
 wire w_2;
 wire w_3;
 wire [3:0] w_4;
 wire [31:0] w_5;
 wire [31:0] w_6;
 wire [31:0] w_7;
 wire w_8;
 wire w_9;
 wire [3:0] w_10;
 wire [31:0] w_11;
 wire w_12;
 wire [31:0] w_13;
 wire [31:0] w_15;
 wire [31:0] w_16;
 wire [2:0] w_17;
 wire [31:0] w_18;
 wire [31:0] w_19;
 wire [31:0] w_20;
 wire [31:0] w_21;
 wire w_22;
 wire [31:0] w_23;
 wire [31:0] w_24;
 wire [31:0] w_25;
 wire w_27;
 wire [31:0] w_30;
 wire [31:0] w_31;
 wire [31:0] w_32;
 wire [1:0] w_33;
 wire [31:0] w_34;
 wire [31:7] w_37;
 wire [2:0] w_38;
 wire w_41;
 wire [31:0] w_42;
 wire [31:0] w_43;
 wire [31:0] w_44;
 wire [3:0] w_45;
 wire [31:0] w_46;
 wire w_47;
 wire w_48;
 wire [3:0] w_49;
 wire [31:0] w_51;
 wire w_52;
 wire [3:0] w_53;
 wire [31:0] w_55;
 wire [1:0] w_56;
 wire [31:0] w_58;
 wire [1:0] w_59;
 wire [6:0] w_61;
 wire [2:0] w_62;
 wire [6:0] w_63;
 wire w_64;
 wire [1:0] w_66;

//Instances of Modules
AddressDecoder blk4104_3 (
         .address_i (w_1),
         .we_i (w_2),
         .oe_i (w_3),
         .bw_i (w_4),
         .dmem_data_i (w_5),
         .imem_data_i (w_6),
         .dmem_address_o (w_7),
         .dmem_we_o (w_8),
         .dmem_oe_o (w_9),
         .dmem_bw_o (w_10),
         .imem_address_o (w_11),
         .imem_oe_o (w_12),
         .data_o (w_13)
     );

LSU blk4106_4 (
         .mem_address_i (w_1),
         .byte_write_i (w_4),
         .mem_data_o (w_13),
         .core_data_o (w_15),
         .core_address_o (w_16),
         .op_size_o (w_17),
         .core_data_i (w_18),
         .mem_data_i (w_19)
     );

DMEM2 blk4102_14 (
         .clk_i (clk_i),
         .data_o (w_5),
         .address_i (w_7),
         .we_i (w_8),
         .oe_i (w_9),
         .bw_i (w_10),
         .data_i (w_19)
     );

Register_file #(.p_DATA_MEM_SIZE(2**10)) blk4114_15 (
         .i_Clk (clk_i),
         .i_Rst (rst_i),
         .i_Data_Rd (w_20),
         .i_Instruction (w_21),
         .RegWrite (w_22),
         .o_Data_Rs_1 (w_23),
         .o_Data_Rs_2 (w_24)
     );

Reg_A blk4115_16 (
         .clk (clk_i),
         .reset (rst_i),
         .i_data (w_23),
         .o_data (w_25)
     );

Reg_B blk4116_17 (
         .clk (clk_i),
         .reset (rst_i),
         .o_data (w_15),
         .i_data (w_24)
     );

IR_Reg blk4117_18 (
         .clk (clk_i),
         .reset (rst_i),
         .i_data (w_13),
         .o_data (w_21),
         .IRWrite (w_27)
     );

OldPC_Reg blk4118_19 (
         .clk (clk_i),
         .reset (rst_i),
         .IRWrite (w_27),
         .i_data (w_30),
         .o_data (w_31)
     );

ALUSrcB_MUX blk4120_23 (
         .A (w_15),
         .B (w_32),
         .ALUSrcB (w_33),
         .Z (w_34)
     );

extend blk4121_24 (
         .ImmExt (w_32),
         .Instr (w_37),
         .ImmSrc (w_38)
     );

Adr_Mux blk4122_25 (
         .Z (w_16),
         .A (w_30),
         .B (w_20),
         .AdrSrc (w_41)
     );

ALUOut_Reg blk4124_27 (
         .clk (clk_i),
         .reset (rst_i),
         .i_data (w_42),
         .o_data (w_43)
     );

ALU__ blk4126_28 (
         .i_B (w_34),
         .i_A (w_44),
         .i_Sel (w_45),
         .o_Q (w_46),
         .o_Zero (w_47)
     );

MUL blk4128_30 (
         .clk (clk_i),
         .rst (rst_i),
         .i_B (w_34),
         .MUL_Enable (w_48),
         .MUL_Control (w_49),
         .i_A (w_44),
         .MUL_Result (w_51)
     );

CRC blk4127_31 (
         .clk (clk_i),
         .rst (rst_i),
         .i_B (w_34),
         .CRC_Enable (w_52),
         .CRC_Control (w_53),
         .i_A (w_44),
         .CRC_Result (w_55)
     );

ExtSel_MUX blk4130_32 (
         .Z (w_42),
         .ALU_Result (w_46),
         .MUL_Result (w_51),
         .CRC_Result (w_55),
         .ExtSel (w_56)
     );

ResultSrc_MUX blk4132_34 (
         .Z (w_20),
         .A (w_43),
         .C (w_42),
         .B (w_58),
         .ResultSrc (w_59)
     );

Data_Reg blk4133_35 (
         .clk (clk_i),
         .reset (rst_i),
         .i_data (w_18),
         .o_data (w_58)
     );

Instruction_Splitter blk4136_37 (
         .op_size_o (w_17),
         .Instr_i (w_21),
         .Instr_31_7_o (w_37),
         .op_o (w_61),
         .funct3_o (w_62),
         .funct7_o (w_63)
     );

PC_Reg blk4123_39 (
         .clk (clk_i),
         .reset (rst_i),
         .o_data (w_30),
         .i_data (w_20),
         .PCWrite (w_64)
     );

ALUSrcA_MUX blk4119_53 (
         .C (w_25),
         .B (w_31),
         .Z (w_44),
         .A (w_30),
         .ALUSrcA (w_66)
     );

RISC_V_Multicycle_Control_Unit blk4134_55 (
         .clk (clk_i),
         .rst (rst_i),
         .MemWrite (w_2),
         .MemRead (w_3),
         .RegWrite (w_22),
         .IRWrite (w_27),
         .ALUSrcB (w_33),
         .ImmSrc (w_38),
         .AdrSrc (w_41),
         .ALUControl (w_45),
         .Zero (w_47),
         .Mul_Enable (w_48),
         .Mul_Control (w_49),
         .CRC_Enable (w_52),
         .CRC_Control (w_53),
         .ExtSel (w_56),
         .ResultSrc (w_59),
         .op (w_61),
         .funct3 (w_62),
         .funct7 (w_63),
         .PCWrite (w_64),
         .ALUSrcA (w_66)
     );

IMEM2 blk4101_59 (
         .o_Instruction (w_6),
         .i_Address (w_11),
         .oe_i (w_12)
     );


endmodule
