// ID_EX.v
module ID_EX(
	//TODO : Magic : For IF_ID.v : cannot write inst_o at PC=0. At PC=0, inst_o 	shall be 32'b0 , since 1st instruction is still in IF stage , and no one is in ID stage !! So IF_IF.inst_o shall be 32'b0 at that time !!
	// 1. Method For Fixing : Utilize the signal `start_i` of CPU.v . 
	start_i,

	clk_i,
	funct_i, // {funct7, funct3}
	funct_o, // {funct7, funct3}
	ALUOp_i,
	ALUOp_o,
	ALUSrc_i,
	ALUSrc_o,
	
	imm_i,
	imm_o,	
	
	MemRead_i,
	MemRead_o,
	MemWrite_i,
	MemWrite_o,
	RegWrite_i,
	RegWrite_o,
	MemtoReg_i,
	MemtoReg_o,
	// register data
	RS_Data1_i,
	RS_Data1_o,
	RS_Data2_i,
	RS_Data2_o,
	// register addr
	RS1addr_i,
	RS1addr_o,
	RS2addr_i,
	RS2addr_o,
	RDaddr_i,
	RDaddr_o
);
//TODO : Magic : For IF_ID.v : cannot write inst_o at PC=0. At PC=0, inst_o 	shall be 32'b0 , since 1st instruction is still in IF stage , and no one is in ID stage !! So IF_IF.inst_o shall be 32'b0 at that time !!
	// 1. Method For Fixing : Utilize the signal `start_i` of CPU.v . 
input start_i;

// write at posedge clock
input clk_i;
//TODO instruction or funct7 + funct3
input [9:0] funct_i; // {funct7, funct3}
//output reg [9:0] funct_o; // {funct7, funct3}
output reg [9:0] funct_o; // = 10'b0; // {funct7, funct3}
// EX stage
input [1:0] ALUOp_i;
//output reg [1:0] ALUOp_o;
output reg [1:0] ALUOp_o; // = 2'b0;
input ALUSrc_i;
//output reg ALUSrc_o;
output reg ALUSrc_o; // = 1'b0;
// imm in EX stage
input [31:0] imm_i;
//output reg [31:0] imm_o;
output reg [31:0] imm_o; // = 32'b0;
// MEM stage
input MemRead_i;
//output reg MemRead_o;
output reg MemRead_o; // = 1'b0;
input MemWrite_i;
//output reg MemWrite_o;
output reg MemWrite_o; // = 1'b0;
// WB stage
input RegWrite_i;
//output reg RegWrite_o;
output reg RegWrite_o; // = 1'b0;
input MemtoReg_i;
//output reg MemtoReg_o;
output reg MemtoReg_o; // = 1'b0;
// register data
input [31:0] RS_Data1_i;
//output reg [31:0] RS_Data1_o;
output reg [31:0] RS_Data1_o; // = 32'b0;
input [31:0] RS_Data2_i;
//output reg [31:0] RS_Data2_o;
output reg [31:0] RS_Data2_o; // = 32'b0;
// register addr
input [4:0] RS1addr_i;
//output reg [4:0] RS1addr_o;
output reg [4:0] RS1addr_o; // = 5'b0;
input [4:0] RS2addr_i;
//output reg [4:0] RS2addr_o;
output reg [4:0] RS2addr_o; // = 5'b0;
input [4:0] RDaddr_i;
//output reg [4:0] RDaddr_o;
output reg [4:0] RDaddr_o; // = 5'b0;

//TODO : initialize reg in initial
initial begin
	funct_o = 10'b0; // {funct7, funct3}
	// EX stage
	//output reg [1:0] ALUOp_o;
	ALUOp_o = 2'b0;
	//output reg ALUSrc_o;
	ALUSrc_o = 1'b0;
	// imm in EX stage
	//output reg [31:0] imm_o;
	imm_o = 32'b0;
	// MEM stage
	//output reg MemRead_o;
	MemRead_o = 1'b0;
	//output reg MemWrite_o;
	MemWrite_o = 1'b0;
	// WB stage
	//output reg RegWrite_o;
	RegWrite_o = 1'b0;
	//output reg MemtoReg_o;
	MemtoReg_o = 1'b0;
	// register data
	//output reg [31:0] RS_Data1_o;
	RS_Data1_o = 32'b0;
	//output reg [31:0] RS_Data2_o;
	RS_Data2_o = 32'b0;
	// register addr
	//output reg [4:0] RS1addr_o;
	RS1addr_o = 5'b0;
	//output reg [4:0] RS2addr_o;
	RS2addr_o = 5'b0;
	//output reg [4:0] RDaddr_o;
	RDaddr_o = 5'b0;
end

/*
// magic 
//TODO instruction or funct7 + funct3
reg [9:0] funct_o_reg; // {funct7, funct3}
// EX stage
reg [1:0] ALUOp_o_reg;
reg ALUSrc_o_reg;
// MEM stage
reg MemRead_o_reg;
reg MemWrite_o_reg;
// WB stage
reg RegWrite_o_reg;
reg MemtoReg_o_reg;
// register data
reg [31:0] RS_Data1_o_reg;
reg [31:0] RS_Data2_o_reg;
// register addr
reg [4:0] RS1addr_o_reg;
reg [4:0] RS2addr_o_reg;
reg [4:0] RDaddr_o_reg;
*/

//always @(posedge clk_i)
//always @(posedge clk_i or negedge clk_i) //TODO : changed : fixed : (1) PC=24 stalls (2) x6=10 at PC=24 , not at PC=20 (same as output_ref.txt)
always @(posedge clk_i)
begin
	//TODO : Magic : For IF_ID.v : cannot write inst_o at PC=0. At PC=0, inst_o 	shall be 32'b0 , since 1st instruction is still in IF stage , and no one is in ID stage !! So IF_IF.inst_o shall be 32'b0 at that time !!
	// 1. Method For Fixing : Utilize the signal `start_i` of CPU.v . 
	if(start_i) begin
	
		funct_o <= funct_i;
		ALUOp_o <= ALUOp_i;
		ALUSrc_o <= ALUSrc_i;
		// imm in EX stage
		imm_o <= imm_i;

		MemRead_o <= MemRead_i;
		MemWrite_o <= MemWrite_i;
		RegWrite_o <= RegWrite_i;
		MemtoReg_o <= MemtoReg_i;
		// register data
		RS_Data1_o <= RS_Data1_i;
		RS_Data2_o <= RS_Data2_i;
		// register addr
		RS1addr_o <= RS1addr_i;
		RS2addr_o <= RS2addr_i;
		RDaddr_o <= RDaddr_i;
	
       /*
       // magic 
       if(clk_i) 
       begin
	       funct_o_reg <= funct_i;
	       ALUOp_o_reg <= ALUOp_i;
	       ALUSrc_o_reg <= ALUSrc_i;
	       MemRead_o_reg <= MemRead_i;
	       MemWrite_o_reg <= MemWrite_i;
	       RegWrite_o_reg <= RegWrite_i;
	       MemtoReg_o_reg <= MemtoReg_i;
	       // register data
	       RS_Data1_o_reg <= RS_Data1_i;
	       RS_Data2_o_reg <= RS_Data2_i;
	       // register addr
	       RS1addr_o_reg <= RS1addr_i;
	       RS2addr_o_reg <= RS2addr_i;
	       RDaddr_o_reg <= RDaddr_i;
       end

       // magic 
       if(!clk_i)
       begin
	       funct_o <= funct_o_reg;
	       ALUOp_o <= ALUOp_o_reg;
	       ALUSrc_o <= ALUSrc_o_reg;
	       MemRead_o <= MemRead_o_reg;
	       MemWrite_o <= MemWrite_o_reg;
	       RegWrite_o <= RegWrite_o_reg;
	       MemtoReg_o <= MemtoReg_o_reg;
	       // register data
	       RS_Data1_o <= RS_Data1_o_reg;
	       RS_Data2_o <= RS_Data2_o_reg;
	       // register addr
	       RS1addr_o <= RS1addr_o_reg;
	       RS2addr_o <= RS2addr_o_reg;
	       RDaddr_o <= RDaddr_o_reg;
       end
		*/
	end
end

endmodule

