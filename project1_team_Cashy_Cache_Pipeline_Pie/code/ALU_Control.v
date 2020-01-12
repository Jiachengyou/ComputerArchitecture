// ALU_Control.v
module ALU_Control(
	funct_i,
	ALUOp_i,
	ALUCtrl_o
);
input [9:0] funct_i; // instruction[31:25, 14:12] {funct7, funct3}
input [1:0] ALUOp_i;
//TODO magic : change : "assign" to "always"
//output [3:0] ALUCtrl_o;
output reg [3:0] ALUCtrl_o;
//TODO
initial begin
	ALUCtrl_o = 4'b0010; // ALUCtrl_add
end

parameter ALUOp_add = 2'b00; // lw sw
parameter ALUOp_sub = 2'b01; // beq

parameter ALUCtrl_add = 4'b0010;
parameter ALUCtrl_sub = 4'b0110;
parameter ALUCtrl_and = 4'b0000;
parameter ALUCtrl_or = 4'b0001;
parameter ALUCtrl_mul = 4'b0111; //TODO self-defined


parameter funct3_and = 3'b111;
parameter funct3_or = 3'b110;

parameter funct7_add = 7'b000_0000;
parameter funct7_sub = 7'b010_0000;
parameter funct7_mul = 7'b000_0001;

/*
// first determine ALUCtrl by the funct field if it need to
wire [2:0] funct3 = funct_i[2:0];
wire [6:0] funct7 = funct_i[9:3];
wire [3:0] ALUCtrl_by_funct = 
	(funct3 == funct3_or)? ALUCtrl_or :
	(funct3 == funct3_and)? ALUCtrl_and :
	(funct7 == funct7_add)? ALUCtrl_add :
	(funct7 == funct7_sub)? ALUCtrl_sub : ALUCtrl_mul;

assign ALUCtrl_o = 
	(ALUOp_i == ALUOp_add)? ALUCtrl_add : 
	(ALUOp_i == ALUOp_sub)? ALUCtrl_sub : ALUCtrl_by_funct;
*/


//TODO magic : change : "assign" to "always"
//TODO : magic : my hypothesis is : if the conditions are x, then (1) using assign : else : still be x (2) as Forward.v
always @(*) begin
	//TODO : new hypothesis : " ()? 1'b1:1'b0 " will not choose else if the conditions are x
	/*ALUCtrl_o <= 
		(ALUOp_i == ALUOp_add)? ALUCtrl_add :
		(ALUOp_i == ALUOp_sub)? ALUCtrl_sub : 
		(funct_i[2:0] == funct3_or)? ALUCtrl_or :
		(funct_i[2:0] == funct3_and)? ALUCtrl_and :
		(funct_i[9:3] == funct7_add)? ALUCtrl_add :
		(funct_i[9:3] == funct7_sub)? ALUCtrl_sub : ALUCtrl_mul;
	*/
	if(ALUOp_i == ALUOp_add)
		ALUCtrl_o = ALUCtrl_add;
	else if(ALUOp_i == ALUOp_sub)
		ALUCtrl_o = ALUCtrl_sub;
	else if(funct_i[2:0] == funct3_or)
		ALUCtrl_o = ALUCtrl_or;
	else if(funct_i[2:0] == funct3_and)
		ALUCtrl_o = ALUCtrl_and;
	else if(funct_i[9:3] == funct7_add)
		ALUCtrl_o = ALUCtrl_add;
	else if(funct_i[9:3] == funct7_sub)
		ALUCtrl_o = ALUCtrl_sub;
	else if(funct_i[9:3] == funct7_mul)
		ALUCtrl_o = ALUCtrl_mul;
	else
	begin
		ALUCtrl_o = ALUCtrl_add;
	end
end

endmodule


