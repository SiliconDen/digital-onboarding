module load questa
export UVMF_HOME=/mnt/apps/public/COE/mg_apps/questa2025.1_1/questasim/examples/UVM_Framework/UVMF_2023.4_2
export QUESTA_HOME=/mnt/apps/public/COE/mg_apps/questa2025.1_1/questasim
make clean
export PATH=$QUESTA_HOME/bin:$PATH
/usr/bin/python3.11 $UVMF_HOME/scripts/uvmf_bcr.py questa live:True enable_trlog:True use_vis_uvm:True code_cov_enable:True
