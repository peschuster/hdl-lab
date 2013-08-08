###############################################################
### SYNTHESIS SCRIPT										###
###############################################################
# Integrated Electronic Systems Lab
# TU Darmstadt
# Author:	Dipl.-Ing. Boris Traskov
# Email: 	boris.traskov@ies.tu-darmstadt.de
# Purpose: 	map an RTL design to GL-netlist, annotate timing, analyse desgn
# Usage:	"cd" to the dc_work directory
#			invoke script with:
#			dc_shell -f ../scripts/synthesis

set PROJECT_PATH		"/home/vhdlp21/git/hdl-lab"
set REP_PATH			"/home/vhdlp21/git/hdl-lab/reports"
set TOP_LEVEL_MODULE	"cpu"

#analyse, elaborate and save unmapped design
analyze -format sv ${TOP_LEVEL_MODULE}.v
elaborate ${TOP_LEVEL_MODULE} -architecture verilog -library WORK -update
uniquify
#write -hierarchy -format ddc -output ${PROJECT_PATH}/hw/unmapped/${TOP_LEVEL_MODULE}_unmapped.ddc

#open the schematic. Take a look at it!
#open /cad/synopsys/tools/syn_vE-2010.12-SP1/packages/gtech/src_ver/gtech_lib.v and take a look at it

#constrain design
create_clock -name "CLOCK" -period 1 -waveform { 0.000 0.50  }  { clk  }

#map to target technology and save
compile -exact_map -incremental
#write -hierarchy -format ddc -output ${PROJECT_PATH}/hw/mapped/${TOP_LEVEL_MODULE}_mapped.ddc

#export mapped design as verilog netlist file for gate-level simulation
#write -hierarchy -format verilog -output ${PROJECT_PATH}/hw/mapped/${TOP_LEVEL_MODULE}_gl.v

#export timing annotations
#write_sdf ${PROJECT_PATH}/hw/mapped/${TOP_LEVEL_MODULE}_timing.sdf

#sh mkdir -p ${REP_PATH}/${TOP_LEVEL_MODULE}
report_design           > ${REP_PATH}/design.txt
report_timing           > ${REP_PATH}/timing.txt
report_power            > ${REP_PATH}/power.txt
report_area             > ${REP_PATH}/area.txt
report_reference        > ${REP_PATH}/reference.txt
report_resources        > ${REP_PATH}/resources.txt
check_design            > ${REP_PATH}/check_design.txt

#license_users
#exit
