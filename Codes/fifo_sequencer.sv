package fifo_sequencer_pkg;
import uvm_pkg::*;
`include "uvm_macros.svh"
import fifo_seq_item_pkg::*;
class MySequencer extends uvm_sequencer #(MySequenceItem);
`uvm_component_utils(MySequencer);
    function new(string name = "MySequencer",uvm_component parent=null);
        super.new(name,parent);
    endfunction //new()
endclass 
endpackage