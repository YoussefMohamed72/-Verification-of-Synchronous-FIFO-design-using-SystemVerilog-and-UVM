package fifo_driver_pkg;
import uvm_pkg::*;
`include "uvm_macros.svh";
import fifo_config_pkg::*;   ///
import fifo_seq_item_pkg::*;
class fifo_driver extends uvm_driver #(MySequenceItem);
`uvm_component_utils(fifo_driver)
virtual fifo_if fifo_vif;
fifo_config fifo_cfg;
MySequenceItem stim_seq_item;

    function new(string name="fifo_driver",uvm_component parent=null);
        super.new(name,parent);
    endfunction //new()

    task run_phase(uvm_phase phase);
        super.run_phase(phase);
        forever begin
            stim_seq_item=MySequenceItem::type_id::create("stim_seq_item");
            seq_item_port.get_next_item(stim_seq_item);
            fifo_vif.rst_n=stim_seq_item.rst_n; fifo_vif.wr_en=stim_seq_item.wr_en; 
            fifo_vif.rd_en=stim_seq_item.rd_en; fifo_vif.data_in=stim_seq_item.data_in; 
            @(negedge fifo_vif.clk);
            seq_item_port.item_done();
            `uvm_info("run_phase",stim_seq_item.convert2string_stimulus(),UVM_HIGH)
        end
    endtask 
endclass 
endpackage

   /* function void build_phase(uvm_phase phase);
       super.build_phase(phase);
        if(!uvm_config_db #(fifo_config)::get(this,"","CFG",fifo_cfg))
        `uvm_fatal("build_phase","failed to get configuration object")
    endfunction
    function void connect_phase(uvm_phase phase);
       super.connect_phase(phase) ;
       fifo_vif=fifo_cfg.fifo_vif;
    endfunction*/