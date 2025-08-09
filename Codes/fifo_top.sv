import uvm_pkg::*;
`include "uvm_macros.svh"
import test_pkg::*;
import env_pkg::*;
import fifo_driver_pkg::*;
import fifo_config_pkg::*;
module top ();
bit clk;
initial begin
    clk=0;
    forever begin
        #2; clk=~clk;
    end
end    
fifo_if f_if(clk);
FIFO DUT (f_if);
bind FIFO fifo_sva fifo_sva_inst (f_if);
initial begin
    uvm_config_db #(virtual fifo_if)::set(null,"uvm_test_top","fifo_if",f_if);
    run_test("fifo_test");
end
endmodule