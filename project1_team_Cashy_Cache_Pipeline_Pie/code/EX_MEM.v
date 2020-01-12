// EX_MEM.v
module EX_MEM(
	//TODO : Magic : For IF_ID.v : cannot write inst_o at PC=0. At PC=0, inst_o 	shall be 32'b0 , since 1st instruction is still in IF stage , and no one is in ID stage !! So IF_IF.inst_o shall be 32'b0 at that time !!
	// 1. Method For Fixing : Utilize the signal `start_i` of CPU.v . 
	start_i,

	clk_i,
	MemRead_i,
	MemRead_o,
	MemWrite_i,
	MemWrite_o,

	ALU_Result_i,
	ALU_Result_o,

	RegWrite_i,
	RegWrite_o,
	MemtoReg_i,
	MemtoReg_o,

	RS_Data2_i,
	RS_Data2_o,

	RDaddr_i,
	RDaddr_o
);
//TODO : Magic : For IF_ID.v : cannot write inst_o at PC=0. At PC=0, inst_o 	shall be 32'b0 , since 1st instruction is still in IF stage , and no one is in ID stage !! So IF_IF.inst_o shall be 32'b0 at that time !!
// 1. Method For Fixing : Utilize the signal `start_i` of CPU.v . 
input start_i;

// write at posedge clock
input clk_i;
// MEM stage
input MemRead_i;
//output reg MemRead_o;
output reg MemRead_o; // = 1'b0;
input MemWrite_i;
//output reg MemWrite_o;
output reg MemWrite_o; // = 1'b0;
// MEM stage additional
input [31:0] ALU_Result_i;
//output reg [31:0] ALU_Result_o;
output reg [31:0] ALU_Result_o; // = 32'b0;
// WB stage
input RegWrite_i;
//output reg RegWrite_o;
output reg RegWrite_o; // = 1'b0;
input MemtoReg_i;
//output reg MemtoReg_o;
output reg MemtoReg_o; // = 1'b0;

// register data2
input [31:0] RS_Data2_i;
//output reg [31:0] RS_Data2_o;
output reg [31:0] RS_Data2_o; // = 32'b0;

// register addr
input [4:0] RDaddr_i;
//output reg [4:0] RDaddr_o;
output reg [4:0] RDaddr_o; // = 5'b0;

//TODO : initialize reg in initial
initial begin
	//output reg MemRead_o;
	MemRead_o = 1'b0;
	//output reg MemWrite_o;
	MemWrite_o = 1'b0;
	// MEM stage additional
	//output reg [31:0] ALU_Result_o;
	ALU_Result_o = 32'b0;
	// WB stage
	//output reg RegWrite_o;
	RegWrite_o = 1'b0;
	//output reg MemtoReg_o;
	MemtoReg_o = 1'b0;

	// register data2
	//output reg [31:0] RS_Data2_o;
	RS_Data2_o = 32'b0;

	// register addr
	//output reg [4:0] RDaddr_o;
	RDaddr_o = 5'b0;
end


always @(posedge clk_i)
begin
	//TODO : Magic : For IF_ID.v : cannot write inst_o at PC=0. At PC=0, inst_o 	shall be 32'b0 , since 1st instruction is still in IF stage , and no one is in ID stage !! So IF_IF.inst_o shall be 32'b0 at that time !!
	// 1. Method For Fixing : Utilize the signal `start_i` of CPU.v . 
	if(start_i) begin
		MemRead_o <= MemRead_i;
		MemWrite_o <= MemWrite_i;
		RegWrite_o <= RegWrite_i;
		MemtoReg_o <= MemtoReg_i;
		//
		RS_Data2_o <= RS_Data2_i;

		RDaddr_o <= RDaddr_i;
		// MEM stage additional
		ALU_Result_o <= ALU_Result_i;
	end
end

endmodule

