iverilog -o datapath_tb_test datapath_tb.v datapath.v ../fetch/fetch.v ../decode/decode.v ../regfile/regfile.v ../alu/alu.v ../pc/pc.v ../imem/imem.v && vvp datapath_tb_test
