module RISC_V_Multicycle_Control_Unit (
    input clk, rst,
    input [6:0] op,
    input [2:0] funct3,
    input [6:0] funct7,
    input Zero,
    output reg PCWrite, AdrSrc, MemWrite, IRWrite, RegWrite, MemRead,
    output reg [1:0] ResultSrc, ALUSrcA, ALUSrcB, ExtSel,
	output reg [2:0] ImmSrc,
    output reg [3:0] ALUControl,
    output reg Mul_Enable, CRC_Enable,
	output reg [3:0] Mul_Control, CRC_Control
);

// Main FSM states
localparam Fetch 	= 4'b0000;
localparam Decode 	= 4'b0001;
localparam MemAdr 	= 4'b0010;
localparam MEMRead 	= 4'b0011;
localparam MemWB 	= 4'b0100;
localparam MEMWrite = 4'b0101;
localparam ExecuteR = 4'b0110;
localparam AluWB 	= 4'b0111;
localparam Branch 	= 4'b1000;
localparam ExecuteJ_1	= 4'b1001;
localparam ExecuteU = 4'b1010;
localparam Halt 	= 4'b1011;
localparam ExecuteJ_2	= 4'b1100;

reg [3:0] state_reg, state_next;

always @ (posedge clk or posedge rst)
begin
    if (rst)
        state_reg <= Fetch;
    else
        state_reg <= state_next;
end

always @ (*)
begin
	PCWrite = 1'b0; AdrSrc =1'b0; MemWrite =1'b0;  IRWrite = 1'b0; MemRead =1'b0;
	RegWrite = 1'b0; ALUSrcA = 2'b00; ALUSrcB = 2'b00; ResultSrc = 2'b00; ExtSel = 2'b00;
	ALUControl = 4'b0000; 
	Mul_Enable = 1'b0; CRC_Enable = 1'b0; 
	Mul_Control = 4'h0; CRC_Control = 4'h0;
	state_next = state_reg;
	case (op)
        7'b0100011: ImmSrc = 3'b001; // S-Type
        7'b1100011: ImmSrc = 3'b010; // B-Type
        7'b1101111: ImmSrc = 3'b011; // J-Type
        7'b0110111, 7'b0010111: ImmSrc = 3'b100; // U-Type
        default:    ImmSrc = 3'b000; // I-Type, R-Type
   	endcase

    case(state_reg)
        Fetch:
            begin
                // logic for Fetch (RegWrite = 0; MemWrite = 0;)
				PCWrite = 1'b1; AdrSrc = 1'b0; IRWrite =  1'b1; ImmSrc = 3'b000; MemRead =1'b1;
				ALUSrcA = 2'b00; ALUSrcB = 2'b10; ALUControl = 4'h1;
				ResultSrc = 2'b10;
				state_next = Decode;
            end
		Decode:
            begin
                // State logic for Decode
				ALUSrcA = 2'b00; ALUSrcB = 2'b10; ALUControl = 4'h1;
				case (op)
					7'b0110011: begin //R-Type
						state_next = ExecuteR;
					end
					7'b0010011: begin //I-Type (addi ...)
						state_next = ExecuteR;
					end
					7'b0000011: begin //I-Type (load)
						state_next = MemAdr;
					end
					7'b0100011: begin //S-Type
						state_next = MemAdr;
					end
					7'b1100011: begin //B-Type
						state_next = Branch;
					end
					7'b1101111: begin //J-type (jal)
						state_next = ExecuteJ_1;
					end
					7'b1100111: begin //I-type (jalr)
						state_next = ExecuteJ_1;
					end
					7'b0110111, 7'b0010111: begin // U-Type
						state_next = ExecuteU;
					end	
					7'b1110011: begin //system (ecall & ebreak)
						state_next = Halt;
					end
					7'b0001111: begin //Fench
						state_next = Fetch;
					end
					default: begin
						state_next = Fetch;
					end
				endcase
            end
		ExecuteR: 
			
			begin
				ALUSrcA = 2'b10; //both same
				if (op == 7'b0110011) begin
					//R-type (normal arithmetic)
					ALUSrcB = 2'b00; 

						//R-type multiplier
						if (funct7==7'b0000001) begin
							Mul_Enable = 1'b1;
							Mul_Control = {1'b0,funct3};
							ExtSel = 2'b01;

						//R-type CRC
						end else if (funct7==7'b1000000) begin
							CRC_Enable = 1'b1;
							CRC_Control = {1'b0,funct3};
							ExtSel = 2'b10;
						end

				end else begin
					//i-type (normal arithmetic)
					ALUSrcB = 2'b01; 
				end
			
			if ((Mul_Enable == 0) && (CRC_Enable==0)) begin
				case(funct3)
					3'b000: begin
						if ((op==7'b0110011) && (funct7==7'b0100000)) begin
							ALUControl = 4'h2; //sub (no subi option)
						end else begin
							ALUControl = 4'h1; //add & addi
						end
					end
					3'b001: begin
						ALUControl = 4'h6; //sll & slli
					end
					3'b010: begin
						ALUControl = 4'h9; //slt & slti
					end
					3'b011: begin
						ALUControl = 4'hA; //sltu & sltiu
					end
					3'b100: begin
						ALUControl = 4'h5; //xor & xori
					end
					3'b101: begin
						if (funct7 ==7'b0100000) begin
						ALUControl = 4'h8; //sra & srai
						end else begin
						ALUControl = 4'h7; //srl & srli
						end
					end
					3'b110: begin
						ALUControl = 4'h4; //or & ori
					end
					3'b111: begin
						ALUControl = 4'h3; //and & andi
					end
					default: begin
						ALUControl = 4'h0;
					end
				endcase	
				end
				state_next = AluWB;				
			end
		MemAdr:
            begin
			ALUSrcA = 2'b10; ALUSrcB = 2'b01; ALUControl = 4'h1;
                case (op)
					7'b0000011: begin
						state_next = MEMRead;
					end
					7'b0100011: begin
						state_next = MEMWrite;
					end
					default: begin
						state_next = Fetch;
					end
				endcase		
            end
		MEMRead:
			begin
				ResultSrc = 2'b00; AdrSrc = 1'b1; MemRead = 1'b1;
				state_next = MemWB;
			end
		MEMWrite:
			begin
				ResultSrc = 2'b00; AdrSrc = 1'b1; MemWrite = 1'b1;
				state_next = Fetch;
			end
		MemWB:
			begin 
				ResultSrc = 2'b01; RegWrite = 1'b1;
				state_next = Fetch;
			end
        AluWB:
			begin
				ResultSrc = 2'b00; RegWrite = 1'b1;
				state_next = Fetch;
			end
		Branch:
			begin
				ALUSrcA = 2'b10; ALUSrcB = 2'b00;
				ResultSrc = 2'b00;

				case (funct3)
				3'b000: begin //beq ==
					ALUControl = 4'h2; //c_ALU_OP_SUB
					if (Zero == 1'b1) PCWrite = 1'b1;
				end
				3'b001: begin //bne !=
					ALUControl = 4'h2; //c_ALU_OP_SUB
					if (Zero == 1'b0) PCWrite = 1'b1;
				end
				3'b100: begin //blt <
					ALUControl = 4'h9; //c_ALU_OP_SLT
					if (Zero == 1'b0) PCWrite = 1'b1;
				end
				3'b101: begin //bge >=
					ALUControl = 4'h9; //c_ALU_OP_SLT
					if (Zero == 1'b1) PCWrite = 1'b1;
				end
				3'b110: begin //bltu <
					ALUControl = 4'hA; //c_ALU_OP_SLTU
					if (Zero == 1'b0) PCWrite = 1'b1;
				end
				3'b111: begin //bgeu >=
					ALUControl = 4'hA; //c_ALU_OP_SLTU
					if (Zero == 1'b1) PCWrite = 1'b1;
				end
				default: begin
					state_next = Fetch;
				end
			endcase
			state_next = Fetch;
			end
		ExecuteJ_1: begin
			ALUSrcA = 2'b01; //OldPC
			ALUSrcB = 2'b10; //4
			ALUControl = 4'h1; //add
			ResultSrc = 2'b10; //OldPC + 4
			RegWrite = 1'b1; //rd
			state_next = ExecuteJ_2;
		end
		ExecuteJ_2: begin
			if (op == 7'b1101111) begin
				ALUSrcA = 2'b01; //oldPC & JAL
			end else begin
				ALUSrcA = 2'b10; //RegA & JALR
			end
			ALUSrcB = 2'b01; //im
			ALUControl = 4'h1; //add
			ResultSrc = 2'b10;
			PCWrite = 1'b1;
			state_next = Fetch;
		end
		ExecuteU: begin
			if (op == 7'b0110111) begin
				ALUSrcA = 2'b11;//nothing
			end else begin
				ALUSrcA = 2'b01;//oldPC
			end
			ALUSrcB = 2'b01; //im
			ALUControl = 4'h1; //add
			ResultSrc = 2'b00;
			state_next = AluWB;
		end
		Halt: begin
			state_next = Halt;
		end
        default:
            begin
                state_next = Fetch;
            end 
    	endcase
	end 
endmodule