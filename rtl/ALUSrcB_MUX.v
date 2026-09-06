module ALUSrcB_MUX (
  input [31:0] A, B,
  input [1:0] ALUSrcB,
  output reg [31:0] Z
);
  always @(*) begin
    case (ALUSrcB)
      2'b00: Z = A;//RegB
      2'b01: Z = B;//ImmExt
      2'b10: Z = 32'h4;//4
      default: Z = A;
    endcase
  end
endmodule