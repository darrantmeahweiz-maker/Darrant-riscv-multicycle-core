module DMEM2 (
    input  wire        clk_i,
    input  wire        we_i,    
    input  wire        oe_i,    
    input  wire [3:0]  bw_i,   
    input  wire [31:0] address_i,
    input  wire [31:0] data_i,
    output reg  [31:0] data_o
);
    
    reg [31:0] r_RAM [0:2047]; //8KB
  
  	integer i;
    initial begin
        for (i = 0; i < 2048; i = i + 1) begin
            r_RAM[i] = 32'h00000000;
        end
    end

  	wire [10:0] word_index = (address_i - 32'h10010000) >> 2;

    always @(posedge clk_i) begin
        if (we_i) begin
            r_RAM[word_index] <= {
                bw_i[3] ? data_i[31:24] : r_RAM[word_index][31:24],
                bw_i[2] ? data_i[23:16] : r_RAM[word_index][23:16],
                bw_i[1] ? data_i[15:8]  : r_RAM[word_index][15:8],
                bw_i[0] ? data_i[7:0]   : r_RAM[word_index][7:0]
            };
        end
    end
    always @(*) begin
        if (oe_i) begin
            data_o = r_RAM[word_index];
        end else begin
            data_o = 32'h00000000;
        end
    end
endmodule