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