// 1-bit Full Adder 
/*
Everything is ok
1)Just a small comment regarding inputs and outputs
write them with _i and _o. In that way its much more easier to analyze the code:
Example a_i, b_i, ... cout_o

Module name should be the same as filename. When you work with scripts it could produce errors and unconsistency for build of project.
*/
module full_adder (
    input logic a,      // Input bit a
    input logic b,      // Input bit b
    input logic cin,    // Carry-in
    output logic sum,   // Sum output
    output logic cout   // Carry-out
);
    always_comb begin
        sum = a ^ b ^ cin;        // Sum calculation
        cout = (a & b) | (b & cin) | (a & cin); // Carry-out calculation
    end
endmodule

// 4-bit Ripple Carry Adder
module ripple_carry_adder (
    input logic [3:0] A,       // 4-bit input A
    input logic [3:0] B,       // 4-bit input B
    input logic Cin,           // Carry-in
    output logic [3:0] Sum,    // 4-bit Sum output
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
        .a(A[0]), .b(B[0]), .cin(Cin), .sum(Sum[0]), .cout(carry[0])
    );

    full_adder fa1 (
        .a(A[1]), .b(B[1]), .cin(carry[0]), .sum(Sum[1]), .cout(carry[1])
    );

    full_adder fa2 (
        .a(A[2]), .b(B[2]), .cin(carry[1]), .sum(Sum[2]), .cout(carry[2])
    );

    full_adder fa3 (
        .a(A[3]), .b(B[3]), .cin(carry[2]), .sum(Sum[3]), .cout(Cout)
    );

endmodule