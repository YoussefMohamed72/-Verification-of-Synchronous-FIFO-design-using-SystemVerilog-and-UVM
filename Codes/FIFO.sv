////////////////////////////////////////////////////////////////////////////////
// Author: Kareem Waseem
// Course: Digital Verification using SV & UVM
//
// Description: FIFO Design 
// 
////////////////////////////////////////////////////////////////////////////////
module FIFO(fifo_if.DUT f_if);
parameter FIFO_WIDTH = 16;
parameter FIFO_DEPTH = 8;
logic [FIFO_WIDTH-1:0] data_in;
logic clk, rst_n, wr_en, rd_en;
logic [FIFO_WIDTH-1:0] data_out;
logic wr_ack, overflow;
logic full, empty, almostfull, almostempty, underflow;

assign clk=f_if.clk;
assign data_in=f_if.data_in;
assign rst_n=f_if.rst_n;
assign wr_en=f_if.wr_en;
assign rd_en=f_if.rd_en;
assign f_if.data_out=data_out;
assign f_if.wr_ack=wr_ack;
assign f_if.overflow=overflow;
assign f_if.full=full;
assign f_if.empty=empty;
assign f_if.almostfull=almostfull;
assign f_if.almostempty=almostempty;
assign f_if.underflow=underflow;

localparam max_fifo_addr = $clog2(FIFO_DEPTH);

reg [FIFO_WIDTH-1:0] mem [FIFO_DEPTH-1:0];
reg [max_fifo_addr-1:0] wr_ptr, rd_ptr;
reg [max_fifo_addr:0] count;   

always @(posedge clk or negedge rst_n) begin
	if (!rst_n) begin
		wr_ptr <= 0; overflow<=0;   wr_ack<=0;   //
	end
	else if (wr_en && count < FIFO_DEPTH) begin
		mem[wr_ptr] <= data_in;
		wr_ack <= 1;
		wr_ptr <= wr_ptr + 1;
		overflow<=0;    //overflow=0 as fifo is not full since count<fifo_depth
	end
	else begin 
		wr_ack <= 0; 
		if (full && wr_en) //&& not & 
			overflow <= 1;
		else overflow <= 0;
	end
end

always @(posedge clk or negedge rst_n) begin
	if (!rst_n) begin
		rd_ptr <= 0; underflow<=0;   //underflow is sequential
	end
	else if (rd_en && count != 0) begin
		data_out <= mem[rd_ptr]; 
		rd_ptr <= rd_ptr + 1;
		underflow<=0; //underflow=0 since fifo is not empty as count !=0
	end
	else begin
		if(empty && rd_en)  //added if else of the sequential output underflow
		    underflow<=1;
		else underflow<=0;
	end
end

always @(posedge clk or negedge rst_n) begin
	if (!rst_n) begin
		count <= 0;
	end
	else begin   //count value wasn't changing if rd_en==1 && wr_en==1 
		if	( ({wr_en, rd_en} == 2'b10) && !full) 
		count<=count+1;
		else if ( ({wr_en, rd_en} == 2'b01) && !empty)
			count<=count-1;
		else if ( wr_en && rd_en && empty)
		    count<=count+1; 
		else if ( wr_en && rd_en && full)  
		    count<=count-1; 
	end
end

assign full = (count == FIFO_DEPTH)? 1 : 0;
assign empty = (count == 0)? 1 : 0;
//assign underflow = (empty && rd_en)? 1 : 0; underflow is sequential 
assign almostfull = (count == FIFO_DEPTH-1)? 1 : 0; //almostfull is @count=7 not 6
assign almostempty = (count == 1)? 1 : 0;
endmodule