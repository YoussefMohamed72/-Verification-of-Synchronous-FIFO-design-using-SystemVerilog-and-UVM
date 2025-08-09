package cvg_collector_pkg;
import fifo_seq_item_pkg::*;
import fifo_driver_pkg::*;
import uvm_pkg::*;
`include "uvm_macros.svh"
class fifo_coverage extends uvm_component;
`uvm_component_utils(fifo_coverage)
uvm_analysis_export #(MySequenceItem) cov_export;
uvm_tlm_analysis_fifo #(MySequenceItem) cov_fifo;
MySequenceItem seq_item_cov;
covergroup g1 () ;
rd_en_cp: coverpoint seq_item_cov.rd_en;
wr_en_cp: coverpoint seq_item_cov.wr_en;
overflow_cp: coverpoint seq_item_cov.overflow;
underflow_cp: coverpoint seq_item_cov.underflow;
full_cp: coverpoint seq_item_cov.full;
empty_cp: coverpoint seq_item_cov.empty;
almostfull_cp: coverpoint seq_item_cov.almostfull;
almostempty_cp: coverpoint seq_item_cov.almostempty;
wr_ack_cp: coverpoint seq_item_cov.wr_ack;

wr_rd_wrack: cross rd_en_cp,wr_ack_cp,wr_en_cp{
    ignore_bins wren_ack = binsof (wr_en_cp) intersect {0} && binsof (wr_ack_cp);
}
wr_rd_overflow: cross wr_en_cp,rd_en_cp,overflow_cp{
    ignore_bins wren_overflow = binsof (wr_en_cp) intersect {0} && binsof (overflow_cp);
}
wr_rd_full: cross wr_en_cp,rd_en_cp,full_cp{
    ignore_bins rden_full = binsof (rd_en_cp) intersect {1} && binsof (full_cp);
}
wr_rd_empty: cross wr_en_cp,rd_en_cp,empty_cp;
wr_rd_almostfull: cross wr_en_cp,rd_en_cp,almostfull_cp;
wr_rd_almostempty: cross wr_en_cp,rd_en_cp,almostempty_cp;
wr_rd_underflow: cross wr_en_cp,rd_en_cp,underflow_cp{
    ignore_bins rden_underflow = binsof (rd_en_cp) intersect {0} && binsof (underflow_cp);
}      
endgroup
    function new(string name="fifo_coverage",uvm_component parent=null);
        super.new(name,parent);
        g1=new();
    endfunction //new()

function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    cov_export=new("cov_export",this);
    cov_fifo=new("cov_fifo",this);
endfunction
function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    cov_export.connect (cov_fifo.analysis_export);
endfunction
task run_phase(uvm_phase phase);
    super.run_phase(phase);
    forever begin
        cov_fifo.get(seq_item_cov);
        g1.sample();
    end
endtask 
endclass 
endpackage