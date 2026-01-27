/*
--------------------------------------------------------------------------------
 Title        : state_machine
 Project      : 180-voltmeter
 File         : state_machine.v
 Description  : Finite state machine that controls the voltmeter measurement
                sequence. Manages the auto-zero, integrate, and deintegrate phases
                of dual-slope analog-to-digital conversion. Coordinates timing
                control through counter instances and generates appropriate AFE
                control signals for each measurement phase.
 
 Author       : Tristan Wood tdwood2@ncsu.edu
 Created      : 2025-08-13
 License      : See LICENSE in the project root

Revision History:
   - 1.0  2025-08-13 Tristan Wood
         Initial implementation of voltmeter measurement FSM
         (basic states: IDLE, AUTO_ZERO, INTEGRATE, DEINTEGRATE;
          simple counter-based sequencing, no autoranging)
   - 2.0  2025-09-11 Tristan Wood
         Major update:
           * Added explicit cycle/pulse counter separation
           * Implemented multi-range (RANGE_1 to RANGE_4) support
           * Introduced named cycle constants (removed magic numbers)
           * Added target pulse logic for distributed integration pulses
           * Latch comparator sign only at integrate→deintegrate transition
           * Added measurement enable output for deintegration window
           * Refactored FSM for improved readability and maintainability
    - 3.0  2025-09-27 Tristan Wood
         Measurement accuracy and stability improvements:
           * Added measurement_clear_o signal to properly reset counter at
             integrate→deintegrate transition
           * Implemented trigger latching
           * Fixed distributed pulse timing in RANGE_1/RANGE_2 to ensure even
             integration periods
           * Corrected range transition logic to maintain proper range sequence
           * Enhanced pulse counter synchronization with state transitions
           * Fixed Deintegrate target pulse logic
   - 4.0  2026-01-16 Tristan Wood
         Removed debug signals for challenge rtl
--------------------------------------------------------------------------------
*/

module state_machine (
    // Clock and reset
    input wire clk_i,
    input wire rst_n_i,

    // Inputs from MCU
    input wire trigger_i,                // Measurement trigger (active high)

    // Outputs to MCU
    output wire pulse_trigger_o,         // Pulse counter trigger (starts pulse counting)

    // Inputs from AFE (Analog Frontend)
    input wire comp_i,                   // Comparator output (indicates integration polarity)
    input wire analog_ready_i,           // AFE ready for measurement

    // Outputs to AFE
    output wire idle_o,
    output wire auto_zero_o,
    output wire integrate_o,
    output wire deintegrate_o,
    output wire ref_sign_o,              // Reference sign control (polarity for deintegration)

    // Inputs from Counters
    input wire [4:0] cycle_count_i,      // 0-24 cycles per measurement
    input wire [9:0] pulse_count_i,       // Tracks integration pulses
    input wire [11:0] measurement_count_i,  // Deintegration count

    // Outputs to Counters
    output wire measurement_en_o,         // Active during deintegration
    output wire measurement_clear_o       // At integrate→deintegrate transition
);

    //==============================================================================
    // Internal Signal Declarations
    //==============================================================================

    //------------------------------------------------------------------------------
    // AFE Control Signals
    //------------------------------------------------------------------------------
    reg current_idle, current_auto_zero, current_integrate, current_deintegrate;
    reg next_idle, next_auto_zero, next_integrate, next_deintegrate;
    
    //------------------------------------------------------------------------------
    // State Machine Definitions
    //------------------------------------------------------------------------------
    // Main FSM states for dual-slope ADC measurement sequence
    localparam S_IDLE = 2'b00;
    localparam S_AUTO_ZERO = 2'b01;
    localparam S_INTEGRATE = 2'b10;
    localparam S_DEINTEGRATE = 2'b11;

    reg [1:0] current_state;
    reg [1:0] next_state;

    //------------------------------------------------------------------------------
    // Range Selection
    //------------------------------------------------------------------------------
    // Multi-range support: RANGE_1 (highest sensitivity) to RANGE_4 (lowest sensitivity)
    // Autoranging: starts at RANGE_1, progresses to higher ranges if measurement overflows
    localparam RANGE_1 = 2'b00;
    localparam RANGE_2 = 2'b01;
    localparam RANGE_3 = 2'b10;
    localparam RANGE_4 = 2'b11;

    reg [1:0] current_range;
    reg [1:0] next_range;

    //------------------------------------------------------------------------------
    // Cycle Selection Constants
    //------------------------------------------------------------------------------
    // Cycle numbers for state transitions in each range
    // Each range has: AUTO_ZERO -> INTEGRATE -> DEINTEGRATE cycle sequence
    localparam FIRST_AUTO_ZERO_CYCLE = 5'd1;
    localparam FIRST_INTEGRATE_CYCLE = 5'd2;
    localparam FIRST_DEINTEGRATE_CYCLE = 5'd6;
    localparam SECOND_AUTO_ZERO_CYCLE = 5'd3;
    localparam SECOND_INTEGRATE_CYCLE = 5'd4;
    localparam SECOND_DEINTEGRATE_CYCLE = 5'd8;
    localparam THIRD_AUTO_ZERO_CYCLE = 5'd5;
    localparam THIRD_INTEGRATE_CYCLE = 5'd6;
    localparam THIRD_DEINTEGRATE_CYCLE = 5'd10;
    localparam FOURTH_AUTO_ZERO_CYCLE = 5'd7;
    localparam FOURTH_INTEGRATE_CYCLE = 5'd17;
    localparam FOURTH_DEINTEGRATE_CYCLE = 5'd21;
    localparam FINAL_CYCLE = 5'd24;

    reg [4:0] current_target_cycle;
    reg [4:0] next_target_cycle;

    //------------------------------------------------------------------------------
    // Pulse Selection
    //------------------------------------------------------------------------------
    // Target pulse count for distributed integration (RANGE_1 and RANGE_2)
    // Allows integration to be split into multiple pulses for better accuracy
    reg [9:0] current_target_pulse;
    reg [9:0] next_target_pulse;

    //------------------------------------------------------------------------------
    // Trigger Latch
    //------------------------------------------------------------------------------
    // Latches trigger input to ensure measurement starts even if trigger is brief
    reg current_trigger;
    reg next_trigger;

    //------------------------------------------------------------------------------
    // Comparator Previous Value
    //------------------------------------------------------------------------------
    // Stores comparator value at integrate→deintegrate transition
    // Used to determine reference sign for deintegration phase
    reg comp_prev;

    //==============================================================================
    // Implementation Sections
    //==============================================================================

    //------------------------------------------------------------------------------
    // State Machine Sequential Logic
    //------------------------------------------------------------------------------
    always @(posedge clk_i or negedge rst_n_i) begin 
        if (!rst_n_i) begin
            current_state <= S_IDLE;
        end else begin
            current_state <= next_state;
        end
    end
    
    //------------------------------------------------------------------------------
    // State Machine Combinational Logic
    //------------------------------------------------------------------------------
    // State sequence: IDLE -> AUTO_ZERO -> INTEGRATE -> DEINTEGRATE -> AUTO_ZERO (repeat)
    always @(*) begin
        next_state = current_state;
        
        case (current_state)
            S_IDLE: begin
                if(current_trigger && analog_ready_i) begin
                    next_state = S_AUTO_ZERO;
                end 
            end
            S_AUTO_ZERO: begin
                if(cycle_count_i == current_target_cycle) begin
                    next_state = S_INTEGRATE;
                end else begin 
                    // Safety: return to idle if final cycle reached (measurement timeout)
                    if(cycle_count_i == FINAL_CYCLE) begin
                        next_state = S_IDLE;
                    end
                end
            end
            S_INTEGRATE: begin
                if(cycle_count_i == current_target_cycle) begin
                    next_state = S_DEINTEGRATE;
                end
            end
            S_DEINTEGRATE: begin
                // Transition to auto-zero when: target cycle reached (timeout) or comparator changes (zero-crossing)
                if((cycle_count_i == current_target_cycle) || (comp_i != comp_prev)) begin
                    next_state = S_AUTO_ZERO;
                end 
            end
        endcase
    end

    //------------------------------------------------------------------------------
    // Trigger Latch Sequential Logic
    //------------------------------------------------------------------------------
    // Latches trigger input to ensure measurement starts even if trigger pulse is brief
    always @(posedge clk_i or negedge rst_n_i) begin
        if(!rst_n_i) begin
            current_trigger <= 1'b0;
        end else begin
            current_trigger <= next_trigger;
        end
    end

    //------------------------------------------------------------------------------
    // Trigger Latch Combinational Logic
    //------------------------------------------------------------------------------
    // Sets trigger latch when trigger_i is asserted, clears it when measurement starts
    always @(*) begin
        next_trigger = current_trigger;
        
        if(trigger_i) begin
            next_trigger = 1'b1;
        end else begin
            // Clear trigger latch when measurement starts (IDLE -> AUTO_ZERO transition)
            if(current_trigger && (current_state == S_IDLE && next_state == S_AUTO_ZERO)) begin
                next_trigger = 1'b0;
            end
        end
    end

    //------------------------------------------------------------------------------
    // Target Cycle Sequential Logic
    //------------------------------------------------------------------------------
    // Tracks which cycle number triggers the next state transition
    always @(posedge clk_i or negedge rst_n_i) begin
        if(!rst_n_i) begin
            current_target_cycle <= FIRST_AUTO_ZERO_CYCLE;
        end else begin
            current_target_cycle <= next_target_cycle;
        end
    end

    //------------------------------------------------------------------------------
    // Target Cycle Combinational Logic
    //------------------------------------------------------------------------------
    // Updates target cycle based on next state and current range
    // Implements autoranging: progresses through ranges if measurement overflows
    always @(*) begin
        next_target_cycle = current_target_cycle;
        
        case(next_state)
            S_IDLE: begin
                next_target_cycle = FIRST_AUTO_ZERO_CYCLE;
            end
            S_AUTO_ZERO: begin
                // Advance to next range's auto-zero cycle after deintegrate (autoranging progression)
                if(current_target_cycle == FIRST_DEINTEGRATE_CYCLE) begin
                    next_target_cycle = SECOND_AUTO_ZERO_CYCLE;
                end
                if(current_target_cycle == SECOND_DEINTEGRATE_CYCLE) begin
                    next_target_cycle = THIRD_AUTO_ZERO_CYCLE;
                end
                if(current_target_cycle == THIRD_DEINTEGRATE_CYCLE) begin
                    next_target_cycle = FOURTH_AUTO_ZERO_CYCLE;
                end
                // Reset to first range if: reached RANGE_4 or measurement count overflow
                if(current_target_cycle == FOURTH_DEINTEGRATE_CYCLE || measurement_count_i >= 12'd360) begin
                    next_target_cycle = FIRST_AUTO_ZERO_CYCLE;
                end
            end
            S_INTEGRATE: begin
                // Set target cycle based on current range
                if(current_target_cycle == FIRST_AUTO_ZERO_CYCLE) begin
                    next_target_cycle = FIRST_INTEGRATE_CYCLE;
                end
                if(current_target_cycle == SECOND_AUTO_ZERO_CYCLE) begin
                    next_target_cycle = SECOND_INTEGRATE_CYCLE;
                end
                if(current_target_cycle == THIRD_AUTO_ZERO_CYCLE) begin
                    next_target_cycle = THIRD_INTEGRATE_CYCLE;
                end
                if(current_target_cycle == FOURTH_AUTO_ZERO_CYCLE) begin
                    next_target_cycle = FOURTH_INTEGRATE_CYCLE;
                end   
            end
            S_DEINTEGRATE: begin
                // Set target cycle based on current range (only advance if in that range)
                if(current_target_cycle == FIRST_INTEGRATE_CYCLE) begin
                    next_target_cycle = FIRST_DEINTEGRATE_CYCLE;
                end
                if(current_target_cycle == SECOND_INTEGRATE_CYCLE && current_range == RANGE_2) begin
                    next_target_cycle = SECOND_DEINTEGRATE_CYCLE;
                end
                if(current_target_cycle == THIRD_INTEGRATE_CYCLE && current_range == RANGE_3) begin
                    next_target_cycle = THIRD_DEINTEGRATE_CYCLE;
                end
                if(current_target_cycle == FOURTH_INTEGRATE_CYCLE && current_range == RANGE_4) begin
                    next_target_cycle = FOURTH_DEINTEGRATE_CYCLE;
                end
            end
        endcase
    end

    //------------------------------------------------------------------------------
    // Range Selection Sequential Logic
    //------------------------------------------------------------------------------
    // Tracks current measurement range (RANGE_1 to RANGE_4)
    always @(posedge clk_i or negedge rst_n_i) begin
        if(!rst_n_i) begin
            current_range <= RANGE_1;
        end else begin
            current_range <= next_range;
        end
    end
    
    //------------------------------------------------------------------------------
    // Range Selection Combinational Logic
    //------------------------------------------------------------------------------
    // Updates range based on target cycle transitions (autoranging)
    // Progresses: RANGE_1 -> RANGE_2 -> RANGE_3 -> RANGE_4 -> RANGE_1 (wrap)
    always @(*) begin
        next_range = current_range;
        
        // Advance to next range when transitioning from deintegrate to next auto-zero
        if(current_target_cycle == FIRST_DEINTEGRATE_CYCLE && next_target_cycle == SECOND_AUTO_ZERO_CYCLE) begin
            next_range = RANGE_2;
        end
        if(current_target_cycle == SECOND_DEINTEGRATE_CYCLE && next_target_cycle == THIRD_AUTO_ZERO_CYCLE) begin
            next_range = RANGE_3;
        end
        if(current_target_cycle == THIRD_DEINTEGRATE_CYCLE && next_target_cycle == FOURTH_AUTO_ZERO_CYCLE) begin
            next_range = RANGE_4;
        end
        // Wrap back to RANGE_1 after RANGE_4 or on measurement overflow
        if(current_target_cycle == FOURTH_DEINTEGRATE_CYCLE && next_target_cycle == FIRST_AUTO_ZERO_CYCLE) begin
            next_range = RANGE_1;
        end
    end

    //------------------------------------------------------------------------------
    // AFE Control Sequential Logic
    //------------------------------------------------------------------------------
    // Controls analog frontend phase signals (idle, auto_zero, integrate, deintegrate)
    always @(posedge clk_i or negedge rst_n_i) begin
        if(!rst_n_i) begin
            current_idle <= 1'b1;
            current_auto_zero <= 1'b0;
            current_integrate <= 1'b0;
            current_deintegrate <= 1'b0;
        end else begin
            current_idle <= next_idle;
            current_auto_zero <= next_auto_zero;
            current_integrate <= next_integrate;
            current_deintegrate <= next_deintegrate;
        end
    end

    //------------------------------------------------------------------------------
    // AFE Control Combinational Logic
    //------------------------------------------------------------------------------
    // Generates AFE control signals based on next state.
    // For INTEGRATE state: implements distributed integration pulses for RANGE_1 and RANGE_2
    always @(*) begin
        case(next_state)
            S_IDLE: begin
                next_idle = 1'b1;
                next_auto_zero = 1'b0;
                next_integrate = 1'b0;
                next_deintegrate = 1'b0;
            end
            S_AUTO_ZERO: begin
                next_idle = 1'b0;
                next_auto_zero = 1'b1;
                next_integrate = 1'b0;
                next_deintegrate = 1'b0;
            end
            S_INTEGRATE: begin
                // Distributed integration mode (dbg_i[52] controls pulse/inverse pulse mode)
                next_auto_zero = 1'b0;
                next_deintegrate = 1'b0;
                next_idle = 1'b1;
                next_integrate = 1'b0;
                if(pulse_count_i == current_target_pulse) begin
                    next_idle = 1'b0;
                    next_integrate = 1'b1;
                end
                // RANGE_3 and RANGE_4: continuous integration (no distributed pulses)
                if(current_range == RANGE_3 || current_range == RANGE_4) begin
                    next_idle = 1'b0;
                    next_integrate = 1'b1;
                end
            end
            S_DEINTEGRATE: begin
                next_idle = 1'b0;
                next_auto_zero = 1'b0;
                next_integrate = 1'b0;
                next_deintegrate = 1'b1;
            end
        endcase
    end

    //------------------------------------------------------------------------------
    // Target Pulse Sequential Logic
    //------------------------------------------------------------------------------
    // Tracks target pulse count for distributed integration (RANGE_1 and RANGE_2)
    always @(posedge clk_i or negedge rst_n_i) begin
        if(!rst_n_i) begin
            current_target_pulse <= 10'd9;
        end else begin
            current_target_pulse <= next_target_pulse;
        end 
    end

    //------------------------------------------------------------------------------
    // Target Pulse Combinational Logic
    //------------------------------------------------------------------------------
    // Updates target pulse for distributed integration.
    // RANGE_1 and RANGE_2 use distributed pulses; RANGE_3 and RANGE_4 use continuous integration
    always @(*) begin
        next_target_pulse = current_target_pulse;
        // Update target pulse when transitioning from RANGE_1 to RANGE_2
        if(current_range == RANGE_1 && next_range == RANGE_2) begin
            next_target_pulse = 10'd99;  // Pulse target for RANGE_2
        end
        // Reset target pulse when returning to RANGE_1
        if(current_range != RANGE_1 && next_range == RANGE_1) begin
            next_target_pulse = 10'd9;  // Initial pulse target for RANGE_1
        end
        // Auto-increment target pulse during integration (distributed pulse mode)
        if(current_state == S_INTEGRATE) begin
            // RANGE_1: increment by dbg_i[41:32] when target pulse reached
            if(current_range == RANGE_1 && (pulse_count_i == current_target_pulse)) begin
                next_target_pulse = (current_target_pulse + 10'd1);
            end
            // RANGE_2: increment by dbg_i[51:42] when target pulse reached
            if(current_range == RANGE_2 && (pulse_count_i == current_target_pulse)) begin
                next_target_pulse = (current_target_pulse + 10'd1);
            end
        end
    end

    //------------------------------------------------------------------------------
    // Comparator Previous Sequential Logic
    //------------------------------------------------------------------------------
    // Stores comparator value for reference sign determination.
    always @(posedge clk_i or negedge rst_n_i) begin
        if(!rst_n_i) begin
            comp_prev <= 1'b0;
        end else begin
            // Latch mode: only capture at integrate→deintegrate transition
            if((current_state == S_INTEGRATE) && (next_state == S_DEINTEGRATE)) begin
                comp_prev <= comp_i;
            end 
        end
    end

    //==============================================================================
    // Output Assignments
    //==============================================================================
    
    // Measurement counter enable: active during deintegration (except at transition to auto-zero)
    assign measurement_en_o = (current_state == S_DEINTEGRATE && next_state != S_AUTO_ZERO);
    
    // Measurement counter clear: pulse at integrate→deintegrate transition
    assign measurement_clear_o = (current_state == S_INTEGRATE && next_state == S_DEINTEGRATE);
    
    // Reference sign: determines deintegration polarity
    assign ref_sign_o = comp_prev ;
    
    // AFE control outputs
    assign idle_o = current_idle;
    assign auto_zero_o = current_auto_zero;
    assign integrate_o = current_integrate;
    assign deintegrate_o = current_deintegrate;
    
    // Pulse counter trigger: pulse when starting measurement
    assign pulse_trigger_o = (current_state == S_IDLE && next_state == S_AUTO_ZERO);
endmodule