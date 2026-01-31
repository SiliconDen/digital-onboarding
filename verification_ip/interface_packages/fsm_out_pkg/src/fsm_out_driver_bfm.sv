//----------------------------------------------------------------------
// Created with uvmf_gen version 2023.4_2
//----------------------------------------------------------------------
// pragma uvmf custom header begin
// pragma uvmf custom header end
//----------------------------------------------------------------------
//----------------------------------------------------------------------
//     
// DESCRIPTION: 
//    This interface performs the fsm_out signal driving.  It is
//     accessed by the uvm fsm_out driver through a virtual interface
//     handle in the fsm_out configuration.  It drives the singals passed
//     in through the port connection named bus of type fsm_out_if.
//
//     Input signals from the fsm_out_if are assigned to an internal input
//     signal with a _i suffix.  The _i signal should be used for sampling.
//
//     The input signal connections are as follows:
//       bus.signal -> signal_i 
//
//     This bfm drives signals with a _o suffix.  These signals
//     are driven onto signals within fsm_out_if based on INITIATOR/RESPONDER and/or
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
import fsm_out_pkg_hdl::*;
`include "src/fsm_out_macros.svh"

interface fsm_out_driver_bfm 
  (fsm_out_if bus);
  // The following pragma and additional ones in-lined further below are for running this BFM on Veloce
  // pragma attribute fsm_out_driver_bfm partition_interface_xif

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

  // INITIATOR mode output signals
  tri  idle_o_i;
  reg  idle_o_o = 1'b0;
  tri  auto_zero_o_i;
  reg  auto_zero_o_o = 1'b0;
  tri  integrate_o_i;
  reg  integrate_o_o = 1'b0;
  tri  deintegrate_o_i;
  reg  deintegrate_o_o = 1'b0;
  tri  ref_sign_o_i;
  reg  ref_sign_o_o = 1'b0;
  tri  interrupt_o_i;
  reg  interrupt_o_o = 1'b0;
  tri [11:0] measurement_count_o_i;
  reg [11:0] measurement_count_o_o = 12'b000000000000;

  // Bi-directional signals
  

  assign clk_i_i = bus.clk_i;
  assign rst_n_i_i = bus.rst_n_i;

  // These are signals marked as 'input' by the config file, but the signals will be
  // driven by this BFM if put into RESPONDER mode (flipping all signal directions around)


  // These are signals marked as 'output' by the config file, but the outputs will
  // not be driven by this BFM unless placed in INITIATOR mode.
  assign bus.idle_o = (initiator_responder == INITIATOR) ? idle_o_o : 'bz;
  assign idle_o_i = bus.idle_o;
  assign bus.auto_zero_o = (initiator_responder == INITIATOR) ? auto_zero_o_o : 'bz;
  assign auto_zero_o_i = bus.auto_zero_o;
  assign bus.integrate_o = (initiator_responder == INITIATOR) ? integrate_o_o : 'bz;
  assign integrate_o_i = bus.integrate_o;
  assign bus.deintegrate_o = (initiator_responder == INITIATOR) ? deintegrate_o_o : 'bz;
  assign deintegrate_o_i = bus.deintegrate_o;
  assign bus.ref_sign_o = (initiator_responder == INITIATOR) ? ref_sign_o_o : 'bz;
  assign ref_sign_o_i = bus.ref_sign_o;
  assign bus.interrupt_o = (initiator_responder == INITIATOR) ? interrupt_o_o : 'bz;
  assign interrupt_o_i = bus.interrupt_o;
  assign bus.measurement_count_o = (initiator_responder == INITIATOR) ? measurement_count_o_o : 'bz;
  assign measurement_count_o_i = bus.measurement_count_o;

  // Proxy handle to UVM driver
  fsm_out_pkg::fsm_out_driver   proxy;
  // pragma tbx oneway proxy.my_function_name_in_uvm_driver                 

  // ****************************************************************************
  // **************************************************************************** 
  // Macros that define structs located in fsm_out_macros.svh
  // ****************************************************************************
  // Struct for passing configuration data from fsm_out_driver to this BFM
  // ****************************************************************************
  `fsm_out_CONFIGURATION_STRUCT
  // ****************************************************************************
  // Structs for INITIATOR and RESPONDER data flow
  //*******************************************************************
  // Initiator macro used by fsm_out_driver and fsm_out_driver_bfm
  // to communicate initiator driven data to fsm_out_driver_bfm.           
  `fsm_out_INITIATOR_STRUCT
    fsm_out_initiator_s initiator_struct;
  // Responder macro used by fsm_out_driver and fsm_out_driver_bfm
  // to communicate Responder driven data to fsm_out_driver_bfm.
  `fsm_out_RESPONDER_STRUCT
    fsm_out_responder_s responder_struct;

  // ****************************************************************************
// pragma uvmf custom reset_condition_and_response begin
  // Always block used to return signals to reset value upon assertion of reset
  always @( negedge rst_n_i_i )
     begin
       // RESPONDER mode output signals
       // INITIATOR mode output signals
       idle_o_o <= 1'b0;
       auto_zero_o_o <= 1'b0;
       integrate_o_o <= 1'b0;
       deintegrate_o_o <= 1'b0;
       ref_sign_o_o <= 1'b0;
       interrupt_o_o <= 1'b0;
       measurement_count_o_o <= 12'b000000000000;
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

  function void configure(fsm_out_configuration_s fsm_out_configuration_arg); // pragma tbx xtf  
    initiator_responder = fsm_out_configuration_arg.initiator_responder;
  // pragma uvmf custom configure begin
  // pragma uvmf custom configure end
  endfunction                                                                             

// pragma uvmf custom initiate_and_get_response begin
// ****************************************************************************
// UVMF_CHANGE_ME
// This task is used by an initator.  The task first initiates a transfer then
// waits for the responder to complete the transfer.
    task initiate_and_get_response( 
       // This argument passes transaction variables used by an initiator
       // to perform the initial part of a protocol transfer.  The values
       // come from a sequence item created in a sequence.
       input fsm_out_initiator_s fsm_out_initiator_struct, 
       // This argument is used to send data received from the responder
       // back to the sequence item.  The sequence item is returned to the sequence.
       output fsm_out_responder_s fsm_out_responder_struct 
       );// pragma tbx xtf  
       // 
       // Members within the fsm_out_initiator_struct:
       //   bit ref_sign_o ;
       //   bit [11:0] measurement_count_1 ;
       //   bit [11:0] measurement_count_2 ;
       //   bit [11:0] measurement_count_3 ;
       //   bit [11:0] measurement_count_4 ;
       // Members within the fsm_out_responder_struct:
       //   bit ref_sign_o ;
       //   bit [11:0] measurement_count_1 ;
       //   bit [11:0] measurement_count_2 ;
       //   bit [11:0] measurement_count_3 ;
       //   bit [11:0] measurement_count_4 ;
       initiator_struct = fsm_out_initiator_struct;
       //
       // Reference code;
       //    How to wait for signal value
       //      while (control_signal == 1'b1) @(posedge clk_i_i);
       //    
       //    How to assign a responder struct member, named xyz, from a signal.   
       //    All available initiator input and inout signals listed.
       //    Initiator input signals
       //    Initiator inout signals
       //    How to assign a signal from an initiator struct member named xyz.   
       //    All available initiator output and inout signals listed.
       //    Notice the _o.  Those are storage variables that allow for procedural assignment.
       //    Initiator output signals
       //      idle_o_o <= fsm_out_initiator_struct.xyz;  //     
       //      auto_zero_o_o <= fsm_out_initiator_struct.xyz;  //     
       //      integrate_o_o <= fsm_out_initiator_struct.xyz;  //     
       //      deintegrate_o_o <= fsm_out_initiator_struct.xyz;  //     
       //      ref_sign_o_o <= fsm_out_initiator_struct.xyz;  //     
       //      interrupt_o_o <= fsm_out_initiator_struct.xyz;  //     
       //      measurement_count_o_o <= fsm_out_initiator_struct.xyz;  //    [11:0] 
       //    Initiator inout signals
    // Initiate a transfer using the data received.
    @(posedge clk_i_i);
    @(posedge clk_i_i);
    // Wait for the responder to complete the transfer then place the responder data into 
    // fsm_out_responder_struct.
    @(posedge clk_i_i);
    @(posedge clk_i_i);
    responder_struct = fsm_out_responder_struct;
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
       output fsm_out_initiator_s fsm_out_initiator_struct, 
       // This argument passes transaction variables used by a responder
       // to complete a protocol transfer.  The values come from a sequence item.       
       input fsm_out_responder_s fsm_out_responder_struct 
       );// pragma tbx xtf   
  // Variables within the fsm_out_initiator_struct:
  //   bit ref_sign_o ;
  //   bit [11:0] measurement_count_1 ;
  //   bit [11:0] measurement_count_2 ;
  //   bit [11:0] measurement_count_3 ;
  //   bit [11:0] measurement_count_4 ;
  // Variables within the fsm_out_responder_struct:
  //   bit ref_sign_o ;
  //   bit [11:0] measurement_count_1 ;
  //   bit [11:0] measurement_count_2 ;
  //   bit [11:0] measurement_count_3 ;
  //   bit [11:0] measurement_count_4 ;
       // Reference code;
       //    How to wait for signal value
       //      while (control_signal == 1'b1) @(posedge clk_i_i);
       //    
       //    How to assign a initiator struct member, named xyz, from a signal.   
       //    All available responder input and inout signals listed.
       //    Responder input signals
       //      fsm_out_initiator_struct.xyz = idle_o_i;  //     
       //      fsm_out_initiator_struct.xyz = auto_zero_o_i;  //     
       //      fsm_out_initiator_struct.xyz = integrate_o_i;  //     
       //      fsm_out_initiator_struct.xyz = deintegrate_o_i;  //     
       //      fsm_out_initiator_struct.xyz = ref_sign_o_i;  //     
       //      fsm_out_initiator_struct.xyz = interrupt_o_i;  //     
       //      fsm_out_initiator_struct.xyz = measurement_count_o_i;  //    [11:0] 
       //    Responder inout signals
       //    How to assign a signal, named xyz, from an responder struct member.   
       //    All available responder output and inout signals listed.
       //    Notice the _o.  Those are storage variables that allow for procedural assignment.
       //    Responder output signals
       //    Responder inout signals
    
  @(posedge clk_i_i);
  if (!first_transfer) begin
    // Perform transfer response here.   
    // Reply using data recieved in the fsm_out_responder_struct.
    @(posedge clk_i_i);
    // Reply using data recieved in the transaction handle.
    @(posedge clk_i_i);
  end
    // Wait for next transfer then gather info from intiator about the transfer.
    // Place the data into the fsm_out_initiator_struct.
    @(posedge clk_i_i);
    @(posedge clk_i_i);
    first_transfer = 0;
  endtask
// pragma uvmf custom respond_and_wait_for_next_transfer end

 
endinterface

// pragma uvmf custom external begin
// pragma uvmf custom external end

