export UVMF_HOME=/mnt/apps/public/COE/mg_apps/questa2025.1_1/questasim/examples/UVM_Framework/UVMF_2023.4_2
OUTPUT_DIR="../"

# Clear out the uvmf_output directory before generating new files
echo "Clearing uvmf_output directory..."
rm -rf "$OUTPUT_DIR"

# Generate new UVMF files from YAML configurations
echo "Generating UVMF files from YAML configurations..."
python3.11 "$UVMF_HOME/scripts/yaml2uvmf.py" *.yaml -d $OUTPUT_DIR

echo "Generation complete!"