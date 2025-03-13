module carry_lookahead_adder (
    input  logic [15:0] A_i, B_i,  // 16-bit Inputs
    input  logic Cin,             // Carry-in
    output logic [15:0] Sum_o,    // 16-bit Sum Output
    output logic Cout             // Carry-out
);
    logic [15:0] P, G; 
    logic [15:0] C;     // Carry
    
    assign P = A_i ^ B_i; //P[i] = A[i] ⊕ B[i]
    assign G = A_i & B_i; //G[i] = A[i] & B[i]
    
    assign C[0] = Cin;
    genvar i;
    generate
        for (i = 1; i < 16; i = i + 1) begin : carry_calc
            assign C[i] = G[i-1] | (P[i-1] & C[i-1]);
        end
    endgenerate
    
    assign Sum_o = P ^ C; // Sum[i] = P[i] ⊕ C[i]
    
    assign Cout = G[15] | (P[15] & C[15]);
    
endmodule

