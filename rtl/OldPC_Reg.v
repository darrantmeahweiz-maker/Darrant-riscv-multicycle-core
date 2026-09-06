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