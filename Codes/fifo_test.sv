package test_pkg;
import uvm_pkg::*;
`include "uvm_macros.svh";
import env_pkg::*;
import fifo_config_pkg::*;
import fifo_driver_pkg::*;
import sequence_pkg::*;
import agent_pkg::*;
class fifo_test extends uvm_test;
`uvm_component_utils(fifo_test);
fifo_env env;
fifo_config fifo_cfg;
virtual fifo_if fifo_vif;
write_Sequence write_seq;
read_Sequence read_seq;
write_read_Sequence write_read_seq;
reset_Sequence reset_seq;
    function new(string name = "fifo_test",uvm_component parent=null);
        super.new(name,parent);
    endfunction 
    function void build_phase(uvm_phase phase);
       super.build_phase(phase) ;
       env=fifo_env::type_id::create("env",this);
       fifo_cfg=fifo_config::type_id::create("fifo_cfg",this); /////
       write_seq=write_Sequence::type_id::create("write_seq",this);
       read_seq=read_Sequence::type_id::create("read_seq",this);
       write_read_seq=write_read_Sequence::type_id::create("write_read_seq",this);
       reset_seq=reset_Sequence::type_id::create("reset_seq",this);
       if(!uvm_config_db #(virtual fifo_if)::get(this,"","fifo_if",fifo_cfg.fifo_vif))
        `uvm_fatal ("build_phase","test - unable to get configuration object")
        uvm_config_db #(fifo_config)::set(this,"*","CFG",fifo_cfg);
    endfunction
    task run_phase(uvm_phase phase);
        super.run_phase(phase);
        phase.raise_objection(this);
        `uvm_info("run_phase","reset asserted",UVM_LOW)
        reset_seq.start(env.agt.sqr);
        `uvm_info("run_phase","reset DEasserted",UVM_LOW)
        `uvm_info("run_phase","write asserted",UVM_LOW)
        write_seq.start(env.agt.sqr);   //******************
        `uvm_info("run_phase","write deasserted",UVM_LOW)
        `uvm_info("run_phase","read asserted",UVM_LOW)
        read_seq.start(env.agt.sqr);
        `uvm_info("run_phase","read deasserted",UVM_LOW)
        `uvm_info("run_phase","write_read asserted",UVM_LOW)
        write_read_seq.start(env.agt.sqr);
        `uvm_info("run_phase","write_read deasserted",UVM_LOW)
        `uvm_info("run_phase","stim gen ended",UVM_LOW)
        phase.drop_objection(this);
    endtask 
endclass 
endpackage