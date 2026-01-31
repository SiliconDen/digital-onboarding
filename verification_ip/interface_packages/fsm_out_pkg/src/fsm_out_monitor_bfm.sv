//----------------------------------------------------------------------
// Created with uvmf_gen version 2023.4_2
//----------------------------------------------------------------------
// pragma uvmf custom header begin
// pragma uvmf custom header end
//----------------------------------------------------------------------
//----------------------------------------------------------------------
//     
// DESCRIPTION: This interface performs the fsm_out signal monitoring.
//      It is accessed by the uvm fsm_out monitor through a virtual
//      interface handle in the fsm_out configuration.  It monitors the
//      signals passed in through the port connection named bus of
//      type fsm_out_if.
//
//     Input signals from the fsm_out_if are assigned to an internal input
//     signal with a _i suffix.  The _i signal should be used for sampling.
//
//     The input signal connections are as follows:
//       bus.signal -> signal_i 
//
//      Interface functions and tasks used by UVM components:
//             monitor(inout TRANS_T txn);
//                   This task receives the transaction, txn, from the
//                   UVM monitor and then populates variables in txn
//                   from values observed on bus activity.  This task
//                   blocks until an operation on the fsm_out bus is complete.
//
//----------------------------------------------------------------------
//----------------------------------------------------------------------
//
import uvmf_base_pkg_hdl::*;
import fsm_out_pkg_hdl::*;
`include "src/fsm_out_macros.svh"


interface fsm_out_monitor_bfm 
  ( fsm_out_if  bus );
  // The pragma below and additional ones in-lined further down are for running this BFM on Veloce
  // pragma attribute fsm_out_monitor_bfm partition_interface_xif                                  

`ifndef XRTL
// This code is to aid in debugging parameter mismatches between the BFM and its corresponding agent.
// Enable this debug by setting UVM_VERBOSITY to UVM_DEBUG
// Setting UVM_VERBOSITY to UVM_DEBUG causes all BFM's and all agents to display their parameter settings.
// All of the messages from this feature have a UVM messaging id value of "CFG"
// The transcript or run.log can be parsed to ensure BFM parameter settings match its corresponding agents parameter settings.
import uvm_pkg::*;
`include "uvm_macros.svh"
initial begin : bfm_vs_agent_parameter_debug
  `uvm_info("CFG", 
      $psprintf("The BFM at '%m' has the following parameters: ", ),
      UVM_DEBUG)
end
`endif


  // Structure used to pass transaction data from monitor BFM to monitor class in agent.
`fsm_out_MONITOR_STRUCT
  fsm_out_monitor_s fsm_out_monitor_struct;

  // Structure used to pass configuration data from monitor class to monitor BFM.
 `fsm_out_CONFIGURATION_STRUCT
 

  // Config value to determine if this is an initiator or a responder 
  uvmf_initiator_responder_t initiator_responder;
  // Custom configuration variables.  
  // These are set using the configure function which is called during the UVM connect_phase

  tri clk_i_i;
  tri rst_n_i_i;
  tri  idle_o_i;
  tri  auto_zero_o_i;
  tri  integrate_o_i;
  tri  deintegrate_o_i;
  tri  ref_sign_o_i;
  tri  interrupt_o_i;
  tri [11:0] measurement_count_o_i;
  assign clk_i_i = bus.clk_i;
  assign rst_n_i_i = bus.rst_n_i;
  assign idle_o_i = bus.idle_o;
  assign auto_zero_o_i = bus.auto_zero_o;
  assign integrate_o_i = bus.integrate_o;
  assign deintegrate_o_i = bus.deintegrate_o;
  assign ref_sign_o_i = bus.ref_sign_o;
  assign interrupt_o_i = bus.interrupt_o;
  assign measurement_count_o_i = bus.measurement_count_o;

  // Proxy handle to UVM monitor
  fsm_out_pkg::fsm_out_monitor  proxy;
  // pragma tbx oneway proxy.notify_transaction                 

  // pragma uvmf custom interface_item_additional begin
  // pragma uvmf custom interface_item_additional end
  
  //******************************************************************                         
  task wait_for_reset();// pragma tbx xtf  
    @(posedge clk_i_i) ;                                                                    
    do_wait_for_reset();                                                                   
  endtask                                                                                   

  // ****************************************************************************              
  task do_wait_for_reset(); 
  // pragma uvmf custom reset_condition begin
    wait ( rst_n_i_i === 1 ) ;                                                              
    @(posedge clk_i_i) ;                                                                    
  // pragma uvmf custom reset_condition end                                                                
  endtask    

  //******************************************************************                         
 
  task wait_for_num_clocks(input int unsigned count); // pragma tbx xtf 
    @(posedge clk_i_i);  
                                                                   
    repeat (count-1) @(posedge clk_i_i);                                                    
  endtask      

  //******************************************************************                         
  event go;                                                                                 
  function void start_monitoring();// pragma tbx xtf    
    -> go;
  endfunction                                                                               
  
  // ****************************************************************************              
  initial begin                                                                             
    @go;                                                                                   
    forever begin                                                                        
      @(posedge clk_i_i);  
      do_monitor( fsm_out_monitor_struct );
                                                                 
 
      proxy.notify_transaction( fsm_out_monitor_struct );
 
    end                                                                                    
  end                                                                                       

  //******************************************************************
  // The configure() function is used to pass agent configuration
  // variables to the monitor BFM.  It is called by the monitor within
  // the agent at the beginning of the simulation.  It may be called 
  // during the simulation if agent configuration variables are updated
  // and the monitor BFM needs to be aware of the new configuration 
  // variables.
  //
    function void configure(fsm_out_configuration_s fsm_out_configuration_arg); // pragma tbx xtf  
    initiator_responder = fsm_out_configuration_arg.initiator_responder;
  // pragma uvmf custom configure begin
  // pragma uvmf custom configure end
  endfunction   


  // ****************************************************************************  
            
  task do_monitor(output fsm_out_monitor_s fsm_out_monitor_struct);
    //
    // Available struct members:
    //     //    fsm_out_monitor_struct.ref_sign_o
    //     //    fsm_out_monitor_struct.measurement_count_1
    //     //    fsm_out_monitor_struct.measurement_count_2
    //     //    fsm_out_monitor_struct.measurement_count_3
    //     //    fsm_out_monitor_struct.measurement_count_4
    //     //
    // Reference code;
    //    How to wait for signal value
    //      while (control_signal === 1'b1) @(posedge clk_i_i);
    //    
    //    How to assign a struct member, named xyz, from a signal.   
    //    All available input signals listed.
    //      fsm_out_monitor_struct.xyz = idle_o_i;  //     
    //      fsm_out_monitor_struct.xyz = auto_zero_o_i;  //     
    //      fsm_out_monitor_struct.xyz = integrate_o_i;  //     
    //      fsm_out_monitor_struct.xyz = deintegrate_o_i;  //     
    //      fsm_out_monitor_struct.xyz = ref_sign_o_i;  //     
    //      fsm_out_monitor_struct.xyz = interrupt_o_i;  //     
    //      fsm_out_monitor_struct.xyz = measurement_count_o_i;  //    [11:0] 
    // pragma uvmf custom do_monitor begin
    // UVMF_CHANGE_ME : Implement protocol monitoring.  The commented reference code 
    // below are examples of how to capture signal values and assign them to 
    // structure members.  All available input signals are listed.  The 'while' 
    // code example shows how to wait for a synchronous flow control signal.  This
    // task should return when a complete transfer has been observed.  Once this task is
    // exited with captured values, it is then called again to wait for and observe 
    // the next transfer. One clock cycle is consumed between calls to do_monitor.
    @(posedge clk_i_i);
    @(posedge clk_i_i);
    @(posedge clk_i_i);
    @(posedge clk_i_i);
    // pragma uvmf custom do_monitor end
  endtask         
  
 
endinterface

// pragma uvmf custom external begin
// pragma uvmf custom external end

