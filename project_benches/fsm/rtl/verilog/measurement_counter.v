/*
--------------------------------------------------------------------------------
 Title        : measurement_counter
 Project      : 180-voltmeter
 File         : measurement_counter.v
 Description  : Counter module that tracks the number of pulses taken during
                voltmeter deintegration. Provides a 12-bit counter that can be enabled
                and cleared based on control signals.

 Author       : Tristan Wood tdwood2@ncsu.edu
 Created      : 2025-09-11
 License      : See LICENSE in the project root

 Revision History:
   - 1.0 2025-09-11 Tristan Wood 
            Initial implementation of measurement counter
   - 1.1 2026-01-16 Tristan Wood 
            Removed debug signals for challenge rtl
--------------------------------------------------------------------------------
*/

module measurement_counter (
    // Clock and reset
    input wire clk_i,
    input wire rst_n_i,
    
    // Control inputs
    input wire measurement_en_i,         // Pulse to increment counter
    input wire measurement_clear_i,       // Clear counter (active high)
    
    // Outputs
    output wire [11:0] measurement_count_o   // Counter (calibrated output)
);
    //==============================================================================
    // Internal Signal Declarations
    //==============================================================================
    
    // Current state register
    reg [11:0] current_measurement_count;  // Counts 0 to 4095
    
    // Next state signal
    reg [11:0] next_measurement_count;

    //==============================================================================
    // Sequential Logic (State Register Update)
    //==============================================================================
    always @(posedge clk_i or negedge rst_n_i) begin
        if (!rst_n_i) begin
            current_measurement_count <= 12'd0;
        end else begin
            current_measurement_count <= next_measurement_count;
        end
    end

    //==============================================================================
    // Combinational Logic (Next State Generation)
    //==============================================================================
    // Priority: clear > increment (clear takes precedence if both asserted)
    always @(*) begin
        next_measurement_count = current_measurement_count;
        
        if(measurement_en_i) begin
            next_measurement_count = current_measurement_count + 1'b1;
        end
        
        // Clear takes priority over increment
        if(measurement_clear_i) begin
            next_measurement_count = 12'd0;
        end
    end

    //==============================================================================
    // Output Assignments
    //==============================================================================

    assign measurement_count_o = current_measurement_count;

endmodule