//----------------------------------------------------------------------
// Created with uvmf_gen version 2023.4_2
//----------------------------------------------------------------------
// pragma uvmf custom header begin
// pragma uvmf custom header end
//----------------------------------------------------------------------
//
//----------------------------------------------------------------------
//
// DESCRIPTION: This analysis component contains analysis_exports for receiving
//   data and analysis_ports for sending data.
// 
//   This analysis component has the following analysis_exports that receive the 
//   listed transaction type.
//   
//   fsm_in_ae receives transactions of type  fsm_in_transaction
//
//   This analysis component has the following analysis_ports that can broadcast 
//   the listed transaction type.
//
//  fsm_sb_ap broadcasts transactions of type fsm_out_transaction
//----------------------------------------------------------------------
//----------------------------------------------------------------------
//

class fsm_predictor #(
  type CONFIG_T,
  type BASE_T = uvm_component
  )
 extends BASE_T;

  // Factory registration of this class
  `uvm_component_param_utils( fsm_predictor #(
                              CONFIG_T,
                              BASE_T
                              )
)


  // Instantiate a handle to the configuration of the environment in which this component resides
  CONFIG_T configuration;

  
  // Instantiate the analysis exports
  uvm_analysis_imp_fsm_in_ae #(fsm_in_transaction, fsm_predictor #(
                              .CONFIG_T(CONFIG_T),
                              .BASE_T(BASE_T)
                              )
) fsm_in_ae;

  
  // Instantiate the analysis ports
  uvm_analysis_port #(fsm_out_transaction) fsm_sb_ap;


  // Transaction variable for predicted values to be sent out fsm_sb_ap
  // Once a transaction is sent through an analysis_port, another transaction should
  // be constructed for the next predicted transaction. 
  typedef fsm_out_transaction fsm_sb_ap_output_transaction_t;
  fsm_sb_ap_output_transaction_t fsm_sb_ap_output_transaction;
  // Code for sending output transaction out through fsm_sb_ap
  // fsm_sb_ap.write(fsm_sb_ap_output_transaction);

  // Define transaction handles for debug visibility 
  fsm_in_transaction fsm_in_ae_debug;


  // pragma uvmf custom class_item_additional begin
  // pragma uvmf custom class_item_additional end

  // FUNCTION: new
  function new(string name, uvm_component parent);
     super.new(name,parent);
  // pragma uvmf custom new begin
  // pragma uvmf custom new end
  endfunction

  // FUNCTION: build_phase
  virtual function void build_phase (uvm_phase phase);

    fsm_in_ae = new("fsm_in_ae", this);
    fsm_sb_ap =new("fsm_sb_ap", this );
  // pragma uvmf custom build_phase begin
  // pragma uvmf custom build_phase end
  endfunction

  // FUNCTION: write_fsm_in_ae
  // Transactions received through fsm_in_ae initiate the execution of this function.
  // This function performs prediction of DUT output values based on DUT input, configuration and state
  virtual function void write_fsm_in_ae(fsm_in_transaction t);
    // pragma uvmf custom fsm_in_ae_predictor begin
    fsm_in_ae_debug = t;
    `uvm_info("PRED", "Transaction Received through fsm_in_ae", UVM_MEDIUM)
    `uvm_info("PRED", {"            Data: ",t.convert2string()}, UVM_FULL)
    // Construct one of each output transaction type.
    fsm_sb_ap_output_transaction = fsm_sb_ap_output_transaction_t::type_id::create("fsm_sb_ap_output_transaction");
    
    // Prediction model: Map input measurement counts to output measurement counts
    fsm_sb_ap_output_transaction.measurement_count_1 = t.Measurement_count_1;
    fsm_sb_ap_output_transaction.measurement_count_2 = t.Measurement_count_2;
    fsm_sb_ap_output_transaction.measurement_count_3 = t.Measurement_count_3;
    fsm_sb_ap_output_transaction.measurement_count_4 = t.Measurement_count_4;
    
    // ref_sign_o is set to comp_i
    fsm_sb_ap_output_transaction.ref_sign_o = ~t.comp_i;
    
    `uvm_info("PRED", {"Predicted output: ", fsm_sb_ap_output_transaction.convert2string()}, UVM_MEDIUM)
 
    // Code for sending output transaction out through fsm_sb_ap
    // Please note that each broadcasted transaction should be a different object than previously 
    // broadcasted transactions.  Creation of a different object is done by constructing the transaction 
    // using either new() or create().  Broadcasting a transaction object more than once to either the 
    // same subscriber or multiple subscribers will result in unexpected and incorrect behavior.
    fsm_sb_ap.write(fsm_sb_ap_output_transaction);
    // pragma uvmf custom fsm_in_ae_predictor end
  endfunction


endclass 

// pragma uvmf custom external begin
// pragma uvmf custom external end

