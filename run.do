vlib work
vlog -f src_files.txt +cover -covercells
vsim -voptargs=+acc work.top -cover
add wave /top/f_if/*
add wave /top/DUT/mem
add wave /top/DUT/wr_ptr
add wave /top/DUT/rd_ptr
add wave /top/DUT/count
coverage save top.ucdb -onexit
run -all