/*
Everything is ok
1)Just a small comment regarding inputs and outputs
write them with _i and _o. In that way its much more easier to analyze the code:
Example a_i, b_i, ... cout_o

Module name should be the same as filename. When you work with scripts it could produce errors and unconsistency for build of project.
*/
module and_gate (
    input logic a, b,
    output logic y
);
    // It will work only for 1bit signal if you need bitwise AND operation; For wide bit correctly use &
    assign y = a && b; // Using logical AND operator
endmodule

