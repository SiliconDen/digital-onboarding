/*
--------------------------------------------------------------------------------
 Title        : cycle_counter
 Project      : 180-voltmeter
 File         : cycle_counter.v
 Description  : Counter module that tracks line cycles in the voltmeter.
                Provides a 5-bit counter that wraps at 24 cycles and generates
                a finished signal when the maximum count is reached.

 Author       : Tristan Wood tdwood2@ncsu.edu
 Created      : 2025-09-11
 License      : See LICENSE in the project root

 Revision History:
   - 1.0 2025-09-11 Tristan Wood 
            Initial implementation of cycle counter
   - 1.1 2026-01-16 Tristan Wood 
            Removed debug signals for challenge rtl

--------------------------------------------------------------------------------
*/

module cycle_counter (
    // Clock and reset
    input wire clk_i,
    input wire rst_n_i,
    
    // Control inputs
    input wire increment_i,              // Pulse to advance count
    input wire interrupt_clear_i,        // Clear finished flag (active high)
    
    // Outputs
    output wire finished_o,              // High when count reaches 24
    output wire [4:0] cycle_count_o,     // Current cycle count (0-24)
);
    //==============================================================================
    // Internal Signal Declarations
    //==============================================================================
    
    // Current state registers
    reg [4:0] current_cycle_count;  // Counts 0-24
    reg current_finished;
    
    // Next state signals
    reg [4:0] next_cycle_count;
    reg next_finished;

    //==============================================================================
    // Sequential Logic (State Register Update)
    //==============================================================================
    always @(posedge clk_i or negedge rst_n_i) begin
        if (!rst_n_i) begin
            current_cycle_count <= 5'd0;
            current_finished <= 1'b0;
        end else begin
            current_cycle_count <= next_cycle_count;
            current_finished <= next_finished;
        end
    end

    //==============================================================================
    // Combinational Logic (Next State Generation)
    //==============================================================================
    // Counter wraps at 24 (counts 0-24, then resets to 0)
    always @(*) begin
        next_cycle_count = current_cycle_count;
        next_finished = current_finished;
        
        if(increment_i) begin
            next_cycle_count = current_cycle_count + 1'b1;
        end
        
        // Wrap at 24 and set finished flag
        if(current_cycle_count == 5'd24) begin
            next_cycle_count = 5'd0;
            next_finished = 1'b1;
        end
        
        if(interrupt_clear_i) begin
            next_finished = 1'b0;
        end
    end

    //==============================================================================
    // Output Assignments
    //==============================================================================
    
    assign cycle_count_o = current_cycle_count;
    assign finished_o = current_finished;

endmodule