`timescale 1ns/1ps

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

module testbench;
    reg clk;
    reg rst;
    reg MUL_Enable;
    reg [3:0] MUL_Control;
    reg [31:0] i_A;
    reg [31:0] i_B;
    wire [31:0] MUL_Result;

    MUL uut(
        .clk(clk),.rst(rst),.MUL_Enable(MUL_Enable),.MUL_Control(MUL_Control),
        .i_A(i_A),.i_B(i_B),.MUL_Result(MUL_Result)
    );

    always #5 clk = ~clk;

    initial begin
        clk = 0; rst = 1; MUL_Enable = 0; MUL_Control = 4'h0;
        i_A = 32'h00000000; i_B = 32'h00000000;
        #20;

        rst = 0; #10;

        //test 1 MUL
        MUL_Enable = 1; MUL_Control = 4'h0;
        i_A = 32'hFFFFFFFF; i_B = 32'h00000005;
        #10; $display("TEST 1 --> MUL = %h (Expected: fffffffb)", MUL_Result);

        //test 2 MULH
        MUL_Enable = 1; MUL_Control = 4'h1;
        i_A = 32'h12345678; i_B = 32'h87654321;
        #10; $display("TEST 2 --> MULH = %h (Expected: f76c768d)", MUL_Result);

        //test 3 MULHSU
        MUL_Enable = 1; MUL_Control = 4'h2;
        i_A = 32'h82345678; i_B = 32'h87654321;
        #10; $display("TEST 3 --> MULHSU = %h (Expected: 44dd1a63)", MUL_Result);

        //test 4 MULHU
        MUL_Enable = 1; MUL_Control = 4'h3;
        i_A = 32'h12345678; i_B = 32'h87654321;
        #10; $display("TEST 4 --> MULHU = %h (Expected: 09a0cd05)", MUL_Result);
    end
endmodule