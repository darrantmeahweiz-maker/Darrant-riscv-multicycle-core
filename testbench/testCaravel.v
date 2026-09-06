 entrou module top ( ---( 
 module 
  --- 
  
   input wire clk_i, ---inputwireclk_i, 
 clk_i 
   input wire rst_i ---inputwirerst_i 
 rst_i 
  --- 
  
 ); --- 
 ); 
  --- 
  
 //Internal Wires --- 
 //Internal 
  wire [31:0] w_1; ---[31:0]w_1; 
  
  wire w_2; ---w_2; 
  
  wire w_3; ---w_3; 
  
  wire [3:0] w_4; ---[3:0]w_4; 
  
  wire [31:0] w_5; ---[31:0]w_5; 
  
  wire [31:0] w_6; ---[31:0]w_6; 
  
  wire [31:0] w_7; ---[31:0]w_7; 
  
  wire w_8; ---w_8; 
  
  wire w_9; ---w_9; 
  
  wire [3:0] w_10; ---[3:0]w_10; 
  
  wire [31:0] w_11; ---[31:0]w_11; 
  
  wire w_12; ---w_12; 
  
  wire [31:0] w_13; ---[31:0]w_13; 
  
  wire [31:0] w_15; ---[31:0]w_15; 
  
  wire [31:0] w_16; ---[31:0]w_16; 
  
  wire [2:0] w_17; ---[2:0]w_17; 
  
  wire [31:0] w_18; ---[31:0]w_18; 
  
  wire [31:0] w_19; ---[31:0]w_19; 
  
  wire [31:0] w_20; ---[31:0]w_20; 
  
  wire [31:0] w_21; ---[31:0]w_21; 
  
  wire w_22; ---w_22; 
  
  wire [31:0] w_23; ---[31:0]w_23; 
  
  wire [31:0] w_24; ---[31:0]w_24; 
  
  wire [31:0] w_25; ---[31:0]w_25; 
  
  wire w_27; ---w_27; 
  
  wire [31:0] w_30; ---[31:0]w_30; 
  
  wire [31:0] w_31; ---[31:0]w_31; 
  
  wire [31:0] w_32; ---[31:0]w_32; 
  
  wire [1:0] w_33; ---[1:0]w_33; 
  
  wire [31:0] w_34; ---[31:0]w_34; 
  
  wire [31:7] w_37; ---[31:7]w_37; 
  
  wire [2:0] w_38; ---[2:0]w_38; 
  
  wire w_41; ---w_41; 
  
  wire [31:0] w_42; ---[31:0]w_42; 
  
  wire [31:0] w_43; ---[31:0]w_43; 
  
  wire [31:0] w_44; ---[31:0]w_44; 
  
  wire [3:0] w_45; ---[3:0]w_45; 
  
  wire [31:0] w_46; ---[31:0]w_46; 
  
  wire w_47; ---w_47; 
  
  wire w_48; ---w_48; 
  
  wire [3:0] w_49; ---[3:0]w_49; 
  
  wire [31:0] w_51; ---[31:0]w_51; 
  
  wire w_52; ---w_52; 
  
  wire [3:0] w_53; ---[3:0]w_53; 
  
  wire [31:0] w_55; ---[31:0]w_55; 
  
  wire [1:0] w_56; ---[1:0]w_56; 
  
  wire [31:0] w_58; ---[31:0]w_58; 
  
  wire [1:0] w_59; ---[1:0]w_59; 
  
  wire [6:0] w_61; ---[6:0]w_61; 
  
  wire [2:0] w_62; ---[2:0]w_62; 
  
  wire [6:0] w_63; ---[6:0]w_63; 
  
  wire w_64; ---w_64; 
  
  wire [1:0] w_66; ---[1:0]w_66; 
  
  --- 
  
 //Instances of Modules ---Modules 
 //Instances 
 AddressDecoder blk4104_3 ( ---( 
 AddressDecoder 
          .address_i (w_1), --- 
  
          .we_i (w_2), --- 
  
          .oe_i (w_3), --- 
  
          .bw_i (w_4), --- 
  
          .dmem_data_i (w_5), --- 
  
          .imem_data_i (w_6), --- 
  
          .dmem_address_o (w_7), --- 
  
          .dmem_we_o (w_8), --- 
  
          .dmem_oe_o (w_9), --- 
  
          .dmem_bw_o (w_10), --- 
  
          .imem_address_o (w_11), --- 
  
          .imem_oe_o (w_12), --- 
  
          .data_o (w_13) --- 
  
      ); --- 
  
  --- 
  
 LSU blk4106_4 ( ---( 
 LSU 
          .mem_address_i (w_1), --- 
  
          .byte_write_i (w_4), --- 
  
          .mem_data_o (w_13), --- 
  
          .core_data_o (w_15), --- 
  
          .core_address_o (w_16), --- 
  
          .op_size_o (w_17), --- 
  
          .core_data_i (w_18), --- 
  
          .mem_data_i (w_19) --- 
  
      ); --- 
  
  --- 
  
 DMEM2 blk4102_14 ( ---( 
 DMEM2 
          .clk_i (clk_i), --- 
  
          .data_o (w_5), --- 
  
          .address_i (w_7), --- 
  
          .we_i (w_8), --- 
  
          .oe_i (w_9), --- 
  
          .bw_i (w_10), --- 
  
          .data_i (w_19) --- 
  
      ); --- 
  
  --- 
  
 Register_file #(.p_DATA_MEM_SIZE(2**10)) blk4114_15 ( ---blk4114_15( 
 Register_file 
          .i_Clk (clk_i), --- 
  
          .i_Rst (rst_i), --- 
  
          .i_Data_Rd (w_20), --- 
  
          .i_Instruction (w_21), --- 
  
          .RegWrite (w_22), --- 
  
          .o_Data_Rs_1 (w_23), --- 
  
          .o_Data_Rs_2 (w_24) --- 
  
      ); --- 
  
  --- 
  
 Reg_A blk4115_16 ( ---( 
 Reg_A 
          .clk (clk_i), --- 
  
          .reset (rst_i), --- 
  
          .i_data (w_23), --- 
  
          .o_data (w_25) --- 
  
      ); --- 
  
  --- 
  
 Reg_B blk4116_17 ( ---( 
 Reg_B 
          .clk (clk_i), --- 
  
          .reset (rst_i), --- 
  
          .o_data (w_15), --- 
  
          .i_data (w_24) --- 
  
      ); --- 
  
  --- 
  
 IR_Reg blk4117_18 ( ---( 
 IR_Reg 
          .clk (clk_i), --- 
  
          .reset (rst_i), --- 
  
          .i_data (w_13), --- 
  
          .o_data (w_21), --- 
  
          .IRWrite (w_27) --- 
  
      ); --- 
  
  --- 
  
 OldPC_Reg blk4118_19 ( ---( 
 OldPC_Reg 
          .clk (clk_i), --- 
  
          .reset (rst_i), --- 
  
          .IRWrite (w_27), --- 
  
          .i_data (w_30), --- 
  
          .o_data (w_31) --- 
  
      ); --- 
  
  --- 
  
 ALUSrcB_MUX blk4120_23 ( ---( 
 ALUSrcB_MUX 
          .A (w_15), --- 
  
          .B (w_32), --- 
  
          .ALUSrcB (w_33), --- 
  
          .Z (w_34) --- 
  
      ); --- 
  
  --- 
  
 extend blk4121_24 ( ---( 
 extend 
          .ImmExt (w_32), --- 
  
          .Instr (w_37), --- 
  
          .ImmSrc (w_38) --- 
  
      ); --- 
  
  --- 
  
 Adr_Mux blk4122_25 ( ---( 
 Adr_Mux 
          .Z (w_16), --- 
  
          .A (w_30), --- 
  
          .B (w_20), --- 
  
          .AdrSrc (w_41) --- 
  
      ); --- 
  
  --- 
  
 ALUOut_Reg blk4124_27 ( ---( 
 ALUOut_Reg 
          .clk (clk_i), --- 
  
          .reset (rst_i), --- 
  
          .i_data (w_42), --- 
  
          .o_data (w_43) --- 
  
      ); --- 
  
  --- 
  
 ALU__ blk4126_28 ( ---( 
 ALU__ 
          .i_B (w_34), --- 
  
          .i_A (w_44), --- 
  
          .i_Sel (w_45), --- 
  
          .o_Q (w_46), --- 
  
          .o_Zero (w_47) --- 
  
      ); --- 
  
  --- 
  
 MUL blk4128_30 ( ---( 
 MUL 
          .clk (clk_i), --- 
  
          .rst (rst_i), --- 
  
          .i_B (w_34), --- 
  
          .MUL_Enable (w_48), --- 
  
          .MUL_Control (w_49), --- 
  
          .i_A (w_44), --- 
  
          .MUL_Result (w_51) --- 
  
      ); --- 
  
  --- 
  
 CRC blk4127_31 ( ---( 
 CRC 
          .clk (clk_i), --- 
  
          .rst (rst_i), --- 
  
          .i_B (w_34), --- 
  
          .CRC_Enable (w_52), --- 
  
          .CRC_Control (w_53), --- 
  
          .i_A (w_44), --- 
  
          .CRC_Result (w_55) --- 
  
      ); --- 
  
  --- 
  
 ExtSel_MUX blk4130_32 ( ---( 
 ExtSel_MUX 
          .Z (w_42), --- 
  
          .ALU_Result (w_46), --- 
  
          .MUL_Result (w_51), --- 
  
          .CRC_Result (w_55), --- 
  
          .ExtSel (w_56) --- 
  
      ); --- 
  
  --- 
  
 ResultSrc_MUX blk4132_34 ( ---( 
 ResultSrc_MUX 
          .Z (w_20), --- 
  
          .A (w_43), --- 
  
          .C (w_42), --- 
  
          .B (w_58), --- 
  
          .ResultSrc (w_59) --- 
  
      ); --- 
  
  --- 
  
 Data_Reg blk4133_35 ( ---( 
 Data_Reg 
          .clk (clk_i), --- 
  
          .reset (rst_i), --- 
  
          .i_data (w_18), --- 
  
          .o_data (w_58) --- 
  
      ); --- 
  
  --- 
  
 Instruction_Splitter blk4136_37 ( ---( 
 Instruction_Splitter 
          .op_size_o (w_17), --- 
  
          .Instr_i (w_21), --- 
  
          .Instr_31_7_o (w_37), --- 
  
          .op_o (w_61), --- 
  
          .funct3_o (w_62), --- 
  
          .funct7_o (w_63) --- 
  
      ); --- 
  
  --- 
  
 PC_Reg blk4123_39 ( ---( 
 PC_Reg 
          .clk (clk_i), --- 
  
          .reset (rst_i), --- 
  
          .o_data (w_30), --- 
  
          .i_data (w_20), --- 
  
          .PCWrite (w_64) --- 
  
      ); --- 
  
  --- 
  
 ALUSrcA_MUX blk4119_53 ( ---( 
 ALUSrcA_MUX 
          .C (w_25), --- 
  
          .B (w_31), --- 
  
          .Z (w_44), --- 
  
          .A (w_30), --- 
  
          .ALUSrcA (w_66) --- 
  
      ); --- 
  
  --- 
  
 RISC_V_Multicycle_Control_Unit blk4134_55 ( ---( 
 RISC_V_Multicycle_Control_Unit 
          .clk (clk_i), --- 
  
          .rst (rst_i), --- 
  
          .MemWrite (w_2), --- 
  
          .MemRead (w_3), --- 
  
          .RegWrite (w_22), --- 
  
          .IRWrite (w_27), --- 
  
          .ALUSrcB (w_33), --- 
  
          .ImmSrc (w_38), --- 
  
          .AdrSrc (w_41), --- 
  
          .ALUControl (w_45), --- 
  
          .Zero (w_47), --- 
  
          .Mul_Enable (w_48), --- 
  
          .Mul_Control (w_49), --- 
  
          .CRC_Enable (w_52), --- 
  
          .CRC_Control (w_53), --- 
  
          .ExtSel (w_56), --- 
  
          .ResultSrc (w_59), --- 
  
          .op (w_61), --- 
  
          .funct3 (w_62), --- 
  
          .funct7 (w_63), --- 
  
          .PCWrite (w_64), --- 
  
          .ALUSrcA (w_66) --- 
  
      ); --- 
  
  --- 
  
 IMEM2 blk4101_59 ( ---( 
 IMEM2 
          .o_Instruction (w_6), --- 
  
          .i_Address (w_11), --- 
  
          .oe_i (w_12) --- 
  
      ); --- 
  
  --- 
  
  --- 
  
 endmodule --- 
 endmodule 
  --- 
  
