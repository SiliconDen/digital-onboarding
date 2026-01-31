//----------------------------------------------------------------------
// Created with uvmf_gen version 2023.4_2
//----------------------------------------------------------------------
// pragma uvmf custom header begin
// pragma uvmf custom header end
//----------------------------------------------------------------------
//----------------------------------------------------------------------
//     
// DESCRIPTION: This interface contains the fsm_in interface signals.
//      It is instantiated once per fsm_in bus.  Bus Functional Models, 
//      BFM's named fsm_in_driver_bfm, are used to drive signals on the bus.
//      BFM's named fsm_in_monitor_bfm are used to monitor signals on the 
//      bus. This interface signal bundle is passed in the port list of
//      the BFM in order to give the BFM access to the signals in this
//      interface.
//
//----------------------------------------------------------------------
//----------------------------------------------------------------------
//
// This template can be used to connect a DUT to these signals
//
// .dut_signal_port(fsm_in_bus.comp_i), // Agent input 
// .dut_signal_port(fsm_in_bus.analog_ready_i), // Agent input 
// .dut_signal_port(fsm_in_bus.trigger_i), // Agent input 
// .dut_signal_port(fsm_in_bus.interrupt_clear_i), // Agent input 
// .dut_signal_port(fsm_in_bus.deintegrate_i), // Agent input 

import uvmf_base_pkg_hdl::*;
import fsm_in_pkg_hdl::*;

interface  fsm_in_if 

  (
  input tri clk_i, 
  input tri rst_n_i,
  inout tri  comp_i,
  inout tri  analog_ready_i,
  inout tri  trigger_i,
  inout tri  interrupt_clear_i,
  inout tri  deintegrate_i
  );

modport monitor_port 
  (
  input clk_i,
  input rst_n_i,
  input comp_i,
  input analog_ready_i,
  input trigger_i,
  input interrupt_clear_i,
  input deintegrate_i
  );

modport initiator_port 
  (
  input clk_i,
  input rst_n_i,
  input comp_i,
  input analog_ready_i,
  input trigger_i,
  input interrupt_clear_i,
  input deintegrate_i
  );

modport responder_port 
  (
  input clk_i,
  input rst_n_i,  
  output comp_i,
  output analog_ready_i,
  output trigger_i,
  output interrupt_clear_i,
  output deintegrate_i
  );
  

// pragma uvmf custom interface_item_additional begin
// pragma uvmf custom interface_item_additional end

endinterface

// pragma uvmf custom external begin
// pragma uvmf custom external end

