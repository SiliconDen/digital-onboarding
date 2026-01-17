/*
--------------------------------------------------------------------------------
 Title        : pulse_counter
 Project      : 180-voltmeter
 File         : pulse_counter.v
 Description  : Counter module that tracks clock cycles which increments the cycle counter.
                Features a 10-bit counter that wraps at 999 and generates an
                increment signal for cycle counting. Is enabled by the state machine.

 Author       : Tristan Wood tdwood2@ncsu.edu
 Created      : 2025-09-11
 License      : See LICENSE in the project root

 Revision History:
   - 1.0 2025-09-11 Tristan Wood 
            Initial implementation of pulse counter
   - 1.1 2026-01-16 Tristan Wood 
            Removed debug signals for challenge rtl
--------------------------------------------------------------------------------
*/

module pulse_counter (
    // Clock and reset
    input wire clk_i,
    input wire rst_n_i,
    
    // Control inputs
    input wire trigger_i,                 // Start counting (active high)
    input wire stop_i,                    // Stop counting (active high)
    
    // Outputs
    output wire increment_o,              // High when count equals dbg_i (pulses cycle counter)
    output wire [9:0] pulse_count_o,     // Current pulse count (0 to dbg_i)
);
    //==============================================================================
    // Internal Signal Declarations
    //==============================================================================
    
    // Enable register
    reg en;              // 1 = counting enabled, 0 = disabled
    reg next_en;
    
    // Pulse counter registers
    reg [9:0] current_pulse_count;  // Counts 0 to dbg_i
    reg [9:0] next_pulse_count;

    //==============================================================================
    // Enable Control Logic (Sequential)
    //==============================================================================
    always @(posedge clk_i or negedge rst_n_i) begin
        if (!rst_n_i) begin
            en <= 1'b0;
        end else begin
            en <= next_en;
        end
    end

    //==============================================================================
    // Enable Control Logic (Combinational)
    //==============================================================================
    // Priority: stop > trigger (stop takes precedence if both asserted)
    always @(*) begin
        next_en = en;
        
        if(trigger_i) begin
            next_en = 1'b1;
        end
        
        // Stop takes priority over trigger
        if(stop_i) begin
            next_en = 1'b0;
        end
    end

    //==============================================================================
    // Pulse Counter Logic (Sequential)
    //==============================================================================
    always @(posedge clk_i or negedge rst_n_i) begin
        if (!rst_n_i) begin
            current_pulse_count <= 10'd0;
        end else begin
            current_pulse_count <= next_pulse_count;
        end
    end

    //==============================================================================
    // Pulse Counter Logic (Combinational)
    //==============================================================================
    // Counter wraps at 999 (counts 0 to 999, then resets to 0)
    always @(*) begin
        next_pulse_count = current_pulse_count;
        
        if(en) begin
            next_pulse_count = current_pulse_count + 1'b1;
        end
        
        // Wrap when reaching 999
        if(current_pulse_count == 10'd999) begin
            next_pulse_count = 10'd0;
        end
    end
    
    //==============================================================================
    // Output Assignments
    //==============================================================================
    
    // Pulse when counter equals 998 (used to increment cycle counter)
    assign increment_o = current_pulse_count == 10'd998;
    assign pulse_count_o = current_pulse_count;

endmodule