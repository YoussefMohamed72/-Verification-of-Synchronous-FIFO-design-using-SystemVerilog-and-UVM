package fifo_seq_item_pkg;
import uvm_pkg::*;
`include "uvm_macros.svh"
class MySequenceItem extends uvm_sequence_item;
`uvm_object_utils(MySequenceItem);
rand logic [15:0] data_in;
rand logic rst_n, wr_en, rd_en;
logic [15:0] data_out;
logic wr_ack, overflow;
logic full, empty, almostfull, almostempty, underflow;
    function new(string name="MySequenceItem");
        super.new(name);
    endfunction //new()
    
    function string convert2string();
 return $sformatf ("%s,rst_n=0b%0b,wr_en=0b%0b,rd_en=0b%0b,data_in=0b%0b,wr_ack=0b%0b,overflow=0b%0b,full=0b%0b,empty=0b%0b,almostfull=%s,almostempty=0b%0b,underflow=0b%0b,dataout=0b%b",super.convert2string(),rst_n,wr_en,rd_en,data_in,wr_ack,overflow,full,empty,almostfull,almostempty,underflow,data_out);        
    endfunction
    
    function string convert2string_stimulus();
 return $sformatf ("rst_n=0b%0b,wr_en=0b%0b,rd_en=0b%0b,data_in=0b%0b",rst_n,wr_en,rd_en,data_in);        
    endfunction

    constraint reset_con{
        rst_n dist {1:/90,0:/10};
    }
    constraint write_en {
        wr_en dist {1:/70,0:/30};
    }
    constraint read_en {
        rd_en dist {1:/30,0:/70};
    }
endclass 
endpackage