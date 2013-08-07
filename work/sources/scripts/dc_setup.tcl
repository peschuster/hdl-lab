set DC_LIB_DIR		"/cad/synopsys/libs/Faraday_UMC_65nm/Standard_Cell/tcbn65lp_200c_FE/TSMCHOME/digital/Front_End/timing_power_noise/NLDM/tcbn65lp_200a"
set SYNOPSYS_HOME	"/cad/synopsys/tools/syn_vE-2010.12-SP1"
set DC_LIB_NAME		"UMC CMOS 65nm"

set search_path			[concat $search_path				\
								$DC_LIB_DIR					\
								$SYNOPSYS_HOME/libraries/syn		\
								../../sources/rtl					\
						]

set target_library		[concat $DC_LIB_DIR/tcbn65lptc.db]


set symbol_library		""

set synthetic_library	[concat dw_foundation.sldb	\
								standard.sldb		\
						]

set link_library		[concat	*					\
								$target_library 	\
								$synthetic_library	\
						]
					
						
set designer "Boris Traskov"

set_host_options -max_cores 16

# Define aliases
alias h history
alias rc report_constraint -all_violators
