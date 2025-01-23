// Everything is cool, need to fix inputs names --> see adder comment
module or_gate (
    input logic a_i, b_i,
    output logic y_o
);
    //Same story as for AND gate
    assign y_o = a_i || b_i; 
endmodule
