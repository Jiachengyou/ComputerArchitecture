// MEM_WB.v
module MEM_WB(
	// P2 :
	stall_i,
	// P1 :
	//TODO : Magic : For IF_ID.v : cannot write inst_o at PC=0. At PC=0, inst_o 	shall be 32'b0 , since 1st instruction is still in IF stage , and no one is in ID stage !! So IF_IF.inst_o shall be 32'b0 at that time !!
	// 1. Method For Fixing : Utilize the signal `start_i` of CPU.v . 
	start_i,

	clk_i,

	ALU_Result_i,
	ALU_Result_o,

	RegWrite_i,
	RegWrite_o,
	MemtoReg_i,
	MemtoReg_o,
	RDaddr_i,
	RDaddr_o,
	
	memory_data_i,
	memory_data_o	
);
// P2 :
input stall_i;
// P1 :
//TODO : Magic : For IF_ID.v : cannot write inst_o at PC=0. At PC=0, inst_o 	shall be 32'b0 , since 1st instruction is still in IF stage , and no one is in ID stage !! So IF_IF.inst_o shall be 32'b0 at that time !!
// 1. Method For Fixing : Utilize the signal `start_i` of CPU.v . 
input start_i;

// write at posedge clock
input clk_i;
//
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
// WB additional
input [31:0] memory_data_i;
//output reg [31:0] memory_data_o;
output reg [31:0] memory_data_o; // = 32'b0;
// register addr
input [4:0] RDaddr_i;
//output reg [4:0] RDaddr_o;
output reg [4:0] RDaddr_o; // = 5'b0;

//TODO : initialize reg in initial
initial begin
	//output reg [31:0] ALU_Result_o;
	ALU_Result_o = 32'b0;
// WB stage
//output reg RegWrite_o;
	RegWrite_o = 1'b0;
//output reg MemtoReg_o;
	MemtoReg_o = 1'b0;
// WB additional
//output reg [31:0] memory_data_o;
	memory_data_o = 32'b0;
// register addr
//output reg [4:0] RDaddr_o;
	RDaddr_o = 5'b0;
end


always @(posedge clk_i)
begin
	//TODO : Magic : For IF_ID.v : cannot write inst_o at PC=0. At PC=0, inst_o 	shall be 32'b0 , since 1st instruction is still in IF stage , and no one is in ID stage !! So IF_IF.inst_o shall be 32'b0 at that time !!
	// 1. Method For Fixing : Utilize the signal `start_i` of CPU.v . 
	if(stall_i) begin
		// P2 : do nothing
	end
	else if(start_i) begin
		RegWrite_o <= RegWrite_i;
		MemtoReg_o <= MemtoReg_i;
		RDaddr_o <= RDaddr_i;
		// MEM stage additional
		ALU_Result_o <= ALU_Result_i;
		// WB additional
		memory_data_o <= memory_data_i;
	end
end

endmodule

