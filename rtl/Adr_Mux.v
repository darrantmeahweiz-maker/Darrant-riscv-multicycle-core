module Adr_Mux (
    input [31:0] A, B,
    input AdrSrc,
    output reg [31:0] Z
);
    always @(*) begin
        case (AdrSrc)
            1'b0: Z = A; //PC
            1'b1: Z = B; //Result
            default: Z = A;
        endcase
    end
endmodule