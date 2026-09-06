`timescale 1ns / 1ps

module ALU (
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


module testbench;
    reg  [31:0] tb_i_A;
    reg  [31:0] tb_i_B;
    reg  [3:0]  tb_i_Sel;
    wire [31:0] tb_o_Q;
    wire        tb_o_Zero;

    ALU uut (
        .i_A(tb_i_A),.i_B(tb_i_B),.i_Sel(tb_i_Sel),.o_Q(tb_o_Q),.o_Zero(tb_o_Zero)
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
 

    initial begin
        tb_i_A = 32'd0;
        tb_i_B = 32'd0;
        tb_i_Sel = c_ALU_OP_PASS;
        #10;
        
//test 1 PASS
        tb_i_A = 32'd15; tb_i_B = 32'd10; tb_i_Sel = c_ALU_OP_PASS;
        #10;$display("PASS:  %0d, %0d = %0d (Expected: 10)", tb_i_A, tb_i_B, tb_o_Q);

        //test 2 ADD
        tb_i_A = 32'd15; tb_i_B = 32'd10; tb_i_Sel = c_ALU_OP_ADD;
        #10;$display("ADD:  %0d + %0d = %0d (Expected: 25)", tb_i_A, tb_i_B, tb_o_Q);

        //test 3 SUB
        tb_i_A = 32'd20; tb_i_B = 32'd20; tb_i_Sel = c_ALU_OP_SUB;
        #10;$display("SUB:  %0d - %0d = %0d | Zero = %b (Expected Q: 0, Zero: 1)", tb_i_A, tb_i_B, tb_o_Q, tb_o_Zero);

        //test 4 AND
        tb_i_A = 32'hF0F0F0F0; tb_i_B = 32'h0FF00FF0; tb_i_Sel = c_ALU_OP_AND;
        #10;$display("AND:  %h & %h = %h (Expected: 00F000F0)", tb_i_A, tb_i_B, tb_o_Q);

        //test 5 OR
        tb_i_A = 32'hF0F0F0F0; tb_i_B = 32'h0FF00FF0; tb_i_Sel = c_ALU_OP_OR;
        #10;$display("OR:   %h | %h = %h (Expected: FFF0FFF0)", tb_i_A, tb_i_B, tb_o_Q);

        //test 6 XOR
        tb_i_A = 32'hF0F0F0F0; tb_i_B = 32'h0FF00FF0; tb_i_Sel = c_ALU_OP_XOR;
        #10;$display("XOR:  %h ^ %h = %h (Expected: FF00FF00)", tb_i_A, tb_i_B, tb_o_Q);

        //test 7 SLL
        tb_i_A = 32'h00000001; tb_i_B = 32'd2; tb_i_Sel = c_ALU_OP_SLL;
        #10;$display("SLL:  %h << %0d = %h (Expected: 00000004)", tb_i_A, tb_i_B, tb_o_Q);

        //test 8 SRL
        tb_i_A = 32'h80000000; tb_i_B = 32'd1; tb_i_Sel = c_ALU_OP_SRL;
        #10;$display("SRL:  %h >> %0d = %h (Expected: 40000000)", tb_i_A, tb_i_B, tb_o_Q);

        //test 9 SRA
        tb_i_A = 32'h80000000; tb_i_B = 32'd1; tb_i_Sel = c_ALU_OP_SRA;
        #10;$display("SRA:  %h >>> %0d = %h (Expected: C0000000)", tb_i_A, tb_i_B, tb_o_Q);

        //test 10 SLT
        tb_i_A = -32'd5; tb_i_B = 32'd3; tb_i_Sel = c_ALU_OP_SLT;
        #10;$display("SLT:  %0d < %0d = %0d (Expected: 1)", $signed(tb_i_A), tb_i_B, tb_o_Q);

        //test 11 SLTU
        tb_i_A = 32'hFFFFFFFF; tb_i_B = 32'd1; tb_i_Sel = c_ALU_OP_SLTU;
        #10;$display("SLTU: %h < %h (unsigned) = %0d (Expected: 0)", tb_i_A, tb_i_B, tb_o_Q);
        
        $finish;
    end

endmodule