module sequence_detector (
    input logic clk_i,           // Clock 
    input logic reset_i,         
    input logic in_i,            // Serial input bit
    output logic detected_o      // 1 when "1101" (LSB-first)
);
    
    typedef enum logic [2:0] {
        S0 = 3'b000,  // Initial 
        S1 = 3'b001,  // "1"
        S2 = 3'b010,  // "11"
        S3 = 3'b011,  // "110"
        S4 = 3'b100   // "1101" 
    } state_t;

    state_t current_state, next_state;

    always_ff @(posedge clk_i or posedge reset_i) begin
        if (reset_i)
            current_state <= S0;
        else
            current_state <= next_state;
    end

    always_comb begin
        case (current_state)
            S0:  next_state = (in_i) ? S1 : S0;  // '1'
            S1:  next_state = (in_i) ? S2 : S0;  // "11"
            S2:  next_state = (in_i) ? S2 : S3;  // "110"
            S3:  next_state = (in_i) ? S4 : S0;  // "1101"
            S4:  next_state = (in_i) ? S1 : S0;  // Overlapping detection
            default: next_state = S0;
        endcase
    end

    // Moore FSM
    assign detected_o = (current_state == S4);

endmodule

