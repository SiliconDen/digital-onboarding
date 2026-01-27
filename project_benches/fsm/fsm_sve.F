
// UVM
+incdir+${UVM_HOME}/src
${UVM_HOME}/src/uvm_pkg.sv

// Common UVMF files
-f ${UVMF_HOME}/common/common_sve.f

// BFM Files
-F ${UVMF_VIP_LIBRARY_HOME}/interface_packages/fsm_in_pkg/fsm_in_pkg_sve.F
-F ${UVMF_VIP_LIBRARY_HOME}/interface_packages/fsm_out_pkg/fsm_out_pkg_sve.F

// Environment Files
-F ${UVMF_VIP_LIBRARY_HOME}/environment_packages/fsm_env_pkg/fsm_env_pkg_sve.F

// Bench Files
+incdir+./tb/tests
./tb/tests/fsm_tests_pkg.sv

+incdir+./tb/sequences
./tb/sequences/fsm_sequences_pkg.sv

+incdir+./tb/parameters
./tb/parameters/fsm_parameters_pkg.sv

./tb/testbench/hdl_top.sv
./tb/testbench/hvl_top.sv

