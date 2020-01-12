// HazardDetection.v
// load-use hazard
module HazardDetection(
	IF_ID_RS1addr_i,
	IF_ID_RS2addr_i,
	ID_EX_RDaddr_i,
	ID_EX_MemRead_i,
	MUX_Control_select_o, 
	PC_write_o,
	IF_ID_write_o,
	Stall_o
);
input [4:0] IF_ID_RS1addr_i;
input [4:0] IF_ID_RS2addr_i;
input [4:0] ID_EX_RDaddr_i;
input ID_EX_MemRead_i;
output Stall_o;
output MUX_Control_select_o;
output PC_write_o; // 1'b1 to write, 1'b0 not to write
output IF_ID_write_o; // 1'b1 to write, 1'b0 not to write

//TODO : magic : my hypothesis is : if the conditions are x, then (1) using assign : else : still be x (2) as Forward.v
/*assign Stall_o = ( ID_EX_MemRead_i && ( ID_EX_RDaddr_i == IF_ID_RS1addr_i || ID_EX_RDaddr_i == IF_ID_RS2addr_i ) )? 1'b1:1'b0;
*/
reg Stall_o_reg;
initial begin
	Stall_o_reg = 1'b0;
end
assign Stall_o = Stall_o_reg;


assign MUX_Control_select_o = Stall_o;
assign PC_write_o = (Stall_o == 1'b1)? 1'b0:1'b1;
assign IF_ID_write_o = (Stall_o == 1'b1)? 1'b0:1'b1;


//TODO : magic : my hypothesis is : if the conditions are x, then (1) using assign : else : still be x (2) as Forward.v
always @(*) begin
	//TODO : new hypothesis : " ()? 1'b1:1'b0 " will not choose else if the conditions are x
	//Stall_o_reg = ( ID_EX_MemRead_i && ( ID_EX_RDaddr_i == IF_ID_RS1addr_i || ID_EX_RDaddr_i == IF_ID_RS2addr_i ) )? 1'b1:1'b0;
	if( ID_EX_MemRead_i && ( ID_EX_RDaddr_i == IF_ID_RS1addr_i || ID_EX_RDaddr_i == IF_ID_RS2addr_i ) )
		Stall_o_reg = 1'b1;
	else
		Stall_o_reg = 1'b0;
end

endmodule

