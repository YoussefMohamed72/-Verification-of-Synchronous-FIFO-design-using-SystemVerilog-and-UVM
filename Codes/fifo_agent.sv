package agent_pkg;
import uvm_pkg::*;
`include "uvm_macros.svh"
import fifo_sequencer_pkg::*;
import fifo_driver_pkg::*;
import monitor_pkg::*;
import fifo_config_pkg::*;
import fifo_seq_item_pkg::*;
class fifo_agent extends uvm_agent;
`uvm_component_utils(fifo_agent)
MySequencer sqr;
fifo_driver drv;
fifo_monitor mon;
fifo_config fifo_cfg;
uvm_analysis_port #(MySequenceItem) agt_ap;    
    function new(string name= "fifo_agent",uvm_component parent=null);
        super.new(name,parent);
    endfunction

    function void build_phase(uvm_phase phase);
       super.build_phase(phase) ;
       if(!uvm_config_db #(fifo_config)::get(this,"","CFG",fifo_cfg))
       `uvm_fatal("build_phase","unable to get config obj");
       sqr=MySequencer::type_id::create("sqr",this);
       drv=fifo_driver::type_id::create("drv",this);
       mon=fifo_monitor::type_id::create("mon",this);
       agt_ap=new("agt_ap",this);
    endfunction

   function void connect_phase(uvm_phase phase);
   drv.fifo_vif=fifo_cfg.fifo_vif;
   mon.fifo_vif=fifo_cfg.fifo_vif;
   drv.seq_item_port.connect(sqr.seq_item_export);
   mon.mon_ap.connect(agt_ap);
   endfunction
endclass 
endpackage