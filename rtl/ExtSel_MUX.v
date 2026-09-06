module ExtSel_MUX (
    input wire [31:0] ALU_Result, 
    input wire [31:0] MUL_Result, 
    input wire [31:0] CRC_Result, 
    
    input wire [1:0]  ExtSel,     
    
    output reg [31:0] Z
);

    always @(*) begin
        case (ExtSel)
            2'b00: Z = ALU_Result; 
            2'b01: Z = MUL_Result; 
            2'b10: Z = CRC_Result; 
            default: Z = ALU_Result;
        endcase
    end

endmodule