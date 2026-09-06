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