// Everything is cool, need to fix inputs names --> see adder comment
module mux2to1 (
    input logic a, b, sel,
    output logic y
);
    assign y = (sel) ? b : a;
endmodule