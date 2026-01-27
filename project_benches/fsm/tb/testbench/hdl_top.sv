//----------------------------------------------------------------------
// Created with uvmf_gen version 2023.4_2
//----------------------------------------------------------------------
// pragma uvmf custom header begin
// pragma uvmf custom header end
//----------------------------------------------------------------------
//----------------------------------------------------------------------                     
//               
// Description: This top level module instantiates all synthesizable
//    static content.  This and tb_top.sv are the two top level modules
//    of the simulation.  
//
//    This module instantiates the following:
//        DUT: The Design Under Test
//        Interfaces:  Signal bundles that contain signals connected to DUT
//        Driver BFM's: BFM's that actively drive interface signals
//        Monitor BFM's: BFM's that passively monitor interface signals
//
//----------------------------------------------------------------------

//----------------------------------------------------------------------
//

module hdl_top;

import fsm_parameters_pkg::*;
import uvmf_base_pkg_hdl::*;

  // pragma attribute hdl_top partition_module_xrtl                                            
// pragma uvmf custom clock_generator begin
  bit clk;
  // Instantiate a clk driver 
  // tbx clkgen
  initial begin
    clk = 0;
    #9ns;
    forever begin
      clk = ~clk;
      #10ns;
    end
  end
// pragma uvmf custom clock_generator end

// pragma uvmf custom reset_generator begin
  bit rst;
  // Instantiate a rst driver
  // tbx clkgen
  initial begin
    rst = 0; 
    #250ns;
    rst =  1; 
  end
// pragma uvmf custom reset_generator end

  // pragma uvmf custom module_item_additional begin
  // pragma uvmf custom module_item_additional end

  // Instantiate the signal bundle, monitor bfm and driver bfm for each interface.
  // The signal bundle, _if, contains signals to be connected to the DUT.
  // The monitor, monitor_bfm, observes the bus, _if, and captures transactions.
  // The driver, driver_bfm, drives transactions onto the bus, _if.
  fsm_in_if  fsm_in_bus(
     // pragma uvmf custom fsm_in_bus_connections begin
     .clk_i(clk), .rst_n_i(rst)
     // pragma uvmf custom fsm_in_bus_connections end
     );
  fsm_out_if  fsm_out_bus(
     // pragma uvmf custom fsm_out_bus_connections begin
     .clk_i(clk), .rst_n_i(rst)
     // pragma uvmf custom fsm_out_bus_connections end
     );
  fsm_in_monitor_bfm  fsm_in_mon_bfm(fsm_in_bus);
  fsm_out_monitor_bfm  fsm_out_mon_bfm(fsm_out_bus);
  fsm_in_driver_bfm  fsm_in_drv_bfm(fsm_in_bus);

  // pragma uvmf custom dut_instantiation begin
  // Instantiate digital_top DUT
  digital_top dut (
      // System Clock and Reset
      .clk_i(clk),
      .rst_n_i(rst),

      // AFE Interface - Inputs (from fsm_in_bus)
      .comp_i(fsm_in_bus.comp_i),
      .analog_ready_i(fsm_in_bus.analog_ready_i),

      // Measurement Control - Inputs (from fsm_in_bus)
      .trigger_i(fsm_in_bus.trigger_i),
      .interrupt_clear_i(fsm_in_bus.interrupt_clear_i),

      // AFE Interface - Outputs (to fsm_out_bus)
      .idle_o(fsm_out_bus.idle_o),
      .auto_zero_o(fsm_out_bus.auto_zero_o),
      .integrate_o(fsm_out_bus.integrate_o),
      .deintegrate_o(fsm_out_bus.deintegrate_o),
      .ref_sign_o(fsm_out_bus.ref_sign_o),

      // Measurement Control - Outputs (to fsm_out_bus)
      .interrupt_o(fsm_out_bus.interrupt_o),
      .measurement_count_o(fsm_out_bus.measurement_count_o)
  );
  // pragma uvmf custom dut_instantiation end

  initial begin      // tbx vif_binding_block 
    import uvm_pkg::uvm_config_db;
    // The monitor_bfm and driver_bfm for each interface is placed into the uvm_config_db.
    // They are placed into the uvm_config_db using the string names defined in the parameters package.
    // The string names are passed to the agent configurations by test_top through the top level configuration.
    // They are retrieved by the agents configuration class for use by the agent.
    uvm_config_db #( virtual fsm_in_monitor_bfm  )::set( null , UVMF_VIRTUAL_INTERFACES , fsm_in_BFM , fsm_in_mon_bfm ); 
    uvm_config_db #( virtual fsm_out_monitor_bfm  )::set( null , UVMF_VIRTUAL_INTERFACES , fsm_out_BFM , fsm_out_mon_bfm ); 
    uvm_config_db #( virtual fsm_in_driver_bfm  )::set( null , UVMF_VIRTUAL_INTERFACES , fsm_in_BFM , fsm_in_drv_bfm  );
  end

endmodule

// pragma uvmf custom external begin
// pragma uvmf custom external end

