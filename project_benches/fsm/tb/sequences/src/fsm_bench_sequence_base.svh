//----------------------------------------------------------------------
// Created with uvmf_gen version 2023.4_2
//----------------------------------------------------------------------
// pragma uvmf custom header begin
// pragma uvmf custom header end
//----------------------------------------------------------------------
//----------------------------------------------------------------------
//
// Description: This file contains the top level and utility sequences
//     used by test_top. It can be extended to create derivative top
//     level sequences.
//
//----------------------------------------------------------------------
//
//----------------------------------------------------------------------
//


typedef fsm_env_configuration  fsm_env_configuration_t;

class fsm_bench_sequence_base extends uvmf_sequence_base #(uvm_sequence_item);

  `uvm_object_utils( fsm_bench_sequence_base );

  // pragma uvmf custom sequences begin

// This example shows how to use the environment sequence base
// It can only be used on environments generated with UVMF_2022.3 and later.
// Environment sequences generated with UVMF_2022.1 and earlier do not have the required 
//    environment level virtual sequencer
// typedef fsm_env_sequence_base #(
//         .CONFIG_T(fsm_env_configuration_t)// 
//         )
//         fsm_env_sequence_base_t;
// rand fsm_env_sequence_base_t fsm_env_seq;



  // UVMF_CHANGE_ME : Instantiate, construct, and start sequences as needed to create stimulus scenarios.
  // Instantiate sequences here
  typedef fsm_in_random_sequence  fsm_in_random_seq_t;
  fsm_in_random_seq_t fsm_in_random_seq;
  // pragma uvmf custom sequences end

  // Sequencer handles for each active interface in the environment
  typedef fsm_in_transaction  fsm_in_transaction_t;
  uvm_sequencer #(fsm_in_transaction_t)  fsm_in_sequencer; 


  // Top level environment configuration handle
  fsm_env_configuration_t top_configuration;

  // Configuration handles to access interface BFM's
  fsm_in_configuration  fsm_in_config;
  fsm_out_configuration  fsm_out_config;

  // pragma uvmf custom class_item_additional begin
  // pragma uvmf custom class_item_additional end

  // ****************************************************************************
  function new( string name = "" );
    super.new( name );
    // Retrieve the configuration handles from the uvm_config_db

    // Retrieve top level configuration handle
    if ( !uvm_config_db#(fsm_env_configuration_t)::get(null,UVMF_CONFIGURATIONS, "TOP_ENV_CONFIG",top_configuration) ) begin
      `uvm_info("CFG", "*** FATAL *** uvm_config_db::get can not find TOP_ENV_CONFIG.  Are you using an older UVMF release than what was used to generate this bench?",UVM_NONE);
      `uvm_fatal("CFG", "uvm_config_db#(fsm_env_configuration_t)::get cannot find resource TOP_ENV_CONFIG");
    end

    // Retrieve config handles for all agents
    if( !uvm_config_db #( fsm_in_configuration )::get( null , UVMF_CONFIGURATIONS , fsm_in_BFM , fsm_in_config ) ) 
      `uvm_fatal("CFG" , "uvm_config_db #( fsm_in_configuration )::get cannot find resource fsm_in_BFM" )
    if( !uvm_config_db #( fsm_out_configuration )::get( null , UVMF_CONFIGURATIONS , fsm_out_BFM , fsm_out_config ) ) 
      `uvm_fatal("CFG" , "uvm_config_db #( fsm_out_configuration )::get cannot find resource fsm_out_BFM" )

    // Assign the sequencer handles from the handles within agent configurations
    fsm_in_sequencer = fsm_in_config.get_sequencer();



    // pragma uvmf custom new begin
    // pragma uvmf custom new end

  endfunction

  // ****************************************************************************
  virtual task body();
    // pragma uvmf custom body begin

    // Construct sequences here

    // fsm_env_seq = fsm_env_sequence_base_t::type_id::create("fsm_env_seq");

    fsm_in_random_seq     = fsm_in_random_seq_t::type_id::create("fsm_in_random_seq");
    fork
      fsm_in_config.wait_for_reset();
      fsm_out_config.wait_for_reset();
    join
    // Start RESPONDER sequences here
    fork
    join_none
    // Start INITIATOR sequences here
    fork
      repeat (25) fsm_in_random_seq.start(fsm_in_sequencer);
    join

// fsm_env_seq.start(top_configuration.vsqr);

    // UVMF_CHANGE_ME : Extend the simulation XXX number of clocks after 
    // the last sequence to allow for the last sequence item to flow 
    // through the design.
    fork
      fsm_in_config.wait_for_num_clocks(400);
      fsm_out_config.wait_for_num_clocks(400);
    join

    // pragma uvmf custom body end
  endtask

endclass

// pragma uvmf custom external begin
// pragma uvmf custom external end

