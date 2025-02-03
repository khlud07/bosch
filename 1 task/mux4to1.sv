module mux4to1 (
    input logic a,      // Input a
    input logic b,      // Input b
    input logic c,      // Input c
    input logic d,      // Input d
    input logic [1:0] sel, // 2-bit select line
    output logic y      // Output y
);

    always_comb begin
        case (sel)
            2'b00: y = a; // Select input a
            2'b01: y = b; // Select input b
            2'b10: y = c; // Select input c
            2'b11: y = d; // Select input d
            default: y = 1'b0; // Default case (not strictly needed for 2-bit sel)
        endcase
    end

endmodule
