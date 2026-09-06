module LSU (
    // RISC_V Datapath side
    input  wire [31:0] core_data_o,     //Store
    input  wire [31:0] core_address_o,  //Address
    input  wire [2:0]  op_size_o,       //funct3
    output reg  [31:0] core_data_i,     //Load

    // Memory system side
    output wire [31:0] mem_address_i,  
    output reg  [31:0] mem_data_i,     
    output reg  [3:0]  byte_write_i,  
    input  wire [31:0] mem_data_o
);

    assign mem_address_i = core_address_o;

    wire [1:0] addr_lsb = core_address_o[1:0];

    always @(*) begin
        case (op_size_o)
            3'b000: begin // sb (Store Byte)
                mem_data_i = {4{core_data_o[7:0]}}; 
                byte_write_i = (4'b0001 << addr_lsb); 
            end
            3'b001: begin // sh (Store Halfword)
                mem_data_i = {2{core_data_o[15:0]}}; 
                byte_write_i = addr_lsb[1] ? 4'b1100 : 4'b0011;
            end
            3'b010: begin // sw (Store Word)
                mem_data_i = core_data_o;
                byte_write_i = 4'b1111;
            end
            default: begin
                mem_data_i = 32'b0;
                byte_write_i = 4'b0000;
            end
        endcase
    end

    always @(*) begin
        case (op_size_o)
            3'b000: begin // lb (Load Byte)
                case (addr_lsb)
                    2'b00: core_data_i = {{24{mem_data_o[7]}},  mem_data_o[7:0]};
                    2'b01: core_data_i = {{24{mem_data_o[15]}}, mem_data_o[15:8]};
                    2'b10: core_data_i = {{24{mem_data_o[23]}}, mem_data_o[23:16]};
                    2'b11: core_data_i = {{24{mem_data_o[31]}}, mem_data_o[31:24]};
                endcase
            end
            3'b100: begin // lbu (Load Byte Unsigned)
                case (addr_lsb)
                    2'b00: core_data_i = {24'b0, mem_data_o[7:0]};
                    2'b01: core_data_i = {24'b0, mem_data_o[15:8]};
                    2'b10: core_data_i = {24'b0, mem_data_o[23:16]};
                    2'b11: core_data_i = {24'b0, mem_data_o[31:24]};
                endcase
            end
            3'b001: begin // lh (Load Halfword)
                if (addr_lsb[1]) core_data_i = {{16{mem_data_o[31]}}, mem_data_o[31:16]};
                else             core_data_i = {{16{mem_data_o[15]}}, mem_data_o[15:0]};
            end
            3'b101: begin // lhu (Load Halfword Unsigned)
                if (addr_lsb[1]) core_data_i = {16'b0, mem_data_o[31:16]};
                else             core_data_i = {16'b0, mem_data_o[15:0]};
            end
            3'b010: begin // lw (Load Word)
                core_data_i = mem_data_o;
            end
            default: core_data_i = 32'b0;
        endcase
    end
endmodule