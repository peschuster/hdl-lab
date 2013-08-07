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
vlib umc13
vlog -work umc13 /cad/umc/UMC13/UMCE13H210D3_1.2/verilog_simulation_models/*

#compile gate-level netlist file and testbench
vlog -sv -work work ../mapped/cpu_gl.v ../tb/memory.sv ../tb/testbench.sv 

#simulate testbench (link to standart cell library, annotate typical timing to Device Under Test)
vsim -L umc13 -sdftyp /testbench/cpu_i=../mapped/timing.sdf -novopt work.testbench

#add signals to waveform
add wave sim:/testbench/*
