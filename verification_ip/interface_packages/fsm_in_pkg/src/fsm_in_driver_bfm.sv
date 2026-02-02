//----------------------------------------------------------------------
// Created with uvmf_gen version 2023.4_2
//----------------------------------------------------------------------
// pragma uvmf custom header begin
// pragma uvmf custom header end
//----------------------------------------------------------------------
//----------------------------------------------------------------------
//     
// DESCRIPTION: 
//    This interface performs the fsm_in signal driving.  It is
//     accessed by the uvm fsm_in driver through a virtual interface
//     handle in the fsm_in configuration.  It drives the singals passed
//     in through the port connection named bus of type fsm_in_if.
//
//     Input signals from the fsm_in_if are assigned to an internal input
//     signal with a _i suffix.  The _i signal should be used for sampling.
//
//     The input signal connections are as follows:
//       bus.signal -> signal_i 
//
//     This bfm drives signals with a _o suffix.  These signals
//     are driven onto signals within fsm_in_if based on INITIATOR/RESPONDER and/or
//     ARBITRATION/GRANT status.  
//
//     The output signal connections are as follows:
//        signal_o -> bus.signal
//
//                                                                                           
//      Interface functions and tasks used by UVM components:
//
//             configure:
//                   This function gets configuration attributes from the
//                   UVM driver to set any required BFM configuration
//                   variables such as 'initiator_responder'.                                       
//                                                                                           
//             initiate_and_get_response:
//                   This task is used to perform signaling activity for initiating
//                   a protocol transfer.  The task initiates the transfer, using
//                   input data from the initiator struct.  Then the task captures
//                   response data, placing the data into the response struct.
//                   The response struct is returned to the driver class.
//
//             respond_and_wait_for_next_transfer:
//                   This task is used to complete a current transfer as a responder
//                   and then wait for the initiator to start the next transfer.
//                   The task uses data in the responder struct to drive protocol
//                   signals to complete the transfer.  The task then waits for 
//                   the next transfer.  Once the next transfer begins, data from
//                   the initiator is placed into the initiator struct and sent
//                   to the responder sequence for processing to determine 
//                   what data to respond with.
//
//----------------------------------------------------------------------
//----------------------------------------------------------------------
//
import uvmf_base_pkg_hdl::*;
import fsm_in_pkg_hdl::*;
`include "src/fsm_in_macros.svh"

interface fsm_in_driver_bfm 
  (fsm_in_if bus);
  // The following pragma and additional ones in-lined further below are for running this BFM on Veloce
  // pragma attribute fsm_in_driver_bfm partition_interface_xif

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

  // Config value to determine if this is an initiator or a responder 
  uvmf_initiator_responder_t initiator_responder;
  // Custom configuration variables.  
  // These are set using the configure function which is called during the UVM connect_phase

  tri clk_i_i;
  tri rst_n_i_i;

  // Signal list (all signals are capable of being inputs and outputs for the sake
  // of supporting both INITIATOR and RESPONDER mode operation. Expectation is that 
  // directionality in the config file was from the point-of-view of the INITIATOR

  // INITIATOR mode input signals
  tri  comp_i_i;
  reg  comp_i_o = 1'b0;
  tri  analog_ready_i_i;
  reg  analog_ready_i_o = 1'b0;
  tri  trigger_i_i;
  reg  trigger_i_o = 1'b0;
  tri  interrupt_clear_i_i;
  reg  interrupt_clear_i_o = 1'b0;
  tri  deintegrate_i_i;
  reg  deintegrate_i_o = 1'b0;
  tri  interrupt_o_i;

  // INITIATOR mode output signals

  // Bi-directional signals
  

  assign clk_i_i = bus.clk_i;
  assign rst_n_i_i = bus.rst_n_i;

  // These are signals marked as 'input' by the config file, but the signals will be
  // driven by this BFM if put into RESPONDER mode (flipping all signal directions around)
  // For INITIATOR mode, we drive comp_i, interrupt_clear_i, trigger_i, analog_ready_i (stimulus to DUT)
  assign comp_i_i = bus.comp_i;
  assign bus.comp_i = (initiator_responder == INITIATOR) ? comp_i_o : 'bz;
  assign analog_ready_i_i = bus.analog_ready_i;
  assign bus.analog_ready_i = (initiator_responder == INITIATOR) ? analog_ready_i_o : 'bz;
  assign trigger_i_i = bus.trigger_i;
  assign bus.trigger_i = (initiator_responder == INITIATOR) ? trigger_i_o : 'bz;
  assign interrupt_clear_i_i = bus.interrupt_clear_i;
  assign bus.interrupt_clear_i = (initiator_responder == INITIATOR) ? interrupt_clear_i_o : 'bz;
  assign deintegrate_i_i = bus.deintegrate_i;
  assign bus.deintegrate_i = (initiator_responder == RESPONDER) ? deintegrate_i_o : 'bz;
  // Observe interrupt_o from DUT
  assign interrupt_o_i = bus.interrupt_o;


  // These are signals marked as 'output' by the config file, but the outputs will
  // not be driven by this BFM unless placed in INITIATOR mode.

  // Proxy handle to UVM driver
  fsm_in_pkg::fsm_in_driver   proxy;
  // pragma tbx oneway proxy.my_function_name_in_uvm_driver                 

  // ****************************************************************************
  // **************************************************************************** 
  // Macros that define structs located in fsm_in_macros.svh
  // ****************************************************************************
  // Struct for passing configuration data from fsm_in_driver to this BFM
  // ****************************************************************************
  `fsm_in_CONFIGURATION_STRUCT
  // ****************************************************************************
  // Structs for INITIATOR and RESPONDER data flow
  //*******************************************************************
  // Initiator macro used by fsm_in_driver and fsm_in_driver_bfm
  // to communicate initiator driven data to fsm_in_driver_bfm.           
  `fsm_in_INITIATOR_STRUCT
    fsm_in_initiator_s initiator_struct;
  // Responder macro used by fsm_in_driver and fsm_in_driver_bfm
  // to communicate Responder driven data to fsm_in_driver_bfm.
  `fsm_in_RESPONDER_STRUCT
    fsm_in_responder_s responder_struct;

  // ****************************************************************************
// pragma uvmf custom reset_condition_and_response begin
  // Always block used to return signals to reset value upon assertion of reset
  always @( negedge rst_n_i_i )
     begin
       // RESPONDER mode output signals
       comp_i_o <= 1'b0;
       analog_ready_i_o <= 1'b0;
       trigger_i_o <= 1'b0;
       interrupt_clear_i_o <= 1'b0;
       deintegrate_i_o <= 1'b0;
       // INITIATOR mode output signals
       // Bi-directional signals
 
     end    
// pragma uvmf custom reset_condition_and_response end

  // pragma uvmf custom interface_item_additional begin
  // pragma uvmf custom interface_item_additional end

  //******************************************************************
  // The configure() function is used to pass agent configuration
  // variables to the driver BFM.  It is called by the driver within
  // the agent at the beginning of the simulation.  It may be called 
  // during the simulation if agent configuration variables are updated
  // and the driver BFM needs to be aware of the new configuration 
  // variables.
  //

  function void configure(fsm_in_configuration_s fsm_in_configuration_arg); // pragma tbx xtf  
    initiator_responder = fsm_in_configuration_arg.initiator_responder;
  // pragma uvmf custom configure begin
  // pragma uvmf custom configure end
  endfunction                                                                             

// pragma uvmf custom initiate_and_get_response begin
// ****************************************************************************
// FSM Input Driver - Initiator Mode
// This task drives the measurement sequence based on transaction data
    task initiate_and_get_response( 
       // This argument passes transaction variables used by an initiator
       // to perform the initial part of a protocol transfer.  The values
       // come from a sequence item created in a sequence.
       input fsm_in_initiator_s fsm_in_initiator_struct, 
       // This argument is used to send data received from the responder
       // back to the sequence item.  The sequence item is returned to the sequence.
       output fsm_in_responder_s fsm_in_responder_struct 
       );// pragma tbx xtf  
       // 
       // Members within the fsm_in_initiator_struct:
       //   bit comp_i ;
       //   bit [11:0] Measurement_count_1 ;
       //   bit [11:0] Measurement_count_2 ;
       //   bit [11:0] Measurement_count_3 ;
       //   bit [11:0] Measurement_count_4 ;
       // Members within the fsm_in_responder_struct:
       //   bit comp_i ;
       //   bit [11:0] Measurement_count_1 ;
       //   bit [11:0] Measurement_count_2 ;
       //   bit [11:0] Measurement_count_3 ;
       //   bit [11:0] Measurement_count_4 ;
       
       int i;
       
       initiator_struct = fsm_in_initiator_struct;
       
       // 1. Initialize all outputs
       comp_i_o <= fsm_in_initiator_struct.comp_i;
       interrupt_clear_i_o <= 1'b0;
       trigger_i_o <= 1'b0;
       analog_ready_i_o <= 1'b1;
       
       // 2. Wait for reset to deassert
       while (rst_n_i_i == 1'b0) @(posedge clk_i_i);
       
       // 3. Assert trigger_i to start measurement
       trigger_i_o <= 1'b1;
       @(posedge clk_i_i);
       trigger_i_o <= 1'b0;
       
       // 4. Wait for deintegrate_i to be high (measurement started)
       while (deintegrate_i_i == 1'b0) @(posedge clk_i_i);
       
       // 5. Wait measurement_count_1 # of clocks, then flip comp_i
       for (i = 0; i < fsm_in_initiator_struct.Measurement_count_1; i++) @(posedge clk_i_i);
       comp_i_o <= ~comp_i_o;
       
       // 6. Check if measurement_count_1 >= 360
       if (fsm_in_initiator_struct.Measurement_count_1 >= 12'd360) begin
         // Wait for interrupt_o
         while (interrupt_o_i == 1'b0) @(posedge clk_i_i);
         // Assert interrupt_clear_i
         interrupt_clear_i_o <= 1'b1;
         @(posedge clk_i_i);
         interrupt_clear_i_o <= 1'b0;
       end
       else begin
         // measurement_count_1 < 360: autorange to next level
         
         // Wait for deintegrate_i again
         while (deintegrate_i_i == 1'b0) @(posedge clk_i_i);
         
         // Wait measurement_count_2 # of clocks, then flip comp_i
         for (i = 0; i < fsm_in_initiator_struct.Measurement_count_2; i++) @(posedge clk_i_i);
         comp_i_o <= ~comp_i_o;
         
         if (fsm_in_initiator_struct.Measurement_count_2 >= 12'd360) begin
           // Wait for interrupt_o
           while (interrupt_o_i == 1'b0) @(posedge clk_i_i);
           // Assert interrupt_clear_i
           interrupt_clear_i_o <= 1'b1;
           @(posedge clk_i_i);
           interrupt_clear_i_o <= 1'b0;
         end
         else begin
           // measurement_count_2 < 360: autorange to next level
           
           // Wait for deintegrate_i again
           while (deintegrate_i_i == 1'b0) @(posedge clk_i_i);
           
           // Wait measurement_count_3 # of clocks, then flip comp_i
           for (i = 0; i < fsm_in_initiator_struct.Measurement_count_3; i++) @(posedge clk_i_i);
           comp_i_o <= ~comp_i_o;
           
           if (fsm_in_initiator_struct.Measurement_count_3 >= 12'd360) begin
             // Wait for interrupt_o
             while (interrupt_o_i == 1'b0) @(posedge clk_i_i);
             // Assert interrupt_clear_i
             interrupt_clear_i_o <= 1'b1;
             @(posedge clk_i_i);
             interrupt_clear_i_o <= 1'b0;
           end
           else begin
             // measurement_count_3 < 360: final autorange level
             
             // Wait for deintegrate_i again
             while (deintegrate_i_i == 1'b0) @(posedge clk_i_i);
             
             // Wait measurement_count_4 # of clocks, then flip comp_i
             for (i = 0; i < fsm_in_initiator_struct.Measurement_count_4; i++) @(posedge clk_i_i);
             comp_i_o <= ~comp_i_o;
             
             // measurement_count_4 is always the last - wait for interrupt_o regardless
             while (interrupt_o_i == 1'b0) @(posedge clk_i_i);
             // Assert interrupt_clear_i
             interrupt_clear_i_o <= 1'b1;
             @(posedge clk_i_i);
             interrupt_clear_i_o <= 1'b0;
           end
         end
       end
       
       // Copy results to responder struct
       fsm_in_responder_struct.comp_i = comp_i_o;
       fsm_in_responder_struct.Measurement_count_1 = fsm_in_initiator_struct.Measurement_count_1;
       fsm_in_responder_struct.Measurement_count_2 = fsm_in_initiator_struct.Measurement_count_2;
       fsm_in_responder_struct.Measurement_count_3 = fsm_in_initiator_struct.Measurement_count_3;
       fsm_in_responder_struct.Measurement_count_4 = fsm_in_initiator_struct.Measurement_count_4;
       
       responder_struct = fsm_in_responder_struct;
  endtask        
// pragma uvmf custom initiate_and_get_response end

// pragma uvmf custom respond_and_wait_for_next_transfer begin
// ****************************************************************************
// The first_transfer variable is used to prevent completing a transfer in the 
// first call to this task.  For the first call to this task, there is not
// current transfer to complete.
bit first_transfer=1;

// UVMF_CHANGE_ME
// This task is used by a responder.  The task first completes the current 
// transfer in progress then waits for the initiator to start the next transfer.
  task respond_and_wait_for_next_transfer( 
       // This argument is used to send data received from the initiator
       // back to the sequence item.  The sequence determines how to respond.
       output fsm_in_initiator_s fsm_in_initiator_struct, 
       // This argument passes transaction variables used by a responder
       // to complete a protocol transfer.  The values come from a sequence item.       
       input fsm_in_responder_s fsm_in_responder_struct 
       );// pragma tbx xtf   
  // Variables within the fsm_in_initiator_struct:
  //   bit comp_i ;
  //   bit [11:0] Measurement_count_1 ;
  //   bit [11:0] Measurement_count_2 ;
  //   bit [11:0] Measurement_count_3 ;
  //   bit [11:0] Measurement_count_4 ;
  // Variables within the fsm_in_responder_struct:
  //   bit comp_i ;
  //   bit [11:0] Measurement_count_1 ;
  //   bit [11:0] Measurement_count_2 ;
  //   bit [11:0] Measurement_count_3 ;
  //   bit [11:0] Measurement_count_4 ;
       // Reference code;
       //    How to wait for signal value
       //      while (control_signal == 1'b1) @(posedge clk_i_i);
       //    
       //    How to assign a initiator struct member, named xyz, from a signal.   
       //    All available responder input and inout signals listed.
       //    Responder input signals
       //    Responder inout signals
       //    How to assign a signal, named xyz, from an responder struct member.   
       //    All available responder output and inout signals listed.
       //    Notice the _o.  Those are storage variables that allow for procedural assignment.
       //    Responder output signals
       //      comp_i_o <= fsm_in_responder_struct.xyz;  //     
       //      analog_ready_i_o <= fsm_in_responder_struct.xyz;  //     
       //      trigger_i_o <= fsm_in_responder_struct.xyz;  //     
       //      interrupt_clear_i_o <= fsm_in_responder_struct.xyz;  //     
       //      deintegrate_i_o <= fsm_in_responder_struct.xyz;  //     
       //    Responder inout signals
    
  @(posedge clk_i_i);
  if (!first_transfer) begin
    // Perform transfer response here.   
    // Reply using data recieved in the fsm_in_responder_struct.
    @(posedge clk_i_i);
    // Reply using data recieved in the transaction handle.
    @(posedge clk_i_i);
  end
    // Wait for next transfer then gather info from intiator about the transfer.
    // Place the data into the fsm_in_initiator_struct.
    @(posedge clk_i_i);
    @(posedge clk_i_i);
    first_transfer = 0;
  endtask
// pragma uvmf custom respond_and_wait_for_next_transfer end

 
endinterface

// pragma uvmf custom external begin
// pragma uvmf custom external end

