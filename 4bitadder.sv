// 1-bit Full Adder 
/*
Everything is ok
1)Just a small comment regarding inputs and outputs
write them with _i and _o. In that way its much more easier to analyze the code:
Example a_i, b_i, ... cout_o

Module name should be the same as filename. When you work with scripts it could produce errors and unconsistency for build of project.
*/
module full_adder (
    input logic a_i,      // Input bit a
    input logic b_i,      // Input bit b
    input logic cin,    // Carry-in
    output logic sum_o,   // Sum output
    output logic cout   // Carry-out
);
    always_comb begin
        sum = a_i ^ b_i ^ cin;        // Sum calculation
        cout = (a_i & b_i) | (b_i & cin) | (a_i & cin); // Carry-out calculation
    end
endmodule

// 4-bit Ripple Carry Adder
module ripple_carry_adder (
    input logic [3:0] A_i,       // 4-bit input A
    input logic [3:0] B_i,       // 4-bit input B
    input logic Cin,           // Carry-in
    output logic [3:0] Sum_o,    // 4-bit Sum output
    output logic Cout          // Carry-out
);
    logic [3:0] carry; // Internal carry signals

    // Instantiate the 1-bit full adders
    //Better to use generate construction for wide bit adders. For 4 bits its still ok 
        /*
        genvar i;
        generate
          for(i=0; i < BIT_WIDTH; i++)begin : ADDER
          if(i == 0)
            full_adder fa(a[i],b[i],cin,sum[i],cout[i]);
          else if(i == BIT_WIDTH -1 )
            full_adder fa(a[i],b[i],cout[i-1],sum[i],cout);
          else
            full_adder fa(a[i],b[i],cout[i-1],sum[i],cout[i]);
          end
        endgenerate
        */
    full_adder fa0 (
        .a_i(A_i[0]), .b_i(B_i[0]), .cin(Cin), .sum_o(Sum_o[0]), .cout(carry[0])
    );

    full_adder fa1 (
        .a_i(A_i[1]), .b_i(B_i[1]), .cin(carry[0]), .sum_o(Sum_o[1]), .cout(carry[1])
    );

    full_adder fa2 (
        .a_i(A_i[2]), .b_i(B_i[2]), .cin(carry[1]), .sum_o(Sum_o[2]), .cout(carry[2])
    );

    full_adder fa3 (
        .a_i(A_i[3]), .b_i(B_i[3]), .cin(carry[2]), .sum_o(Sum_o[3]), .cout(Cout)
    );

endmodule
