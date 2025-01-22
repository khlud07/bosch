// Everything is cool, need to fix inputs names --> see adder comment
module or_gate (
    input logic a, b,
    output logic y
);
    //Same story as for AND gate
    assign y = a || b; 
endmodule
