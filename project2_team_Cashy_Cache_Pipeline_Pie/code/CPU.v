module CPU
(
    clk_i, 
    rst_i, // P2
    start_i,
    
    // P2 new ports : "To Data Memory Interface"
    mem_data_i, 
    mem_ack_i,     
    mem_data_o, 
    mem_addr_o,     
    mem_enable_o, 
    mem_write_o
);

// Ports
input         clk_i;
input	rst_i; // P2
input         start_i;

// P2 new ports : "To Data Memory Interface"
input [255:0] mem_data_i; 
input mem_ack_i;
output [255:0] mem_data_o;
output [31:0] mem_addr_o;
output mem_enable_o;
output mem_write_o;


// IF stage
wire [31:0] inst_addr;

// ID stage
wire [31:0] inst;
wire [31:0] imm_ID;
// to And
wire Branch;
// to ID_EX
wire [31:0] RS_Data1;
wire [31:0] RS_Data2;

// flush
wire  Branch_taken;


// EX stage
wire [31:0] imm_EX;
wire [4:0] ID_EX_RDaddr; // to HazardDetection and EX_MEM
wire ID_EX_MemRead; // to HazardDetection and EX_MEM

wire [31:0] MUX_ALU_data2_RS_Data2; // to MUX_ALU_data2_src.data1_i and EX_MEM.RS_Data2_i

// magic 
wire [31:0] ID_EX__RS_Data1_o; // from ID_EX.RS_Data1_o to MUX_ALU_data1.data1_i
wire [31:0] ID_EX__RS_Data2_o; // from ID_EX.RS_Data2_o to MUX_ALU_data2.data1_i
wire ID_EX__ALUSrc_o; // ID_EX.ALUSrc_o to MUX_ALU_data2_src.select_i


// MEM stage
wire [4:0] EX_MEM_RDaddr; // to Forward and MEM_WB
wire EX_MEM_RegWrite; // to Forward and MEM_WB

wire [31:0] ALU_Result_EX_MEM; // to Data_Memory and MEM_WB, and both MUX_ALU_data1.data3_i and MUX_ALU_data2.data3_i

// WB stage
wire [4:0] MEM_WB_RDaddr; // to Forward and Registers
wire MEM_WB_RegWrite; // to Forward and Registers

wire [31:0] MUX_MemtoReg_RDdata; // to Registers, and both MUX_ALU_data1.data2_i and MUX_ALU_data2.data2_i



// magic 
/*reg Branch_taken_reg = 1'b0;
reg PC_write_reg = 1'b1;
wire PC_write;
reg IF_ID_write_reg = 1'b1;
wire IF_ID_write;
reg MUX_Control_select_reg = 1'b0;
wire MUX_Control_select;
*/
reg Branch_taken_reg;
reg PC_write_reg;
wire PC_write;
reg IF_ID_write_reg;
wire IF_ID_write;
reg MUX_Control_select_reg;
wire MUX_Control_select;

//XXX P2 :
reg stall_reg;
wire stall;

//TODO : initialize in intitial block
initial begin
	//XXX P2 :
	stall_reg = 1'b0;

	//TODO : Crucial To Initialize PC register : Or PC=x anytime
	PC.pc_o = 32'b0;
	
	//
	Branch_taken_reg = 1'b0;
	PC_write_reg = 1'b1;
	IF_ID_write_reg = 1'b1;
	MUX_Control_select_reg = 1'b0;
end
	
//XXX P2 :
always @(stall)
begin
	stall_reg <= stall;
end

// P1 :
always @(Branch_taken)
begin
	Branch_taken_reg <= Branch_taken;
end

always @(PC_write)
begin
	PC_write_reg <= PC_write;
end

always @(IF_ID_write)
begin
	IF_ID_write_reg <= IF_ID_write;
end

always @(MUX_Control_select)
begin
	MUX_Control_select_reg <= MUX_Control_select;
end





//IF stage

PC PC(
    //XXX P2 :
    .stall_i(stall_reg),

    // P1 :
    .clk_i          (clk_i),
    .start_i        (start_i),
    .PCWrite_i      (PC_write_reg),
    .pc_i           (MUX_PC.data_o),
    .pc_o           (inst_addr)
);

MUX32 MUX_PC(
    .data1_i (Add_PC_4.data_o),
	.data2_i (Adder_PC_Branch.data_o),
	.select_i (Branch_taken_reg),
	.data_o (PC.pc_i)
);

Instruction_Memory Instruction_Memory(
    .addr_i         (inst_addr),
    .instr_o        (IF_ID.inst_i)
);

Adder Add_PC_4(
    .data1_i (inst_addr),
    .data2_i (32'd4),
    .data_o (MUX_PC.data1_i)
);

IF_ID IF_ID(
    	//XXX P2 :
	.stall_i(stall_reg),
	
	// P1 :

	//TODO : Magic : For IF_ID.v : cannot write inst_o at PC=0. At PC=0, inst_o 	shall be 32'b0 , since 1st instruction is still in IF stage , and no one is in ID stage !! So IF_IF.inst_o shall be 32'b0 at that time !!
	// 1. Method For Fixing : Utilize the signal `start_i` of CPU.v . 
	.start_i (start_i),

    .clk_i (clk_i),
	.IF_ID_flush_i (Branch_taken_reg),
	.IF_ID_write_i (IF_ID_write_reg),
	.PC_i          (inst_addr),
	.PC_o          (Adder_PC_Branch.data1_i),
	//TODO : Magic (trademark) Method 2 : leave blank
	.inst_i        (), //(Instruction_Memory.instr_o),
	.inst_o        (inst)
);


// ID stage

Sign_Extend Sign_Extend(
    .inst_i (inst),
	.imm_o (imm_ID) // to ID_EX.imm_i
);

Adder Adder_PC_Branch(
	//TODO : Magic (trademark) Method 2 : leave blank
    .data1_i (), //(IF_ID.PC_o),
    .data2_i (imm_ID << 1), // shift left 1
    .data_o (MUX_PC.data2_i)
);

Control Control
(
	.Op_i (inst[6:0]),
	.ALUOp_o (MUX_Control.ALUOp_i),
	.ALUSrc_o (MUX_Control.ALUSrc_i),
    // use in ID stage
	.Branch_o (Branch),
	.MemRead_o (MUX_Control.MemRead_i),
	.MemWrite_o (MUX_Control.MemWrite_i),
	.RegWrite_o (MUX_Control.RegWrite_i),
	.MemtoReg_o (MUX_Control.MemtoReg_i)
);

MUX_Control MUX_Control
(
    // from Control
	.MUX_Control_select_i (MUX_Control_select_reg),
	//TODO : Magic (trademark) Method 2 : leave blank
	.ALUOp_i (), //(Control.ALUOp_o),
	.ALUSrc_i (), //(Control.ALUSrc_o),	
	.MemRead_i (), //(Control.MemRead_o),
	.MemWrite_i (), //(Control.MemWrite_o),
	.RegWrite_i (), //(Control.RegWrite_o),	
	.MemtoReg_i (), //(Control.MemtoReg_o),		
    // for ID/EX	
	.ALUOp_o (ID_EX.ALUOp_i),
	.ALUSrc_o (ID_EX.ALUSrc_i),

    // use in ID stage
	.MemRead_o (ID_EX.MemRead_i),
	.MemWrite_o (ID_EX.MemWrite_i),
	.RegWrite_o (ID_EX.RegWrite_i),
	.MemtoReg_o (ID_EX.MemtoReg_i)
);

And And(
    // directly from Control
	.data1_i (Branch),
	.data2_i ((RS_Data1 == RS_Data2)? 1'b1 : 1'b0),
	.data_o (Branch_taken)
);

HazardDetection HazardDetection(
	.IF_ID_RS1addr_i (inst[19:15]),
	.IF_ID_RS2addr_i (inst[24:20]),
	.ID_EX_RDaddr_i (ID_EX_RDaddr),
	.ID_EX_MemRead_i (ID_EX_MemRead),

	.MUX_Control_select_o (MUX_Control_select), 

	.PC_write_o         (PC_write),
	.IF_ID_write_o  (IF_ID_write),

    // to testbench
	.Stall_o ()
);

Registers Registers(
    .clk_i          (clk_i),
    .RS1addr_i      (inst[19:15]),
    .RS2addr_i      (inst[24:20]),

    // from MEM_WB 
    .RDaddr_i       (MEM_WB_RDaddr), // from MEM_WB
    .RDdata_i       (MUX_MemtoReg.data_o), // from MUX_MemtoReg
    .RegWrite_i     (MEM_WB_RegWrite), // from MEM_WB

    .RS1data_o      (RS_Data1),
    .RS2data_o      (RS_Data2)
);



// EX stage

ID_EX ID_EX(
    	//XXX P2 :
	.stall_i(stall_reg),
	
	// P1 :

	//TODO : Magic : For IF_ID.v : cannot write inst_o at PC=0. At PC=0, inst_o 	shall be 32'b0 , since 1st instruction is still in IF stage , and no one is in ID stage !! So IF_IF.inst_o shall be 32'b0 at that time !!
	// 1. Method For Fixing : Utilize the signal `start_i` of CPU.v . 
	.start_i (start_i),

	.clk_i (clk_i),
	.funct_i ({inst[31:25], inst[14:12]}), // {funct7, funct3}
	.funct_o  (ALU_Control.funct_i),// {funct7, funct3}

    // input from MUX_Control 
    // use in EX stage
	//TODO : Magic (trademark) Method 2 : leave blank
	.ALUOp_i (), //(MUX_Control.ALUOp_o),
	.ALUOp_o (ALU_Control.ALUOp_i),
	.ALUSrc_i (), //(MUX_Control.ALUSrc_o),
	.ALUSrc_o (ID_EX__ALUSrc_o), //(MUX_ALU_data2_src.select_i), // to MUX_ALU_data2_src.select_i

	// imm used in EX stage
	.imm_i (imm_ID), // from Sign_Extend.imm_o 
	.imm_o (imm_EX), // to MUX_ALU_data2_src.data2_i

    // to EX_MEM
	//TODO : Magic (trademark) Method 2 : leave blank
	.MemRead_i (), //(MUX_Control.MemRead_o),
	.MemRead_o (ID_EX_MemRead),
	.MemWrite_i (), //(MUX_Control.MemWrite_o),
	.MemWrite_o (EX_MEM.MemWrite_i),
	.RegWrite_i (), //(MUX_Control.RegWrite_o),
	.RegWrite_o (EX_MEM.RegWrite_i),
	.MemtoReg_i (), //(MUX_Control.MemtoReg_o),
	.MemtoReg_o (EX_MEM.MemtoReg_i),

	// register data
	.RS_Data1_i (RS_Data1),
	.RS_Data1_o(ID_EX__RS_Data1_o), // from ID_EX.RS_Data1_o to MUX_ALU_data1.data1_i //.RS_Data1_o (MUX_ALU_data1.data1_i),
	.RS_Data2_i (RS_Data2),
	.RS_Data2_o(ID_EX__RS_Data2_o), // from ID_EX.RS_Data2_o to MUX_ALU_data2.data1_i //.RS_Data2_o (MUX_ALU_data2.data1_i),

    // from Registers 
	.RS1addr_i (inst[19:15]),
	.RS1addr_o (Forward.ID_EX_RS1addr_i),
	.RS2addr_i (inst[24:20]),
	.RS2addr_o (Forward.ID_EX_RS2addr_i),
	.RDaddr_i (inst[11:7]),
	.RDaddr_o (ID_EX_RDaddr)
);

MUX3 MUX_ALU_data1(
    .data1_i(ID_EX__RS_Data1_o), // from ID_EX.RS_Data1_o to MUX_ALU_data1.data1_i //.data1_i (ID_EX.RS_Data1_o),
    // forward
	.data2_i (MUX_MemtoReg_RDdata), // from MUX_MemtoReg.data_o
    .data3_i (ALU_Result_EX_MEM), // from EX_MEM.ALU_Result_o
	.select_i (Forward.ForwardA),
	.data_o (ALU.data1_i)
);

MUX3 MUX_ALU_data2(
    .data1_i(ID_EX__RS_Data2_o), // from ID_EX.RS_Data2_o to MUX_ALU_data2.data1_i //.data1_i (ID_EX.RS_Data2_o),
    // forward
	.data2_i (MUX_MemtoReg_RDdata), // from MUX_MemtoReg.data_o
    .data3_i (ALU_Result_EX_MEM), // from EX_MEM.ALU_Result_o
	.select_i (Forward.ForwardB),
	.data_o (MUX_ALU_data2_RS_Data2) // to MUX_ALU_data2_src.data1_i and EX_MEM.RS_Data2_i
);

MUX32 MUX_ALU_data2_src(
    .data1_i (MUX_ALU_data2_RS_Data2), // from MUX_ALU_data2.data_o
	.data2_i (imm_EX), // from ID_EX
	.select_i (ID_EX__ALUSrc_o), //(ID_EX.ALUSrc_o), // from ID_EX.ALUSrc_o
	.data_o (ALU.data2_i)
);

ALU_Control ALU_Control(
	// Magic (trademark) Method 2 : leave blank
	.funct_i (), //(ID_EX.funct_o),
	.ALUOp_i (), //(ID_EX.ALUOp_o),
	.ALUCtrl_o () //(ALU.ALUCtrl_i)
);

ALU ALU(
	//TODO : Magic (trademark) Method 2 : leave blank
	.data1_i (), //(MUX_ALU_data1.data_o),
	.data2_i (), //(MUX_ALU_data2_src.data_o),
	//TODO : Magic (trademark) Method 2.1 : leave blank works for output port
	.ALUCtrl_i (ALU_Control.ALUCtrl_o),
	.data_o (EX_MEM.ALU_Result_i), 
	.Zero_o () // not used
);

Forward Forward(
	// Magic (trademark) Method 2 : leave blank
	.ID_EX_RS1addr_i (), //(ID_EX.RS1addr_o),
	.ID_EX_RS2addr_i (), //(ID_EX.RS2addr_o),
	.EX_MEM_RDaddr_i (EX_MEM_RDaddr), // from EX_MEM
	.MEM_WB_RDaddr_i (MEM_WB_RDaddr), // from MEM_WB
	.EX_MEM_RegWrite_i (EX_MEM_RegWrite), // from EX_MEM
	.MEM_WB_RegWrite_i (MEM_WB_RegWrite), // from MEM_WB
	.ForwardA (MUX_ALU_data1.select_i),
	.ForwardB (MUX_ALU_data2.select_i)
);


// MEM stage
EX_MEM EX_MEM(
	//XXX P2 :
	.stall_i(stall_reg),
	
	// P1 :

	//TODO : Magic : For IF_ID.v : cannot write inst_o at PC=0. At PC=0, inst_o 	shall be 32'b0 , since 1st instruction is still in IF stage , and no one is in ID stage !! So IF_IF.inst_o shall be 32'b0 at that time !!
	// 1. Method For Fixing : Utilize the signal `start_i` of CPU.v . 
	.start_i (start_i),

	.clk_i (clk_i),
	// Magic (trademark) Method 2 : leave blank
    // used in MEM stage
	.MemRead_i (ID_EX_MemRead), //XXX : "P2_Magic" : P2 : "fucking super bug"  // P1 : (), //(ID_EX.MemRead_o),
	.MemRead_o (dcache.p1_MemRead_i), //XXX : P2 // P1 : (), // not used for data memory
	.MemWrite_i (), //(ID_EX.MemWrite_o),
	.MemWrite_o (dcache.p1_MemWrite_i), //XXX : P2 // P1 : (Data_Memory.MemWrite_i),

	.ALU_Result_i (), //(ALU.data_o),
	.ALU_Result_o (ALU_Result_EX_MEM), // to Data_Memory and MEM_WB, and both MUX_ALU_data1.data3_i and MUX_ALU_data2.data3_i

	.RegWrite_i (), //(ID_EX.RegWrite_o),
	.RegWrite_o ( EX_MEM_RegWrite ), // to Forward and MEM_WB
	.MemtoReg_i (), //(ID_EX.MemtoReg_o),
	.MemtoReg_o (MEM_WB.MemtoReg_i),

    // to data memory : sw
    .RS_Data2_i (MUX_ALU_data2_RS_Data2), // from MUX_ALU_data2.data_o
	.RS_Data2_o (dcache.p1_data_i), //XXX : P2 // P1 : (Data_Memory.data_i),

    // 
	.RDaddr_i (ID_EX_RDaddr), //(), //(ID_EX.RDaddr_i),
	.RDaddr_o (EX_MEM_RDaddr) // to Forward and MEM_WB
);

//XXX P2 : cache :
dcache_top dcache
(
    // System clock, reset and stall
    .clk_i	(clk_i), 
    .rst_i	(rst_i),

    // to Data Memory interface        
    .mem_data_i	(mem_data_i), 
    .mem_ack_i	(mem_ack_i),     
    .mem_data_o	(mem_data_o), 
    .mem_addr_o	(mem_addr_o),     
    .mem_enable_o	(mem_enable_o), 
    .mem_write_o	(mem_write_o), 
    
    // to CPU interface    
    .p1_data_i	(), 
    .p1_addr_i	(ALU_Result_EX_MEM),     
    .p1_MemRead_i	(), 
    .p1_MemWrite_i	(), 
    .p1_data_o	(MEM_WB.memory_data_i), 
    //XXX : stall :
    .p1_stall_o	(stall)
);
/* // P1 :
Data_Memory Data_Memory(
    .clk_i          (clk_i),

	// Magic (trademark) Method 2 : leave blank
    .addr_i         (ALU_Result_EX_MEM),
    .MemWrite_i     (), //(EX_MEM.MemWrite_o),
    .data_i         (), //(EX_MEM.RS_Data2_o), // from register source 2 // can't be from immediate
    .data_o         (MEM_WB.memory_data_i)
); */


// WB stage
MEM_WB MEM_WB(
	//XXX P2 :
	.stall_i(stall_reg),
	
	// P1 :

	//TODO : Magic : For IF_ID.v : cannot write inst_o at PC=0. At PC=0, inst_o 	shall be 32'b0 , since 1st instruction is still in IF stage , and no one is in ID stage !! So IF_IF.inst_o shall be 32'b0 at that time !!
	// 1. Method For Fixing : Utilize the signal `start_i` of CPU.v . 
	.start_i (start_i),

	.clk_i (clk_i),

	// Magic (trademark) Method 2 : leave blank
	.ALU_Result_i (ALU_Result_EX_MEM), // to Data_Memory and MEM_WB
	.ALU_Result_o (MUX_MemtoReg.data1_i), // to MUX_MemtoReg

	.RegWrite_i (EX_MEM_RegWrite), // from EX_MEM
	.RegWrite_o ( MEM_WB_RegWrite ), // to Registers and Forward
	.MemtoReg_i (), //(EX_MEM.MemtoReg_o),
	.MemtoReg_o (MUX_MemtoReg.select_i),
	.RDaddr_i (EX_MEM_RDaddr), // from EX_MEM
	.RDaddr_o ( MEM_WB_RDaddr ), // to Registers and Forward
	
	.memory_data_i (), //(Data_Memory.data_o),
	.memory_data_o (MUX_MemtoReg.data2_i)
);

MUX32 MUX_MemtoReg(
	// Magic (trademark) Method 2 : leave blank
    .data1_i (), //(MEM_WB.ALU_Result_o),
	.data2_i (), //(MEM_WB.memory_data_o),
	.select_i (), //(MEM_WB.MemtoReg_o),
	.data_o (MUX_MemtoReg_RDdata) // to Registers, and both MUX_ALU_data1.data2_i and MUX_ALU_data2.data2_i
);

endmodule

