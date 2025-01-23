// Everything is cool, need to fix inputs names --> see adder comment
module mux2to1 (
    input logic a_i, b_i, sel_i,
    output logic y_o
);
    assign y_o = (sel_i) ? b_i : a_i;
endmodule
