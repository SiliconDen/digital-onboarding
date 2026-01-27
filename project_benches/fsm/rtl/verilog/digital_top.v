/*
--------------------------------------------------------------------------------
 Title        : digital_top
 Project      : 180-voltmeter
 File         : digital_top.v
 Description  : Top-level digital control module that orchestrates the voltmeter
                system. Integrates analog signal sanitization, SPI slave interface,
                and provides control signals to the analog front-end. Handles
                communication with external SPI master and manages analog control
                outputs for measurement operations.
 
 Author       : Tristan Wood tdwood2@ncsu.edu
 Created      : 2025-08-13
 License      : See LICENSE in the project root

 Revision History:
   - 1.0 2025-08-13 Tristan Wood
         Initial implementation of digital top
   - 2.0 2025-09-27 Tristan Wood 
         Removed modules for challenge rtl
--------------------------------------------------------------------------------
*/

module digital_top (
    // System Clock and Reset
    input wire clk_i,
    input wire rst_n_i,

    // Analog Frontend (AFE) Interface
    // Inputs from analog comparator and control logic (asynchronous, need synchronization)
    // Outputs control dual-slope ADC measurement phases
    input wire comp_i,
    input wire analog_ready_i,
    output wire idle_o,
    output wire auto_zero_o,
    output wire integrate_o,
    output wire deintegrate_o,
    output wire ref_sign_o,

    // Measurement Control Interface
    // Trigger and interrupt signals (asynchronous inputs need synchronization)
    input wire trigger_i,
    input wire interrupt_clear_i,
    output wire interrupt_o,
    output wire [11:0] measurement_count_o

);
    //==============================================================================
    // Internal Signal Declarations
    //==============================================================================                 

    // Counter and measurement signals
    wire [4:0] cycle_count;
    wire [9:0] pulse_count;
    wire [11:0] measurement_count;
    wire finished;
    wire increment;
    wire pulse_trigger;
    wire measurement_en;
    wire measurement_clear;

    //==============================================================================
    // Module Instantiations
    //==============================================================================

    //------------------------------------------------------------------------------
    // Measurement Counters
    //------------------------------------------------------------------------------
    // Three counters coordinate measurement timing:
    //   cycle_counter: Tracks measurement cycles (0-24)
    //   pulse_counter: Generates increment pulses for cycle_counter, used for distributed integration
    //   measurement_counter: Counts deintegration pulses (final ADC result)
    cycle_counter cycle_counter_inst (
        .clk_i(clk_i),
        .rst_n_i(rst_n_i),
        .increment_i(increment),
        .finished_o(finished),
        .interrupt_clear_i(interrupt_clear_i),
        .cycle_count_o(cycle_count)
    );

    pulse_counter pulse_counter_inst (
        .clk_i(clk_i),
        .rst_n_i(rst_n_i),
        .trigger_i(pulse_trigger),
        .stop_i(finished),
        .increment_o(increment),
        .pulse_count_o(pulse_count)
    );

    measurement_counter measurement_counter_inst (
        .clk_i(clk_i),
        .rst_n_i(rst_n_i),
        .measurement_en_i(measurement_en),
        .measurement_clear_i(measurement_clear),
        .measurement_count_o(measurement_count)
    );

    //------------------------------------------------------------------------------
    // State Machine (Measurement Control)
    //------------------------------------------------------------------------------
    // Core dual-slope ADC state machine: IDLE -> AUTO_ZERO -> INTEGRATE -> DEINTEGRATE
    // Features: autoranging and distributed integration
    state_machine state_machine_inst (
        .clk_i(clk_i),
        .rst_n_i(rst_n_i),
        .trigger_i(trigger_i),
        .pulse_trigger_o(pulse_trigger),
        .comp_i(comp_i),
        .analog_ready_i(analog_ready_i),
        .idle_o(idle_o),
        .auto_zero_o(auto_zero_o),
        .integrate_o(integrate_o),
        .deintegrate_o(deintegrate_o),
        .ref_sign_o(ref_sign_o),
        .cycle_count_i(cycle_count),
        .pulse_count_i(pulse_count),
        .measurement_count_i(measurement_count),
        .measurement_en_o(measurement_en),
        .measurement_clear_o(measurement_clear)
    );
    
    //==============================================================================
    // Output Assignments
    //==============================================================================
    
    // Measurement result outputs
    assign interrupt_o = finished;
    assign measurement_count_o = measurement_count;
endmodule