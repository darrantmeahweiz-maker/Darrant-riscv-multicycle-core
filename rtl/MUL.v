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