//----------------------------------------------------------------------
// Created with uvmf_gen version 2023.4_2
//----------------------------------------------------------------------
// pragma uvmf custom header begin
// pragma uvmf custom header end
//----------------------------------------------------------------------
//----------------------------------------------------------------------
//     
// DESCRIPTION: This interface contains the fsm_out interface signals.
//      It is instantiated once per fsm_out bus.  Bus Functional Models, 
//      BFM's named fsm_out_driver_bfm, are used to drive signals on the bus.
//      BFM's named fsm_out_monitor_bfm are used to monitor signals on the 
//      bus. This interface signal bundle is passed in the port list of
//      the BFM in order to give the BFM access to the signals in this
//      interface.
//
//----------------------------------------------------------------------
//----------------------------------------------------------------------
//
// This template can be used to connect a DUT to these signals
//
// .dut_signal_port(fsm_out_bus.idle_o), // Agent output 
// .dut_signal_port(fsm_out_bus.auto_zero_o), // Agent output 
// .dut_signal_port(fsm_out_bus.integrate_o), // Agent output 
// .dut_signal_port(fsm_out_bus.deintegrate_o), // Agent output 
// .dut_signal_port(fsm_out_bus.ref_sign_o), // Agent output 
// .dut_signal_port(fsm_out_bus.interrupt_o), // Agent output 
// .dut_signal_port(fsm_out_bus.measurement_count_o), // Agent output 

import uvmf_base_pkg_hdl::*;
import fsm_out_pkg_hdl::*;

interface  fsm_out_if 

  (
  input tri clk_i, 
  input tri rst_n_i,
  inout tri  idle_o,
  inout tri  auto_zero_o,
  inout tri  integrate_o,
  inout tri  deintegrate_o,
  inout tri  ref_sign_o,
  inout tri  interrupt_o,
  inout tri [11:0] measurement_count_o
  );

modport monitor_port 
  (
  input clk_i,
  input rst_n_i,
  input idle_o,
  input auto_zero_o,
  input integrate_o,
  input deintegrate_o,
  input ref_sign_o,
  input interrupt_o,
  input measurement_count_o
  );

modport initiator_port 
  (
  input clk_i,
  input rst_n_i,
  output idle_o,
  output auto_zero_o,
  output integrate_o,
  output deintegrate_o,
  output ref_sign_o,
  output interrupt_o,
  output measurement_count_o
  );

modport responder_port 
  (
  input clk_i,
  input rst_n_i,  
  input idle_o,
  input auto_zero_o,
  input integrate_o,
  input deintegrate_o,
  input ref_sign_o,
  input interrupt_o,
  input measurement_count_o
  );
  

// pragma uvmf custom interface_item_additional begin
// pragma uvmf custom interface_item_additional end

endinterface

// pragma uvmf custom external begin
// pragma uvmf custom external end

