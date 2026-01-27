export UVMF_HOME=/mnt/apps/public/COE/mg_apps/questa2025.1_1/questasim/examples/UVM_Framework/UVMF_2023.4_2
export QUESTA_HOME=/mnt/apps/public/COE/mg_apps/questa2025.1_1/questasim
make clean
export PATH=$QUESTA_HOME/bin:$PATH
/usr/bin/python3.11 $UVMF_HOME/scripts/uvmf_bcr.py questa live:False enable_trlog:True use_vis_uvm:True code_cov_enable:True
#xml2ucdb -format Excel ./lc3_testplan.xml ./test_plan.ucdb
#vcover merge -stats=none -strip 0 -totals merged.ucdb ./*.ucdb
#vsim -viewcov merged.ucdb
#vcover report -details -output coverage_report.txt merged.ucdb
