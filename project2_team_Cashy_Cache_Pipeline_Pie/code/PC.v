module PC
(
	//XXX P2 :
	stall_i,
	// P1 :
    clk_i,
    rst_i,
    start_i,
    PCWrite_i,
    pc_i,
    pc_o
);

// Ports
//XXX P2 : 
input	stall_i;
// P1 : 
input               clk_i;
input               rst_i;
input               start_i;
input               PCWrite_i;
input   [31:0]      pc_i;
output  [31:0]      pc_o;

// Wires & Registers
reg     [31:0]      pc_o;


always@(posedge clk_i or negedge rst_i) begin
    if(~rst_i) begin
        pc_o <= 32'b0;
    end  
    else begin
	//XXX: P2 :
	if(stall_i) begin
		// do nothing
	end // P1 :
        else if (PCWrite_i) begin
            if(start_i)
                pc_o <= pc_i;
            else
                pc_o <= pc_o;
        end
    end
end

endmodule
