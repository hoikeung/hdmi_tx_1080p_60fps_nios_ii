transcript on
if ![file isdirectory hdmi_tx_1080p_60fps_iputf_libs] {
	file mkdir hdmi_tx_1080p_60fps_iputf_libs
}

if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

###### Libraries for IPUTF cores 
###### End libraries for IPUTF cores 
###### MIF file copy and HDL compilation commands for IPUTF cores 


vlog "D:/Desktop/FPGA/Learn/hdmi_tx_1080p_60fps/pll_sim/pll.vo"

vlog -vlog01compat -work work +incdir+D:/Desktop/FPGA/Learn/hdmi_tx_1080p_60fps/src {D:/Desktop/FPGA/Learn/hdmi_tx_1080p_60fps/src/hdmi_tx_1080p_60fps.v}
vlog -vlog01compat -work work +incdir+D:/Desktop/FPGA/Learn/hdmi_tx_1080p_60fps/src {D:/Desktop/FPGA/Learn/hdmi_tx_1080p_60fps/src/I2C_HDMI_Config.v}
vlog -vlog01compat -work work +incdir+D:/Desktop/FPGA/Learn/hdmi_tx_1080p_60fps/src {D:/Desktop/FPGA/Learn/hdmi_tx_1080p_60fps/src/I2C_Controller.v}
vlog -vlog01compat -work work +incdir+D:/Desktop/FPGA/Learn/hdmi_tx_1080p_60fps/src {D:/Desktop/FPGA/Learn/hdmi_tx_1080p_60fps/src/I2C_WRITE_WDATA.v}
vlog -vlog01compat -work work +incdir+D:/Desktop/FPGA/Learn/hdmi_tx_1080p_60fps/src {D:/Desktop/FPGA/Learn/hdmi_tx_1080p_60fps/src/video_generator.v}

vlog -vlog01compat -work work +incdir+D:/Desktop/FPGA/Learn/hdmi_tx_1080p_60fps/src {D:/Desktop/FPGA/Learn/hdmi_tx_1080p_60fps/src/tb_hdmi_tx_1080p_60fps.v}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cyclonev_ver -L cyclonev_hssi_ver -L cyclonev_pcie_hip_ver -L rtl_work -L work -voptargs="+acc"  tb_hdmi_tx_1080p_60fps

add wave *
view structure
view signals
run -all
