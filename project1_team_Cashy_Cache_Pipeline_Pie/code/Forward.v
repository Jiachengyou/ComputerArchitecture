module Forward(
	ID_EX_RS1addr_i,
	ID_EX_RS2addr_i,
	EX_MEM_RDaddr_i,
	MEM_WB_RDaddr_i,
	EX_MEM_RegWrite_i,
	MEM_WB_RegWrite_i,
	ForwardA,
	ForwardB
);

// Ports
input  [4 : 0] ID_EX_RS1addr_i;
input  [4 : 0] ID_EX_RS2addr_i;
input  [4 : 0] EX_MEM_RDaddr_i;
input  [4 : 0] MEM_WB_RDaddr_i;
input    EX_MEM_RegWrite_i;
input    MEM_WB_RegWrite_i;
output [1 : 0] ForwardA;
output [1 : 0] ForwardB;

reg [1 : 0] select_1_reg;
reg [1 : 0] select_2_reg;

assign ForwardA = select_1_reg;
assign ForwardB = select_2_reg;

always @(*)
begin
	// A
	if(EX_MEM_RegWrite_i && EX_MEM_RDaddr_i != 0 && EX_MEM_RDaddr_i == ID_EX_RS1addr_i)
		select_1_reg = 2'b10; // select data2 , from EX_MEM
	else if(MEM_WB_RegWrite_i && MEM_WB_RDaddr_i != 0 && MEM_WB_RDaddr_i == ID_EX_RS1addr_i)
		select_1_reg = 2'b01; // select data3, from MEM_WB
	else 
		select_1_reg = 2'b00; // select data1, from ID_EX

	// B
	if(EX_MEM_RegWrite_i && EX_MEM_RDaddr_i != 0 && EX_MEM_RDaddr_i == ID_EX_RS2addr_i)
		select_2_reg = 2'b10; // select data2 , from EX_MEM
	else if(MEM_WB_RegWrite_i && MEM_WB_RDaddr_i != 0 && MEM_WB_RDaddr_i == ID_EX_RS2addr_i)
		select_2_reg = 2'b01; // select data3, from MEM_WB
	else 
		select_2_reg = 2'b00; // select data1, from ID_EX
	
	
	/* //TODO : too many bugs (at least 2)...
    //A
	if (EX_MEM_RegWrite_i && EX_MEM_RDaddr_i != 0 && EX_MEM_RDaddr_i == ID_EX_RS1addr_i)
    begin
        select_1_reg = 2'b10;
    end
    else if (MEM_WB_RegWrite_i && EX_MEM_RDaddr_i != 0 && 
        ~(EX_MEM_RegWrite_i && (EX_MEM_RDaddr_i != 0) && EX_MEM_RDaddr_i != ID_EX_RS1addr_i)
        && MEM_WB_RDaddr_i == ID_EX_RS1addr_i)
    begin
        select_1_reg = 2'b01;
    end
    else 
    begin 
        select_1_reg = 2'b00;
    end

    //B

    if (EX_MEM_RegWrite_i && EX_MEM_RDaddr_i != 0 && EX_MEM_RDaddr_i == ID_EX_RS2addr_i)
    begin
        select_2_reg = 2'b10;
    end
    else if (MEM_WB_RegWrite_i && EX_MEM_RDaddr_i != 0 && 
        ~(EX_MEM_RegWrite_i && (EX_MEM_RDaddr_i != 0) && EX_MEM_RDaddr_i != ID_EX_RS2addr_i)
        && MEM_WB_RDaddr_i == ID_EX_RS2addr_i)
    begin
        select_2_reg = 2'b01;
    end
    else 
    begin 
        select_2_reg = 2'b00;
    end
	*/
end



endmodule
