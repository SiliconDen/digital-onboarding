//----------------------------------------------------------------------
// Created with uvmf_gen version 2023.4_2
//----------------------------------------------------------------------
// pragma uvmf custom header begin
// pragma uvmf custom header end
//----------------------------------------------------------------------
//----------------------------------------------------------------------
//
// DESCRIPTION: 
//         This component is used to collect functional coverage at the environment level.
//   Coverage collection components typically do not have analysis ports for broadcasting
//   transactions.  They typically only receive transactions and sample functional coverage
//   on the transaction variables.
// 
//   This analysis component has the following analysis_exports that receive the 
//   listed transaction type.
//   
//   fsm_out_ae receives transactions of type  fsm_out_transaction  
//
//   This analysis component has the following analysis_ports that can broadcast 
//   the listed transaction type.
//
//
//----------------------------------------------------------------------
//----------------------------------------------------------------------
//


class fsm_coverage #(
  type CONFIG_T,
  type BASE_T = uvm_component
  )
 extends BASE_T;

  // Factory registration of this class
  `uvm_component_param_utils( fsm_coverage #(
                              CONFIG_T,
                              BASE_T
                              )
)

  // Instantiate a handle to the configuration of the environment in which this component resides
  CONFIG_T configuration;

  
  // Instantiate the analysis exports
  uvm_analysis_imp_fsm_out_ae #(fsm_out_transaction, fsm_coverage #(
                              .CONFIG_T(CONFIG_T),
                              .BASE_T(BASE_T)
                              )
) fsm_out_ae;




  // pragma uvmf custom class_item_additional begin
  // Scenario tracking bits
  bit normal_1_hit;
  bit overflow_1_hit;
  bit normal_2_hit;
  bit overflow_2_hit;
  bit normal_3_hit;
  bit overflow_3_hit;
  bit normal_4_hit;
  bit overflow_4_hit;
  // pragma uvmf custom class_item_additional end

// ****************************************************************************
  // Coverage for 8 measurement scenarios
  covergroup fsm_coverage_cg;
    // pragma uvmf custom covergroup begin
    option.auto_bin_max=1024;
    option.per_instance=1;
    
    // Scenario coverpoints - each scenario is a single bin that must be hit
    cp_normal_1:   coverpoint normal_1_hit   { bins hit = {1}; }
    cp_overflow_1: coverpoint overflow_1_hit { bins hit = {1}; }
    cp_normal_2:   coverpoint normal_2_hit   { bins hit = {1}; }
    cp_overflow_2: coverpoint overflow_2_hit { bins hit = {1}; }
    cp_normal_3:   coverpoint normal_3_hit   { bins hit = {1}; }
    cp_overflow_3: coverpoint overflow_3_hit { bins hit = {1}; }
    cp_normal_4:   coverpoint normal_4_hit   { bins hit = {1}; }
    cp_overflow_4: coverpoint overflow_4_hit { bins hit = {1}; }
    // pragma uvmf custom covergroup end
  endgroup


// ****************************************************************************
  // FUNCTION: new
  function new(string name, uvm_component parent);
     super.new(name,parent);
    fsm_coverage_cg=new;
  // pragma uvmf custom new begin
    // Initialize all scenario bits to 0
    normal_1_hit = 0;
    overflow_1_hit = 0;
    normal_2_hit = 0;
    overflow_2_hit = 0;
    normal_3_hit = 0;
    overflow_3_hit = 0;
    normal_4_hit = 0;
    overflow_4_hit = 0;
  // pragma uvmf custom new end
  endfunction

// ****************************************************************************
  // FUNCTION: build_phase
  virtual function void build_phase (uvm_phase phase);

    fsm_coverage_cg.set_inst_name($sformatf("fsm_coverage_cg_%s",get_full_name()));

    fsm_out_ae = new("fsm_out_ae", this);
  // pragma uvmf custom build_phase begin
  // pragma uvmf custom build_phase end
  endfunction

  // ****************************************************************************
  // FUNCTION: write_fsm_out_ae
  // Transactions received through fsm_out_ae initiate the execution of this function.
  // This function collects functional coverage on variables within the received transaction
  virtual function void write_fsm_out_ae(fsm_out_transaction t);
    // pragma uvmf custom fsm_out_ae_coverage begin
    `uvm_info("COV", "Transaction Received through fsm_out_ae", UVM_MEDIUM)
    `uvm_info("COV", {"            Data: ",t.convert2string()}, UVM_FULL)

    // Detect scenario and set corresponding bit
    // Scenario 1: measurement_count_1 determines result (no underrange)
    if (t.measurement_count_1 >= 12'd360 && t.measurement_count_1 < 12'd4000) begin
      normal_1_hit = 1;
      `uvm_info("COV", "Scenario: normal_1 detected", UVM_MEDIUM)
    end
    else if (t.measurement_count_1 == 12'd4000) begin
      overflow_1_hit = 1;
      `uvm_info("COV", "Scenario: overflow_1 detected", UVM_MEDIUM)
    end
    // Scenario 2: measurement_count_1 underrange, measurement_count_2 determines result
    else if (t.measurement_count_1 < 12'd360) begin
      if (t.measurement_count_2 >= 12'd360 && t.measurement_count_2 < 12'd4000) begin
        normal_2_hit = 1;
        `uvm_info("COV", "Scenario: normal_2 detected", UVM_MEDIUM)
      end
      else if (t.measurement_count_2 == 12'd4000) begin
        overflow_2_hit = 1;
        `uvm_info("COV", "Scenario: overflow_2 detected", UVM_MEDIUM)
      end
      // Scenario 3: measurement_count_1 & 2 underrange, measurement_count_3 determines result
      else if (t.measurement_count_2 < 12'd360) begin
        if (t.measurement_count_3 >= 12'd360 && t.measurement_count_3 < 12'd4000) begin
          normal_3_hit = 1;
          `uvm_info("COV", "Scenario: normal_3 detected", UVM_MEDIUM)
        end
        else if (t.measurement_count_3 == 12'd4000) begin
          overflow_3_hit = 1;
          `uvm_info("COV", "Scenario: overflow_3 detected", UVM_MEDIUM)
        end
        // Scenario 4: measurement_count_1, 2 & 3 underrange, measurement_count_4 determines result
        else if (t.measurement_count_3 < 12'd360) begin
          if (t.measurement_count_4 >= 12'd360 && t.measurement_count_4 < 12'd4000) begin
            normal_4_hit = 1;
            `uvm_info("COV", "Scenario: normal_4 detected", UVM_MEDIUM)
          end
          else if (t.measurement_count_4 == 12'd4000) begin
            overflow_4_hit = 1;
            `uvm_info("COV", "Scenario: overflow_4 detected", UVM_MEDIUM)
          end
        end
      end
    end

    // Sample the covergroup
    fsm_coverage_cg.sample();
    // pragma uvmf custom fsm_out_ae_coverage end
  endfunction

  // ****************************************************************************
  // FUNCTION: report_phase
  // Print final coverage percentage at end of simulation
  virtual function void report_phase(uvm_phase phase);
    real cov_pct;
    int scenarios_hit;
    
    // Calculate scenarios hit
    scenarios_hit = normal_1_hit + overflow_1_hit + 
                    normal_2_hit + overflow_2_hit + 
                    normal_3_hit + overflow_3_hit + 
                    normal_4_hit + overflow_4_hit;
    
    // Get covergroup coverage percentage
    cov_pct = fsm_coverage_cg.get_inst_coverage();
    
    `uvm_info("COV_REPORT", "========================================", UVM_NONE)
    `uvm_info("COV_REPORT", "    FSM SCENARIO COVERAGE REPORT", UVM_NONE)
    `uvm_info("COV_REPORT", "========================================", UVM_NONE)
    `uvm_info("COV_REPORT", $sformatf("  normal_1:   %s", normal_1_hit ? "HIT" : "MISS"), UVM_NONE)
    `uvm_info("COV_REPORT", $sformatf("  overflow_1: %s", overflow_1_hit ? "HIT" : "MISS"), UVM_NONE)
    `uvm_info("COV_REPORT", $sformatf("  normal_2:   %s", normal_2_hit ? "HIT" : "MISS"), UVM_NONE)
    `uvm_info("COV_REPORT", $sformatf("  overflow_2: %s", overflow_2_hit ? "HIT" : "MISS"), UVM_NONE)
    `uvm_info("COV_REPORT", $sformatf("  normal_3:   %s", normal_3_hit ? "HIT" : "MISS"), UVM_NONE)
    `uvm_info("COV_REPORT", $sformatf("  overflow_3: %s", overflow_3_hit ? "HIT" : "MISS"), UVM_NONE)
    `uvm_info("COV_REPORT", $sformatf("  normal_4:   %s", normal_4_hit ? "HIT" : "MISS"), UVM_NONE)
    `uvm_info("COV_REPORT", $sformatf("  overflow_4: %s", overflow_4_hit ? "HIT" : "MISS"), UVM_NONE)
    `uvm_info("COV_REPORT", "----------------------------------------", UVM_NONE)
    `uvm_info("COV_REPORT", $sformatf("  Scenarios Hit: %0d / 8", scenarios_hit), UVM_NONE)
    `uvm_info("COV_REPORT", $sformatf("  Coverage: %.2f%%", cov_pct), UVM_NONE)
    `uvm_info("COV_REPORT", "========================================", UVM_NONE)
  endfunction

endclass 

// pragma uvmf custom external begin
// pragma uvmf custom external end

