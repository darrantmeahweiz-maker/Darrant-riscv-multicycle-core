`timescale 1ns/1ps

// ==============================================================================
//  MODULE     : CRC Co-Processor
//  DESCRIPTION: Hardware-accelerated Cyclic Redundancy Check (CRC-8, 16, 32)
// ==============================================================================
module CRC(
    input wire clk,
    input wire rst,
    input wire CRC_Enable,
    input wire [3:0] CRC_Control,
    input wire [31:0] i_A,
    input wire [31:0] i_B, 
    output reg [31:0] CRC_Result
);

    // -----------------------------------------------------------------
    // Function: CRC-8 Calculation (Polynomial: 8'h07 - x^8 + x^2 + x + 1)
    // -----------------------------------------------------------------
    function [7:0] CRC8 (input [31:0] data, input [31:0] seed);
        reg [7:0] crc;
        integer i;
        begin
            crc = seed[7:0];
            for (i = 31; i >= 0; i = i - 1) begin
                if (crc[7] ^ data[i]) begin
                    crc = (crc << 1) ^ 8'h07;
                end else begin
                    crc = crc << 1;
                end
            end
            CRC8 = crc;
        end
    endfunction

    // -----------------------------------------------------------------
    // Function: CRC-16 Calculation (Polynomial: 16'h8005 - CCITT/IBM standard)
    // -----------------------------------------------------------------
    function [15:0] CRC16 (input [31:0] data, input [31:0] seed);
        reg [15:0] crc;
        integer i;
        begin
            crc = seed[15:0];
            for (i = 31; i >= 0; i = i - 1) begin
                if (crc[15] ^ data[i]) begin
                    crc = (crc << 1) ^ 16'h8005;
                end else begin
                    crc = crc << 1;
                end
            end
            CRC16 = crc;
        end
    endfunction

    // -----------------------------------------------------------------
    // Function: CRC-32 Calculation (Polynomial: 32'h04C11DB7 - IEEE 802.3)
    // -----------------------------------------------------------------
    function [31:0] CRC32 (input [31:0] data, input [31:0] seed);
        reg [31:0] crc;
        integer i;
        begin
            crc = seed;
            for (i = 31; i >= 0; i = i - 1) begin
                if (crc[31] ^ data[i]) begin
                    crc = (crc << 1) ^ 32'h04C11DB7;
                end else begin
                    crc = crc << 1;
                end
            end
            CRC32 = crc;
        end
    endfunction

    // Parallel instantiation of three independent calculation datapaths
    wire [7:0]  crc8_out;
    wire [15:0] crc16_out;
    wire [31:0] crc32_out;

    assign crc8_out  = CRC8(i_A, i_B);  // Process CRC-8
    assign crc16_out = CRC16(i_A, i_B); // Process CRC-16
    assign crc32_out = CRC32(i_A, i_B); // Process CRC-32

    // Multiplexer to select active CRC operation result
    always @(*) begin
        if (CRC_Enable == 0) begin
            CRC_Result = 32'h00000000; // Output zero when disabled
        end else begin 
            case (CRC_Control)
                4'h0:    CRC_Result = {24'h000000, crc8_out}; // CRC-8
                4'h1:    CRC_Result = {16'h0000, crc16_out};  // CRC-16
                4'h2:    CRC_Result = crc32_out;              // CRC-32
                default: CRC_Result = 32'h00000000;
            endcase
        end
    end
endmodule

// ==============================================================================
//  MODULE     : testbench (CRC IP Unit Test)
//  DESCRIPTION: Rigorous verification environment for CRC accelerator
// ==============================================================================
module testbench;
    reg clk;
    reg rst;
    reg CRC_Enable;
    reg [3:0] CRC_Control;
    reg [31:0] i_A;
    reg [31:0] i_B;
    wire [31:0] CRC_Result;

    CRC uut(
        .clk(clk),
        .rst(rst),
        .CRC_Enable(CRC_Enable),
        .CRC_Control(CRC_Control),
        .i_A(i_A),
        .i_B(i_B),
        .CRC_Result(CRC_Result)
    );

    always #5 clk = ~clk; // 10ns clock period

    initial begin
        clk = 0; 
        rst = 1; 
        CRC_Enable = 0; 
        CRC_Control = 4'h0;
        i_A = 32'h00000000; 
        i_B = 32'h00000000;
        #20;

        rst = 0; 
        #10;

       // Test 1: CRC-8 Verification
        CRC_Enable = 1; 
        CRC_Control = 4'h0;
        i_A = 32'h000000AB; 
        i_B = 32'h00000000;
        #10; 
        $display("TEST 1 --> CRCB = %h (Expected: 00000058 - Pure HW Polynomial)", CRC_Result);

        // Test 2: CRC-16 Verification
        CRC_Enable = 1; 
        CRC_Control = 4'h1;
        i_A = 32'h0000ABCD; 
        i_B = 32'h00000000;
        #10; 
        $display("TEST 2 --> CRCH = %h (Expected: 0000f8a4 - Pure HW Polynomial)", CRC_Result);

        // Test 3: CRC-32 Verification
        CRC_Enable = 1; 
        CRC_Control = 4'h2;
        i_A = 32'hDEADBEEF; 
        i_B = 32'h00000000;
        #10; 
        $display("TEST 3 --> CRCW = %h (Expected: 46dec763 - Pure HW Polynomial)", CRC_Result);
        #20;
        $finish;
    end
endmodule