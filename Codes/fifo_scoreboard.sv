package fifo_scoreboard_pkg;
import uvm_pkg::*;
`include "uvm_macros.svh";
import fifo_seq_item_pkg::*;
import fifo_driver_pkg::*;
class fifo_scoreboard extends uvm_scoreboard;
`uvm_component_utils (fifo_scoreboard)
uvm_analysis_export #(MySequenceItem) sb_export;
uvm_tlm_analysis_fifo #(MySequenceItem) sb_fifo;
MySequenceItem seq_item_sb;
logic [15:0] data_out_ref;
integer errors_count=0;
integer correct_count=0;
logic [15:0] fifo_ref [$];
integer count=0;

    function new(string name = "fifo_scoreboard",uvm_component parent = null);
        super.new (name,parent);
    endfunction //new()

    function void build_phase (uvm_phase phase);
        super.build_phase(phase);
        sb_export = new("sb_export",this);
        sb_fifo = new("sb_fifo",this);
    endfunction

    function void connect_phase (uvm_phase phase);
        super.connect_phase(phase);
        sb_export.connect (sb_fifo.analysis_export);
    endfunction

    task run_phase (uvm_phase phase);
        super.run_phase (phase);
        forever begin
            sb_fifo.get(seq_item_sb);
            ref_model(seq_item_sb);
            if (seq_item_sb.data_out!=data_out_ref) begin
`uvm_error ("run_phase",$sformatf("comparison failed, dut_out=%s and ref_model_out=0b%0b",seq_item_sb.convert2string(),data_out_ref));
                errors_count=errors_count+1;
            end
            else begin
                `uvm_info ("run_phase",$sformatf("correct out=%s",seq_item_sb.convert2string()),UVM_HIGH);
                correct_count=correct_count+1;
            end
        end
    endtask 

    task ref_model(MySequenceItem seq_item_chk);
    if(!seq_item_chk.rst_n) begin
        count=0; 
        fifo_ref.delete();
    end

    else begin
        if(seq_item_chk.wr_en==1 && seq_item_chk.rd_en==1 ) begin
            if(count==0) begin
                fifo_ref.push_back(seq_item_chk.data_in);
                count=count+1;
            end
            else if (count==8) begin
                data_out_ref=fifo_ref.pop_front();
                count=count-1;
            end
            else begin
                fifo_ref.push_back(seq_item_chk.data_in);
                data_out_ref=fifo_ref.pop_front();
                end
        end
else if (seq_item_chk.wr_en==1 && seq_item_chk.rd_en==0 && count<8) begin   //write case
        fifo_ref.push_back(seq_item_chk.data_in);
        count=count+1;
end

else if (seq_item_chk.wr_en==0 && seq_item_chk.rd_en==1 && count>0) begin   //read case
        data_out_ref=fifo_ref.pop_front();
        count=count-1;
end
    end
    endtask 

    function void report_phase (uvm_phase phase);
        super.report_phase(phase);
        `uvm_info("report_phase",$sformatf("total successful transactions=%0d",correct_count),UVM_MEDIUM);
        `uvm_info("report_phase",$sformatf("total failed transactions=%0d",errors_count),UVM_MEDIUM);
    endfunction
endclass 
endpackage