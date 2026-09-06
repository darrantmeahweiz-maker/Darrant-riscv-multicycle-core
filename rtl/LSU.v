`timescale 1ns / 1ps

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

module testbench;
    
    reg [31:0] core_data_o;
    reg [31:0] core_address_o;
    reg [2:0]  op_size_o;
    reg [31:0] mem_data_o;

    wire [31:0] mem_address_i;
    wire [31:0] mem_data_i;
    wire [3:0]  byte_write_i;
    wire [31:0] core_data_i;

    LSU uut (
        .core_data_o(core_data_o),
        .core_address_o(core_address_o),
        .op_size_o(op_size_o),
        .core_data_i(core_data_i),
        .mem_address_i(mem_address_i),
        .mem_data_i(mem_data_i),
        .byte_write_i(byte_write_i),
        .mem_data_o(mem_data_o)
    );

    initial begin
        // 1. Test Store Byte (sb) at offset 1 (addr_lsb = 2'b01)
        op_size_o      = 3'b000; // sb
        core_address_o = 32'h10010001; 
        core_data_o    = 32'h123456AB; // Lower byte is 0xAB
        #10;
        $display("[STORE - SB] Addr: %h | Data_in: %h | Mem_WD: %h (Exp: ABABABAB) | Byte_WE: %b (Exp: 0010)", 
                 core_address_o, core_data_o, mem_data_i, byte_write_i);

        // 2. Test Store Halfword (sh) at offset 2 (addr_lsb = 2'b10)
        op_size_o      = 3'b001; // sh
        core_address_o = 32'h10010002; 
        core_data_o    = 32'h1234CDEF; // Lower halfword is 0xCDEF
        #10;
        $display("[STORE - SH] Addr: %h | Data_in: %h | Mem_WD: %h (Exp: CDEFCDEF) | Byte_WE: %b (Exp: 1100)", 
                 core_address_o, core_data_o, mem_data_i, byte_write_i);

        // 3. Test Store Word (sw) at offset 0 (addr_lsb = 2'b00)
        op_size_o      = 3'b010; // sw
        core_address_o = 32'h10010000; 
        core_data_o    = 32'h12345678; 
        #10;
        $display("[STORE - SW] Addr: %h | Data_in: %h | Mem_WD: %h (Exp: 12345678) | Byte_WE: %b (Exp: 1111)", 
                 core_address_o, core_data_o, mem_data_i, byte_write_i);

        mem_data_o = 32'h89AB4321;

        // 4. Test Load Word (lw)
        op_size_o      = 3'b010; // lw
        core_address_o = 32'h10010000; 
        #10;
        $display("[LOAD - LW]  Mem_RD: %h | Core_RD: %h (Exp: 89AB4321)", mem_data_o, core_data_i);

        // 5. Test Load Byte Signed (lb) - targeting Byte 3 (0x89, sign-extended)
        op_size_o      = 3'b000; // lb
        core_address_o = 32'h10010003; // addr_lsb = 2'b11 (Byte 3)
        #10;
        $display("[LOAD - LB]  Mem_RD: %h | Core_RD: %h (Exp: FFFFFF89)", mem_data_o, core_data_i);

        // 6. Test Load Byte Unsigned (lbu) - targeting Byte 3 (0x89, zero-extended)
        op_size_o      = 3'b100; // lbu
        core_address_o = 32'h10010003; // addr_lsb = 2'b11 (Byte 3)
        #10;
        $display("[LOAD - LBU] Mem_RD: %h | Core_RD: %h (Exp: 00000089)", mem_data_o, core_data_i);

        // 7. Test Load Halfword Signed (lh) - targeting upper Halfword (0x89AB, sign-extended)
        op_size_o      = 3'b001; // lh
        core_address_o = 32'h10010002; // addr_lsb = 2'b10 (Upper halfword)
        #10;
        $display("[LOAD - LH]  Mem_RD: %h | Core_RD: %h (Exp: FFFF89AB)", mem_data_o, core_data_i);

        // 8. Test Load Halfword Unsigned (lhu) - targeting upper Halfword (0x89AB, zero-extended)
        op_size_o      = 3'b101; // lhu
        core_address_o = 32'h10010002; // addr_lsb = 2'b10 (Upper halfword)
        #10;
        $display("[LOAD - LHU] Mem_RD: %h | Core_RD: %h (Exp: 000089AB)", mem_data_o, core_data_i);

        $finish;
    end
endmodule