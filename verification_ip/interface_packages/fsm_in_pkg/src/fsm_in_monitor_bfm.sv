//----------------------------------------------------------------------
// Created with uvmf_gen version 2023.4_2
//----------------------------------------------------------------------
// pragma uvmf custom header begin
// pragma uvmf custom header end
//----------------------------------------------------------------------
//----------------------------------------------------------------------
//     
// DESCRIPTION: This interface performs the fsm_in signal monitoring.
//      It is accessed by the uvm fsm_in monitor through a virtual
//      interface handle in the fsm_in configuration.  It monitors the
//      signals passed in through the port connection named bus of
//      type fsm_in_if.
//
//     Input signals from the fsm_in_if are assigned to an internal input
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
//                   blocks until an operation on the fsm_in bus is complete.
//
//----------------------------------------------------------------------
//----------------------------------------------------------------------
//
import uvmf_base_pkg_hdl::*;
import fsm_in_pkg_hdl::*;
`include "src/fsm_in_macros.svh"


interface fsm_in_monitor_bfm 
  ( fsm_in_if  bus );
  // The pragma below and additional ones in-lined further down are for running this BFM on Veloce
  // pragma attribute fsm_in_monitor_bfm partition_interface_xif                                  

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
`fsm_in_MONITOR_STRUCT
  fsm_in_monitor_s fsm_in_monitor_struct;

  // Structure used to pass configuration data from monitor class to monitor BFM.
 `fsm_in_CONFIGURATION_STRUCT
 

  // Config value to determine if this is an initiator or a responder 
  uvmf_initiator_responder_t initiator_responder;
  // Custom configuration variables.  
  // These are set using the configure function which is called during the UVM connect_phase

  tri clk_i_i;
  tri rst_n_i_i;
  tri  comp_i_i;
  tri  analog_ready_i_i;
  tri  trigger_i_i;
  tri  interrupt_clear_i_i;
  tri  deintegrate_i_i;
  tri  interrupt_o_i;
  assign clk_i_i = bus.clk_i;
  assign rst_n_i_i = bus.rst_n_i;
  assign comp_i_i = bus.comp_i;
  assign analog_ready_i_i = bus.analog_ready_i;
  assign trigger_i_i = bus.trigger_i;
  assign interrupt_clear_i_i = bus.interrupt_clear_i;
  assign deintegrate_i_i = bus.deintegrate_i;
  assign interrupt_o_i = bus.interrupt_o;

  // Proxy handle to UVM monitor
  fsm_in_pkg::fsm_in_monitor  proxy;
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
      do_monitor( fsm_in_monitor_struct );
                                                                 
 
      proxy.notify_transaction( fsm_in_monitor_struct );
 
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
    function void configure(fsm_in_configuration_s fsm_in_configuration_arg); // pragma tbx xtf  
    initiator_responder = fsm_in_configuration_arg.initiator_responder;
  // pragma uvmf custom configure begin
  // pragma uvmf custom configure end
  endfunction   


  // ****************************************************************************  
            
  task do_monitor(output fsm_in_monitor_s fsm_in_monitor_struct);
    //
    // Available struct members:
    //     //    fsm_in_monitor_struct.comp_i
    //     //    fsm_in_monitor_struct.Measurement_count_1
    //     //    fsm_in_monitor_struct.Measurement_count_2
    //     //    fsm_in_monitor_struct.Measurement_count_3
    //     //    fsm_in_monitor_struct.Measurement_count_4
    //     //
    // pragma uvmf custom do_monitor begin
    // FSM Input Monitor - Observes the measurement sequence
    
    bit initial_comp_i;
    bit [11:0] count;
    
    // Initialize counts to 0
    fsm_in_monitor_struct.Measurement_count_1 = 12'd0;
    fsm_in_monitor_struct.Measurement_count_2 = 12'd0;
    fsm_in_monitor_struct.Measurement_count_3 = 12'd0;
    fsm_in_monitor_struct.Measurement_count_4 = 12'd0;
    
    // 1. Wait for reset to deassert
    while (rst_n_i_i === 1'b0) @(posedge clk_i_i);
    
    // 2. Capture initial comp_i value
    initial_comp_i = comp_i_i;
    fsm_in_monitor_struct.comp_i = initial_comp_i;
    
    // 3. Wait for trigger_i and analog_ready_i
    while (trigger_i_i === 1'b0 || analog_ready_i_i === 1'b0) @(posedge clk_i_i);
    
    // 4. Wait for deintegrate_i to be high
    while (deintegrate_i_i === 1'b0) @(posedge clk_i_i);
    
    // 5. Count clocks until comp_i flips (measurement_count_1)
    count = 12'd0;
    while (comp_i_i === initial_comp_i) begin
      @(posedge clk_i_i);
      count++;
    end
    fsm_in_monitor_struct.Measurement_count_1 = count;
    initial_comp_i = ~initial_comp_i; // Track the flip
    
    // 6. Check if measurement_count_1 >= 360
    if (count >= 12'd360) begin
      // Wait for interrupt_o
      while (interrupt_o_i === 1'b0) @(posedge clk_i_i);
      // Wait for interrupt_clear_i
      while (interrupt_clear_i_i === 1'b0) @(posedge clk_i_i);
    end
    else begin
      // measurement_count_1 < 360: autorange to next level
      
      // Wait for deintegrate_i again (it will go low then high)
      while (deintegrate_i_i === 1'b1) @(posedge clk_i_i);
      while (deintegrate_i_i === 1'b0) @(posedge clk_i_i);
      
      // Count clocks until comp_i flips (measurement_count_2)
      count = 12'd0;
      while (comp_i_i === initial_comp_i) begin
        @(posedge clk_i_i);
        count++;
      end
      fsm_in_monitor_struct.Measurement_count_2 = count;
      initial_comp_i = ~initial_comp_i;
      
      if (count >= 12'd360) begin
        // Wait for interrupt_o
        while (interrupt_o_i === 1'b0) @(posedge clk_i_i);
        // Wait for interrupt_clear_i
        while (interrupt_clear_i_i === 1'b0) @(posedge clk_i_i);
      end
      else begin
        // measurement_count_2 < 360: autorange to next level
        
        // Wait for deintegrate_i again
        while (deintegrate_i_i === 1'b1) @(posedge clk_i_i);
        while (deintegrate_i_i === 1'b0) @(posedge clk_i_i);
        
        // Count clocks until comp_i flips (measurement_count_3)
        count = 12'd0;
        while (comp_i_i === initial_comp_i) begin
          @(posedge clk_i_i);
          count++;
        end
        fsm_in_monitor_struct.Measurement_count_3 = count;
        initial_comp_i = ~initial_comp_i;
        
        if (count >= 12'd360) begin
          // Wait for interrupt_o
          while (interrupt_o_i === 1'b0) @(posedge clk_i_i);
          // Wait for interrupt_clear_i
          while (interrupt_clear_i_i === 1'b0) @(posedge clk_i_i);
        end
        else begin
          // measurement_count_3 < 360: final autorange level
          
          // Wait for deintegrate_i again
          while (deintegrate_i_i === 1'b1) @(posedge clk_i_i);
          while (deintegrate_i_i === 1'b0) @(posedge clk_i_i);
          
          // Count clocks until comp_i flips (measurement_count_4)
          count = 12'd0;
          while (comp_i_i === initial_comp_i) begin
            @(posedge clk_i_i);
            count++;
          end
          fsm_in_monitor_struct.Measurement_count_4 = count;
          
          // measurement_count_4 is always the last - wait for interrupt_o
          while (interrupt_o_i === 1'b0) @(posedge clk_i_i);
          // Wait for interrupt_clear_i
          while (interrupt_clear_i_i === 1'b0) @(posedge clk_i_i);
        end
      end
    end
    // pragma uvmf custom do_monitor end
  endtask         
  
 
endinterface

// pragma uvmf custom external begin
// pragma uvmf custom external end

