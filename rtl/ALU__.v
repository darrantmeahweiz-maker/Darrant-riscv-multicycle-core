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