//----------------------------------------------------------------------
// Created with uvmf_gen version 2023.4_2
//----------------------------------------------------------------------
// pragma uvmf custom header begin
// pragma uvmf custom header end
//----------------------------------------------------------------------
//----------------------------------------------------------------------
//     
// DESCRIPTION: This class records fsm_out transaction information using
//       a covergroup named fsm_out_transaction_cg.  An instance of this
//       coverage component is instantiated in the uvmf_parameterized_agent
//       if the has_coverage flag is set.
//
//----------------------------------------------------------------------
//----------------------------------------------------------------------
//
class fsm_out_transaction_coverage  extends uvm_subscriber #(.T(fsm_out_transaction ));

  `uvm_component_utils( fsm_out_transaction_coverage )

  T coverage_trans;

  // pragma uvmf custom class_item_additional begin
  // pragma uvmf custom class_item_additional end
  
  // ****************************************************************************
  covergroup fsm_out_transaction_cg;
    // pragma uvmf custom covergroup begin
    // UVMF_CHANGE_ME : Add coverage bins, crosses, exclusions, etc. according to coverage needs.
    option.auto_bin_max=1024;
    option.per_instance=1;
    idle_o: coverpoint coverage_trans.idle_o;
    auto_zero_o: coverpoint coverage_trans.auto_zero_o;
    integrate_o: coverpoint coverage_trans.integrate_o;
    deintegrate_o: coverpoint coverage_trans.deintegrate_o;
    ref_sign_o: coverpoint coverage_trans.ref_sign_o;
    interrupt_o: coverpoint coverage_trans.interrupt_o;
    measurement_count_o: coverpoint coverage_trans.measurement_count_o;
    // pragma uvmf custom covergroup end
  endgroup

  // ****************************************************************************
  // FUNCTION : new()
  // This function is the standard SystemVerilog constructor.
  //
  function new(string name="", uvm_component parent=null);
    super.new(name,parent);
    fsm_out_transaction_cg=new;
    `uvm_warning("COVERAGE_MODEL_REVIEW", "A covergroup has been constructed which may need review because of either generation or re-generation with merging.  Please note that transaction variables added as a result of re-generation and merging are not automatically added to the covergroup.  Remove this warning after the covergroup has been reviewed.")
  endfunction

  // ****************************************************************************
  // FUNCTION : build_phase()
  // This function is the standard UVM build_phase.
  //
  function void build_phase(uvm_phase phase);
    fsm_out_transaction_cg.set_inst_name($sformatf("fsm_out_transaction_cg_%s",get_full_name()));
  endfunction

  // ****************************************************************************
  // FUNCTION: write (T t)
  // This function is automatically executed when a transaction arrives on the
  // analysis_export.  It copies values from the variables in the transaction 
  // to local variables used to collect functional coverage.  
  //
  virtual function void write (T t);
    `uvm_info("COV","Received transaction",UVM_HIGH);
    coverage_trans = t;
    fsm_out_transaction_cg.sample();
  endfunction

endclass

// pragma uvmf custom external begin
// pragma uvmf custom external end

