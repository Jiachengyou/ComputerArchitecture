module Control
(
	Op_i,
	ALUOp_o,
	ALUSrc_o,
	Branch_o,
	MemRead_o,
	MemWrite_o,
	RegWrite_o,
	MemtoReg_o
);

input [6 : 0] Op_i;
output 	[1:0] ALUOp_o;
output  ALUSrc_o;
output	Branch_o;
output  MemRead_o;
output  MemWrite_o;
output  RegWrite_o;
output  MemtoReg_o;	



assign ALUSrc_o = (Op_i == 7'b0000011 || Op_i == 7'b0100011 || Op_i == 7'b0010011)? 1'b1 : 1'b0;
assign Branch_o = (Op_i == 7'b1100011)? 1'b1 :1'b0;
assign MemRead_o = (Op_i == 7'b0000011)? 1'b1 :1'b0;
assign MemWrite_o = (Op_i == 7'b0100011)? 1'b1 : 1'b0;
assign RegWrite_o = (Op_i == 7'b0110011 || Op_i == 7'b0010011 || Op_i == 7'b0000011)? 1'b1 : 1'b0;
assign MemtoReg_o = (Op_i == 7'b0000011)? 1'b1 : 1'b0;
assign ALUOp_o = (Op_i == 7'b0110011) ? 2'b10 :
                 (Op_i == 7'b1100011) ? 2'b01 : 2'b00;


endmodule
