###############################################################
### GATE-LEVEL SIMULATION SCRIPT							###
###############################################################
# Integrated Electronic Systems Lab
# TU Darmstadt
# Author:	Dipl.-Ing. Boris Traskov
# Email: 	boris.traskov@ies.tu-darmstadt.de
# Purpose: 	simulate a verilog-netlist with annotated cell delays
# Usage:	"cd" to the ms_work directory
#			start Modelsim with:
#			VSIM $$> vsim
#			invoke GL-sim script with:
#			VSIM $$> do ../scripts/gate_level_simulation

#create a seperate library for std. cells and fill it (only needed once)
vlib lib65
vlog -work lib65 /cad/synopsys/libs/Faraday_UMC_65nm/Standard_Cell/tcbn65lp_200c_FE/TSMCHOME/digital/Front_End/verilog/tcbn65lp_200a/tcbn65lp.v

#compile gate-level netlist file and testbench
vlog -sv -work work ../../designs/mapped/cpu_gl.v ../../sources/testbench/memory.v ../../sources/testbench/testbench.v 

#simulate testbench (link to standart cell library, annotate typical timing to Device Under Test)
vsim -L lib65 -sdftyp /testbench/cpu_i=../../designs/mapped/cpu_gl.sdf -novopt work.testbench

#add signals to waveform
add wave sim:/testbench/*
