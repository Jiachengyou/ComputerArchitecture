module IF_ID
(
	// P2 : 
	stall_i,
	// P1 :
	start_i,

	clk_i,
	IF_ID_flush_i ,
	IF_ID_write_i ,
	PC_i          ,
	PC_o          ,
	inst_i        ,
	inst_o
);

// P2 :
input stall_i;
// P1 :
//TODO : Magic : For IF_ID.v : cannot write inst_o at PC=0. At PC=0, inst_o 	shall be 32'b0 , since 1st instruction is still in IF stage , and no one is in ID stage !! So IF_IF.inst_o shall be 32'b0 at that time !!
// 1. Method For Fixing : Utilize the signal `start_i` of CPU.v . 
input start_i;

input clk_i;
input IF_ID_flush_i;
input IF_ID_write_i;
input [31:0] PC_i;
input [31:0] inst_i;
//output reg [31:0] PC_o;
output reg [31:0] PC_o; // = 32'b0;
//output reg [31:0] inst_o;
output reg [31:0] inst_o; // = 32'b0;

//TODO : initialize reg in initial
initial begin
	PC_o = 32'b0;
	inst_o = 32'b0;
end


always@(posedge clk_i)
begin

	//TODO : Magic : For IF_ID.v : cannot write inst_o at PC=0. At PC=0, inst_o 	shall be 32'b0 , since 1st instruction is still in IF stage , and no one is in ID stage !! So IF_IF.inst_o shall be 32'b0 at that time !!
	// 1. Method For Fixing : Utilize the signal `start_i` of CPU.v . 
    //if (IF_ID_write_i)
    	if(stall_i) begin
	    // P2 : do nothing 
	end
    	else if(IF_ID_write_i && start_i) begin
        	PC_o <= PC_i;
		//TODO : why this won't have x initially ?? because IF_ID_flush_i is given by Branch_taken_reg in CPU.v , who is initialized by initial block 
        	inst_o <= (IF_ID_flush_i)?32'b0 : inst_i; 
    	end
end
endmodule
