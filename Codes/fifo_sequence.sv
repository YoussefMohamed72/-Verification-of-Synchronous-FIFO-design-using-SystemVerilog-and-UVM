package sequence_pkg;
import uvm_pkg::*;
`include "uvm_macros.svh"
import fifo_seq_item_pkg::*;
class reset_Sequence extends uvm_sequence #(MySequenceItem);
`uvm_object_utils(reset_Sequence);
MySequenceItem item;
    function new(string name = "MySequence");
        super.new(name);
    endfunction //new()

     task body();
            item = MySequenceItem::type_id::create("item") ;
            start_item(item);
            item.rst_n=0; item.wr_en=0; item.rd_en=0; item.data_in=0; 
            finish_item(item);
    endtask 
endclass 

class write_Sequence extends uvm_sequence #(MySequenceItem);
`uvm_object_utils(write_Sequence);
MySequenceItem item;
    function new(string name = "MySequence");
        super.new(name);
    endfunction //new()
     task body();
        repeat(50) begin   
            item = MySequenceItem::type_id::create("item") ;
            start_item(item);
            item.rst_n=1; item.wr_en=1; item.rd_en=0; item.data_in=$random;
            finish_item(item);
        end
    endtask 
endclass 

class read_Sequence extends uvm_sequence #(MySequenceItem);
`uvm_object_utils(read_Sequence);
MySequenceItem item;
    function new(string name = "MySequence");
        super.new(name);
    endfunction //new()
     task body();
        repeat(50) begin   
            item = MySequenceItem::type_id::create("item") ;
            start_item(item);
            item.rst_n=1; item.wr_en=0; item.rd_en=1; 
            finish_item(item);
        end
    endtask 
endclass 

class write_read_Sequence extends uvm_sequence #(MySequenceItem);
`uvm_object_utils(write_read_Sequence);
MySequenceItem item;
    function new(string name = "MySequence");
        super.new(name);
    endfunction //new()
     task body();
        repeat(1000) begin   
            item = MySequenceItem::type_id::create("item") ;
            start_item(item); 
            assert(item.randomize());
            finish_item(item);
        end
    endtask 
endclass 
endpackage