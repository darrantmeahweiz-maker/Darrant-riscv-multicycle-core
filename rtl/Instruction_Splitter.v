module Instruction_Splitter (
    input  wire [31:0] Instr_i,      

    output wire [6:0]  op_o,          
    output wire [2:0]  funct3_o,      
    output wire [6:0]  funct7_o,      
    output wire [24:0] Instr_31_7_o,  
    output wire [2:0]  op_size_o      
);

    
    assign op_o         = Instr_i[6:0];
    assign funct3_o     = Instr_i[14:12];
    assign funct7_o     = Instr_i[31:25];
    assign Instr_31_7_o = Instr_i[31:7];
    assign op_size_o    = Instr_i[14:12]; 

endmodule