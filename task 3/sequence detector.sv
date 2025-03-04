module sequence_detector (
    input logic clk_i,           // Clock input
    input logic reset_i,         // Synchronous reset
    input logic in_i,            // Serial input bit
    output logic detected_o      // Output: 1 when "1011" is detected
);
    
    // State Encoding (Binary)
    typedef enum logic [2:0] {
        S0 = 3'b000,  // Initial state
        S1 = 3'b001,  // Detected "1"
        S2 = 3'b010,  // Detected "10"
        S3 = 3'b011,  // Detected "101"
        S4 = 3'b100   // Detected "1011" (Final state)
    } state_t;

    state_t current_state, next_state;

    // State Transition Logic (Sequential)
  always_ff @(posedge clk_i or posedge reset_i) begin
    if (reset_i)
            current_state <= S0;
        else
            current_state <= next_state;
    end

    // Next State Logic (Combinational)
    always_comb begin
        case (current_state)
            S0:  next_state = (in) ? S1 : S0;
            S1:  next_state = (in) ? S1 : S2;
            S2:  next_state = (in) ? S3 : S0;
            S3:  next_state = (in) ? S4 : S2;
            S4:  next_state = (in) ? S1 : S2;  // Loop back to detect overlapping sequences
            default: next_state = S0;
        endcase
    end

    // Output Logic (Moore FSM)
    assign detected_o = (current_state == S4) ? 1'b1 : 1'b0;

endmodule
