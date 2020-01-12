module MUX_Control
(
	MUX_Control_select_i,
	ALUOp_i,
	ALUSrc_i,
	MemRead_i,
	MemWrite_i,
	RegWrite_i,	
	MemtoReg_i,			
	ALUOp_o,
	ALUSrc_o,
	MemRead_o,
	MemWrite_o,
	RegWrite_o,
	MemtoReg_o
);

input  MUX_Control_select_i;
input  [1:0]  ALUOp_i;
input  ALUSrc_i;
input  MemRead_i;
input  MemWrite_i;
input  RegWrite_i;
input  MemtoReg_i;

//TODO : magic : my hypothesis is : if the conditions are x, then (1) using assign : else : still be x (2) as Forward.v
//TODO : new hypothesis : " ()? 1'b1:1'b0 " will not choose else if the conditions are x
output reg [1:0]  ALUOp_o;
output reg ALUSrc_o;
output reg MemRead_o;
output reg MemWrite_o;
output reg RegWrite_o;
output reg MemtoReg_o;
initial begin
	ALUOp_o = 2'b00;
	ALUSrc_o = 1'b0;
	MemRead_o = 1'b0;
	MemWrite_o = 1'b0;
	RegWrite_o = 1'b0;
	MemtoReg_o = 1'b0;
end
/*
output [1:0]  ALUOp_o;
output  ALUSrc_o;
output  MemRead_o;
output  MemWrite_o;
output  RegWrite_o;
output  MemtoReg_o;
*/
/*assign ALUOp_o = (MUX_Control_select_i == 1'b0)? {ALUOp_i} : {2'b00};
assign ALUSrc_o = (MUX_Control_select_i == 1'b0)? {ALUSrc_i} : {1'b0};
assign MemRead_o = (MUX_Control_select_i == 1'b0)? {MemRead_i} : {1'b0};
assign MemWrite_o = (MUX_Control_select_i == 1'b0)? {MemWrite_i} : {1'b0};
assign RegWrite_o = (MUX_Control_select_i == 1'b0)? {RegWrite_i} : {1'b0};
assign MemtoReg_o = (MUX_Control_select_i == 1'b0)? {MemtoReg_i} : {1'b0};
*/

//TODO : magic : my hypothesis is : if the conditions are x, then (1) using assign : else : still be x (2) as Forward.v
always @(*) begin
	//TODO : new hypothesis : " ()? 1'b1:1'b0 " will not choose else if the conditions are x
	//TODO : why this won't have x initially ?? because MUX_Control_select_i is given by MUX_Control_select_reg in CPU.v , who is initialized by initial block --> so actually we don't have to do the following here.
	if(MUX_Control_select_i == 1'b0)
		ALUOp_o = ALUOp_i;
	else
		ALUOp_o = 2'b00;
	if(MUX_Control_select_i == 1'b0)
		ALUSrc_o = ALUSrc_i;
	else
		ALUSrc_o = 1'b0;
	if(MUX_Control_select_i == 1'b0)
		MemRead_o = MemRead_i;
	else
		MemRead_o = 1'b0;
	if(MUX_Control_select_i == 1'b0)
		MemWrite_o = MemWrite_i;
	else
		MemWrite_o = 1'b0;
	if(MUX_Control_select_i == 1'b0)
		RegWrite_o = RegWrite_i;
	else
		RegWrite_o = 1'b0;
	if(MUX_Control_select_i == 1'b0)
		MemtoReg_o = MemtoReg_i; 
	else 
		MemtoReg_o = 1'b0;
end
endmodule
