//----------------------------------------------------------------------
// Created with uvmf_gen version 2023.4_2
//----------------------------------------------------------------------
// pragma uvmf custom header begin
// pragma uvmf custom header end
//----------------------------------------------------------------------
//----------------------------------------------------------------------
//                                          
// DESCRIPTION: This environment contains all agents, predictors and
// scoreboards required for the block level design.
//
//----------------------------------------------------------------------
//----------------------------------------------------------------------
//

class fsm_environment  extends uvmf_environment_base #(
    .CONFIG_T( fsm_env_configuration 
  ));
  `uvm_component_utils( fsm_environment )



  uvm_analysis_port #(fsm_in_transaction) fsm_in_ap;
  uvm_analysis_port #(fsm_out_transaction) fsm_out_ap;


  typedef fsm_in_agent  fsm_in_t;
  fsm_in_t fsm_in;

  typedef fsm_out_agent  fsm_out_t;
  fsm_out_t fsm_out;




  typedef fsm_predictor #(
                .CONFIG_T(CONFIG_T)
                )
 fsm_pred_t;
  fsm_pred_t fsm_pred;
  typedef fsm_coverage #(
                .CONFIG_T(CONFIG_T)
                )
 fsm_cov_t;
  fsm_cov_t fsm_cov;

  typedef uvmf_in_order_race_scoreboard #(.T(fsm_out_transaction))  fsm_sb_t;
  fsm_sb_t fsm_sb;



  typedef uvmf_virtual_sequencer_base #(.CONFIG_T(fsm_env_configuration)) fsm_vsqr_t;
  fsm_vsqr_t vsqr;

  // pragma uvmf custom class_item_additional begin
  // pragma uvmf custom class_item_additional end
 
// ****************************************************************************
// FUNCTION : new()
// This function is the standard SystemVerilog constructor.
//
  function new( string name = "", uvm_component parent = null );
    super.new( name, parent );
  endfunction

// ****************************************************************************
// FUNCTION: build_phase()
// This function builds all components within this environment.
//
  virtual function void build_phase(uvm_phase phase);
// pragma uvmf custom build_phase_pre_super begin
// pragma uvmf custom build_phase_pre_super end
    super.build_phase(phase);
    fsm_in_ap = new("fsm_in_ap",this);
    fsm_out_ap = new("fsm_out_ap",this);
    fsm_in = fsm_in_t::type_id::create("fsm_in",this);
    fsm_in.set_config(configuration.fsm_in_config);
    fsm_out = fsm_out_t::type_id::create("fsm_out",this);
    fsm_out.set_config(configuration.fsm_out_config);
    fsm_pred = fsm_pred_t::type_id::create("fsm_pred",this);
    fsm_pred.configuration = configuration;
    fsm_cov = fsm_cov_t::type_id::create("fsm_cov",this);
    fsm_cov.configuration = configuration;
    fsm_sb = fsm_sb_t::type_id::create("fsm_sb",this);

    vsqr = fsm_vsqr_t::type_id::create("vsqr", this);
    vsqr.set_config(configuration);
    configuration.set_vsqr(vsqr);

    // pragma uvmf custom build_phase begin
    // pragma uvmf custom build_phase end
  endfunction

// ****************************************************************************
// FUNCTION: connect_phase()
// This function makes all connections within this environment.  Connections
// typically inclue agent to predictor, predictor to scoreboard and scoreboard
// to agent.
//
  virtual function void connect_phase(uvm_phase phase);
// pragma uvmf custom connect_phase_pre_super begin
// pragma uvmf custom connect_phase_pre_super end
    super.connect_phase(phase);
    fsm_in.monitored_ap.connect(fsm_pred.fsm_in_ae);
    fsm_pred.fsm_sb_ap.connect(fsm_sb.expected_analysis_export);
    fsm_out.monitored_ap.connect(fsm_sb.actual_analysis_export);
    fsm_out.monitored_ap.connect(fsm_cov.fsm_out_ae);
    fsm_in.monitored_ap.connect(fsm_in_ap);
    fsm_out.monitored_ap.connect(fsm_out_ap);
    // pragma uvmf custom reg_model_connect_phase begin
    // pragma uvmf custom reg_model_connect_phase end
  endfunction

// ****************************************************************************
// FUNCTION: end_of_simulation_phase()
// This function is executed just prior to executing run_phase.  This function
// was added to the environment to sample environment configuration settings
// just before the simulation exits time 0.  The configuration structure is 
// randomized in the build phase before the environment structure is constructed.
// Configuration variables can be customized after randomization in the build_phase
// of the extended test.
// If a sequence modifies values in the configuration structure then the sequence is
// responsible for sampling the covergroup in the configuration if required.
//
  virtual function void start_of_simulation_phase(uvm_phase phase);
     configuration.fsm_configuration_cg.sample();
  endfunction

endclass

// pragma uvmf custom external begin
// pragma uvmf custom external end

