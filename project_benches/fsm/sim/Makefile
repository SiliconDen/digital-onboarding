
#
#----------------------------------------------------------------------
#                                          
# DESCRIPTION: This makefile includes the shared makefile and contains
#   bench level make targets.
#
#----------------------------------------------------------------------


# pragma uvmf custom additional begin
# pragma uvmf custom additional end

# *********************************************************************************************
# UVMF library directory:
# This variable points to the UVMF release where uvmf_base_pkg directory resides.
# This variable points to release code that is not user modified.
# This variable allows for UVMF release directories to reside independent of project related verification IP and project bench directories.
# This code below looks "upward" for directory starting with UVMF_* and returns first match for use with the release examples.
export UVMF_HOME ?= /mnt/apps/public/COE/mg_apps/questa2025.1_1/questasim/examples/UVM_Framework/UVMF_2023.4_2

# pragma uvmf custom exports begin
#
# Project(s) specific verification IP library:
# Directory where reusable verification packages for interfaces, environments, utilities, etc. reside.
# This variable allows for your verification IP to reside independent of project bench and UVMF release directories.
# For examples deployed with UVMF this will be $(UVMF_HOME)/<example_group>/verification_ip
export UVMF_VIP_LIBRARY_HOME ?= $(PWD)/../../../verification_ip
#
# Project specific bench:
# Directory where bench specific code is located.
# This variable allows for project_benches to reside independent of verification IP and UVMF release directories.
# For examples deployed with UVMF this will be $(UVMF_HOME)/<example_group>/project_benches/<example_bench>
export UVMF_PROJECT_DIR ?= $(PWD)/..
#
#
# pragma uvmf custom exports end
# *********************************************************************************************

## Check PATH for required vinfo scripts
PVAL := $(shell command -v make_filelist.py 2> /dev/null)
ifndef PVAL
  MFLIST = $(UVMF_HOME)/scripts/make_filelist.py
else
  MFLIST = make_filelist.py
endif


# Set test case specific Variables
TEST_NAME            ?= test_top

TEST_SEED            ?= random
UVM_CLI_ARGS         = 

# Usage of Veloce, etc. to be input by the user (subject to defaults)
USE_VELOCE          ?= 0

# Usage of vinfo flow for generating file list
USE_VINFO           ?= 0

# Usage of Veloce and Questa profilers
USE_VELOCE_PROFILER ?= 0
USE_QUESTA_PROFILER ?= 0


# Set project Variables
TEST_PLAN_NAME       = fsm_TestPlan
REPORTING_DO_FILE    = fsm_reports_script


# Include makefile that includes targets for UVM_VIP_Library packages
include $(UVMF_HOME)/scripts/Makefile


# Include all requisite interface package targets for this bench
include $(UVMF_VIP_LIBRARY_HOME)/interface_packages/fsm_in_pkg/Makefile
include $(UVMF_VIP_LIBRARY_HOME)/interface_packages/fsm_out_pkg/Makefile

# Include all requisite environment package targets for this bench
include $(UVMF_VIP_LIBRARY_HOME)/environment_packages/fsm_env_pkg/Makefile



# Add to default compile/load/run arguments
VCOM_ARGS             += 

# Note: vsim-3009 error can be eliminated by adding -timescale 1ps/1ps to VLOG_ARGS

VLOG_ARGS             += $(UVM_DISABLE_FILE_LINE_CMD)

VELANALYZE_ARGS       +=
VELANALYZE_HVL_ARGS   +=

BATCH_VOPT_ARGS       +=
DEBUG_VOPT_ARGS       +=
EXTRA_VOPT_TOPS       += 
COMMON_VSIM_ARGS      +=  
COMMON_VSIM_ARGS      +=  


BATCH_VSIM_ARGS       += #-uvmcontrol=none
DEBUG_VSIM_ARGS       += 
EXTRA_VSIM_TOPS       += 

# pragma uvmf custom additional_args begin
# pragma uvmf custom additional_args end


# Project bench package source
fsm_PARAMETERS_PKG ?=\
$(UVMF_PROJECT_DIR)/tb/parameters/fsm_parameters_pkg.sv


fsm_SEQUENCES_PKG ?=\
$(UVMF_PROJECT_DIR)/tb/sequences/fsm_sequences_pkg.sv


fsm_TEST_PKG ?=\
$(UVMF_PROJECT_DIR)/tb/tests/fsm_tests_pkg.sv

# pragma uvmf custom dut_files begin
# Counter modules
fsm_COUNTERS ?=\
$(UVMF_PROJECT_DIR)/rtl/verilog/cycle_counter.v \
$(UVMF_PROJECT_DIR)/rtl/verilog/pulse_counter.v \
$(UVMF_PROJECT_DIR)/rtl/verilog/measurement_counter.v

# State machine - Golden FSM (default for Phase 1)
fsm_STATE_MACHINE ?=\
$(UVMF_PROJECT_DIR)/rtl/verilog/golden_fsm.v

# State machine - Custom FSM (uncomment for Phase 2, comment out golden above)
# fsm_STATE_MACHINE ?=\
# $(UVMF_PROJECT_DIR)/rtl/submission/state_machine.sv

# Top-level module
fsm_TOP ?=\
$(UVMF_PROJECT_DIR)/rtl/verilog/digital_top.v
# pragma uvmf custom dut_files end


# Project bench package targets
COMP_fsm_PARAMETERS_PKG_TGT_0 = q_comp_fsm_parameters_pkg
COMP_fsm_PARAMETERS_PKG_TGT_1 = v_comp_fsm_parameters_pkg
COMP_fsm_PARAMETERS_PKG_TGT = $(COMP_fsm_PARAMETERS_PKG_TGT_$(USE_VELOCE))

comp_fsm_parameters_pkg: $(COMP_fsm_PARAMETERS_PKG_TGT)

q_comp_fsm_parameters_pkg:
	        $(HVL_COMP_CMD) +incdir+$(UVMF_PROJECT_DIR)/tb/parameters $(fsm_PARAMETERS_PKG)

v_comp_fsm_parameters_pkg: q_comp_fsm_parameters_pkg
	$(HDL_COMP_CMD) +incdir+$(UVMF_PROJECT_DIR)/tb/parameters $(fsm_PARAMETERS_PKG)
 

comp_fsm_sequence_pkg:
	$(HVL_COMP_CMD) +incdir+$(UVMF_PROJECT_DIR)/tb/sequences $(fsm_SEQUENCES_PKG)

comp_fsm_tests_pkg:
	$(HVL_COMP_CMD) +incdir+$(UVMF_PROJECT_DIR)/tb/tests $(fsm_TEST_PKG)

# pragma uvmf custom dut_compile_make_target begin
# Compile counter modules
comp_fsm_counters:
	@echo "Compiling counter modules..."
	$(HDL_COMP_CMD) $(fsm_COUNTERS)

# Compile state machine (golden or custom based on fsm_STATE_MACHINE variable)
comp_fsm_state_machine:
	@echo "Compiling state machine..."
	$(HDL_COMP_CMD) $(fsm_STATE_MACHINE)

# Compile top-level module
comp_fsm_top:
	@echo "Compiling top-level module..."
	$(HDL_COMP_CMD) $(fsm_TOP)

# Compile all DUT components
comp_fsm_dut: comp_fsm_counters comp_fsm_state_machine comp_fsm_top
	@echo "DUT compilation complete"
# pragma uvmf custom dut_compile_make_target end


comp_icvip_sim:
ifeq ($(USE_VTL), 1)
else

endif

comp_icvip_emu:


BUILD_TGT_0 = make_build
BUILD_TGT_1 = vinfo_build
BUILD_TGT = $(BUILD_TGT_$(USE_VINFO))


comp_hvl : comp_hvl_core


comp_hvl_core :   \
	comp_fsm_in_pkg  comp_fsm_out_pkg  \
	comp_fsm_env_pkg \
	comp_fsm_parameters_pkg comp_fsm_sequence_pkg comp_fsm_tests_pkg 

comp_uvmf_core : comp_uvm_pkg comp_uvmf_base_pkg 

make_build: comp_fsm_dut comp_uvmf_core comp_hvl comp_test_bench  

hvl_build:  q_comp_fsm_in_pkg  q_comp_fsm_out_pkg  comp_fsm_env_pkg comp_fsm_sequence_pkg comp_fsm_tests_pkg hvl_comp_testbench link optimize


vinfo_build: comp_fsm_dut  build_hdl_vinfo build_hvl_vinfo $(VINFO_TGT)

	$(HDL_COMP_CMD) -F hdl.vf
	$(VEL_COMP)

build: $(BUILD_TGT)

emu_build: libs build link optimize

# pragma uvmf custom additional_targets begin
# pragma uvmf custom additional_targets end