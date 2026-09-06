module ResultSrc_MUX (
  input [31:0] A, B, C,
  input [1:0] ResultSrc,
  output reg [31:0] Z
);
  always @(*) begin
    case (ResultSrc)
      2'b00: Z = A;//ALUOut
      2'b01: Z = B;//ReadData
      2'b10: Z = C;//ALUResut
      default: Z = A;
    endcase
  end
endmodule