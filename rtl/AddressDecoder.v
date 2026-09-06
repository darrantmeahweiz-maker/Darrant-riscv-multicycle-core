module AddressDecoder (
    //LSU
    input  wire [31:0] address_i, 
    input  wire        we_i,      
    input  wire        oe_i,      
    input  wire [3:0]  bw_i,      

    //DMEM
    output wire [31:0] dmem_address_o, 
    output wire        dmem_we_o,
    output wire        dmem_oe_o,
    output wire [3:0]  dmem_bw_o,
    input  wire [31:0] dmem_data_i,  

    //IMEM
    output wire [31:0] imem_address_o,
    output wire        imem_oe_o,
    input  wire [31:0] imem_data_i,  

    //output
    output wire [31:0] data_o
);

    // IMEM: 0x00400000 ~ 0x007FFFFF (4MB)
    wire is_imem = (address_i >= 32'h00400000 && address_i < 32'h00800000);
    
    // DMEM: 0x10010000 ~ 0x10011FFF (8kB)
    wire is_dmem = (address_i >= 32'h10010000 && address_i < 32'h10012000);

    wire [31:0] aligned_address = {address_i[31:2], 2'b00};

    assign imem_address_o = aligned_address;
    assign imem_oe_o      = oe_i & is_imem; 

    assign dmem_address_o = aligned_address;
    assign dmem_we_o      = we_i & is_dmem; 
    assign dmem_oe_o      = oe_i & is_dmem;
    assign dmem_bw_o      = is_dmem ? bw_i : 4'b0000; 

    assign data_o = is_imem ? imem_data_i :
                    is_dmem ? dmem_data_i : 
                    32'h00000000; 

endmodule