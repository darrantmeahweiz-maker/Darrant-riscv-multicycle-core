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