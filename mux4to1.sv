// Everything is cool, need to fix inputs names --> see adder comment
module mux4to1 (
    input logic a_i,      // Input a
    input logic b_i,      // Input b
    input logic c_i,      // Input c
    input logic d_i,      // Input d
    input logic [1:0] sel_i, // 2-bit select line
    output logic y_o      // Output y
);

    always_comb begin
        case (sel_i)
        // You could even write: 
        // 0: y = a;
        // 1: y = b;
        // Just shorter line of code (also depends on your task, if you want to highlight bit behaviour it still looks ok)
            0: y_o = a_i; // Select input a
            1: y_o = b_i; // Select input b
            2: y_o = c_i; // Select input c
            3: y_o = d_i; // Select input d
            default: y_o = 1'b0; // Default case (not strictly needed for 2-bit sel)
        endcase
    end

endmodule
