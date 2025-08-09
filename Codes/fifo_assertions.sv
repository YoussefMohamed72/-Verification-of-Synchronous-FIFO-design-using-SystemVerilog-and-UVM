module fifo_sva (fifo_if.DUT f_if);
logic clk, rst_n, wr_en, rd_en;
logic wr_ack, overflow, wr_ptr, rd_ptr;
logic full, empty, almostfull, almostempty, underflow;
logic [3:0] count;
assign clk=f_if.clk;
assign rst_n=f_if.rst_n;
assign wr_en=f_if.wr_en;
assign rd_en=f_if.rd_en;
assign wr_ptr=DUT.wr_ptr;
assign rd_ptr=DUT.rd_ptr;
assign count=DUT.count;

property rst_p;
@(posedge clk) (!rst_n) |-> ( !f_if.full && f_if.empty && !f_if.almostfull && !f_if.almostempty && !count && !rd_ptr && !wr_ptr );
endproperty

property full_p;
@(posedge clk) disable iff (!rst_n) (count==8) |-> (f_if.full); 
endproperty

property almostfull_p;
@(posedge clk) disable iff (!rst_n) count==7 |-> (f_if.almostfull); 
endproperty

property empty_p;
@(posedge clk) disable iff (!rst_n) count==0 |-> (f_if.empty) ;
endproperty

property almostempty_p;
@(posedge clk) disable iff (!rst_n) count==3'd1 |-> (f_if.almostempty);
endproperty

property overflow_p;
@(posedge clk) disable iff (!rst_n) (f_if.full && wr_en ) |=> (f_if.overflow);
endproperty

property underflow_p;
@(posedge clk) disable iff (!rst_n) (f_if.empty && rd_en) |=> (f_if.underflow);
endproperty

property wr_ack_p;
@(posedge clk) disable iff (!rst_n) (!f_if.full && wr_en) |=> (f_if.wr_ack);
endproperty

property counters_write_p;
@(posedge clk) disable iff (!rst_n) (!f_if.full && wr_en) |=> ( (wr_ptr==$past(wr_ptr)+1'b1)  );
endproperty

property counters_read_p;
@(posedge clk) disable iff (!rst_n) (!f_if.empty && rd_en)  |=> ( (rd_ptr==$past(rd_ptr)+1'b1)  );
endproperty

property wr_rd_both_empty;
@(posedge clk) disable iff (!rst_n) (wr_en && rd_en && f_if.empty) |=> ((f_if.wr_ack) && (wr_ptr==$past(wr_ptr)+1'b1) );
endproperty

property wr_rd_both_full;
@(posedge clk) disable iff (!rst_n) (wr_en && rd_en && f_if.full) |=> ((!f_if.wr_ack) && (rd_ptr==$past(rd_ptr)+1'b1) );
endproperty

property count_inc;
@(posedge clk) disable iff (!rst_n) (wr_en && !rd_en && !f_if.full) |=> (count==$past(count)+1'b1);
endproperty

property count_dec;
@(posedge clk) disable iff (!rst_n) (!wr_en && rd_en && !f_if.empty) |=> (count==$past(count)-1'b1);
endproperty


rst_assertion: assert property (rst_p);
full_assertion: assert property (full_p);
almostfull_assertion: assert property (almostfull_p);
empty_assertion: assert property (empty_p);
almostempty_assertion: assert property (almostempty_p);
overflow_assertion: assert property (overflow_p);
underflow_assertion: assert property (underflow_p);
wr_ack_assertion: assert property (wr_ack_p);
counters_write_assertion: assert property (counters_write_p);
counters_read_assertion: assert property (counters_read_p);
wr_rd_both_empty_assertion: assert property (wr_rd_both_empty);
wr_rd_both_full_assertion: assert property (wr_rd_both_full);
count_inc_assertion: assert property (count_inc);
count_dec_assertion: assert property (count_dec);

rst_cover: cover property (rst_p);
full_cover: cover property (full_p);
almostfull_cover: cover property (almostfull_p);
empty_cover: cover property (empty_p);
almostempty_cover: cover property (almostempty_p);
overflow_cover: cover property (overflow_p);
underflow_cover: cover property (underflow_p);
wr_ack_cover: cover property (wr_ack_p);
counters_write_cover: cover property (counters_write_p);
counters_read_cover: cover property (counters_read_p);
wr_rd_both_empty_cover: cover property (wr_rd_both_empty);
wr_rd_both_full_cover: cover property (wr_rd_both_full);
count_inc_cover: cover property (count_inc);
count_dec_cover: cover property (count_dec);
endmodule