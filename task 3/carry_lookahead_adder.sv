module carry_lookahead_adder (
    input  logic [15:0] A_i, B_i,
    input  logic        Cin,
    output logic [15:0] Sum_o,
    output logic        Cout
);
    logic [15:0] P, G;
    logic [16:0] C;

    assign P = A_i ^ B_i;
    assign G = A_i & B_i;
    assign C[0] = Cin;

    // --- Group 0 (bits 0:3) ---
    assign C[1] = G[0] | (P[0] & C[0]);
    assign C[2] = G[1] | (P[1] & G[0]) | (P[1] & P[0] & C[0]);
    assign C[3] = G[2] | (P[2] & G[1]) | (P[2] & P[1] & G[0]) | (P[2] & P[1] & P[0] & C[0]);
    assign C[4] = G[3] | (P[3] & G[2]) | (P[3] & P[2] & G[1]) | (P[3] & P[2] & P[1] & G[0]) | (P[3] & P[2] & P[1] & P[0] & C[0]);

    // --- Group 1 (bits 4:7) ---
    assign C[5] = G[4] | (P[4] & G[3]) | (P[4] & P[3] & G[2]) | (P[4] & P[3] & P[2] & G[1]) | (P[4] & P[3] & P[2] & P[1] & C[4]);
    assign C[6] = G[5] | (P[5] & G[4]) | (P[5] & P[4] & G[3]) | (P[5] & P[4] & P[3] & G[2]) | (P[5] & P[4] & P[3] & P[2] & C[4]);
    assign C[7] = G[6] | (P[6] & G[5]) | (P[6] & P[5] & G[4]) | (P[6] & P[5] & P[4] & G[3]) | (P[6] & P[5] & P[4] & P[3] & C[4]);
    assign C[8] = G[7] | (P[7] & G[6]) | (P[7] & P[6] & G[5]) | (P[7] & P[6] & P[5] & G[4]) | (P[7] & P[6] & P[5] & P[4] & C[4]);

    // --- Group 2 (bits 8:11) ---
    assign C[9]  = G[8]  | (P[8]  & G[7])  | (P[8]  & P[7]  & G[6])  | (P[8]  & P[7]  & P[6]  & G[5])  | (P[8]  & P[7]  & P[6]  & P[5]  & C[8]);
    assign C[10] = G[9]  | (P[9]  & G[8])  | (P[9]  & P[8]  & G[7])  | (P[9]  & P[8]  & P[7]  & G[6])  | (P[9]  & P[8]  & P[7]  & P[6]  & C[8]);
    assign C[11] = G[10] | (P[10] & G[9])  | (P[10] & P[9]  & G[8])  | (P[10] & P[9]  & P[8]  & G[7])  | (P[10] & P[9]  & P[8]  & P[7]  & C[8]);
    assign C[12] = G[11] | (P[11] & G[10]) | (P[11] & P[10] & G[9])  | (P[11] & P[10] & P[9]  & G[8])  | (P[11] & P[10] & P[9]  & P[8]  & C[8]);

    // --- Group 3 (bits 12:15) ---
    assign C[13] = G[12] | (P[12] & G[11]) | (P[12] & P[11] & G[10]) | (P[12] & P[11] & P[10] & G[9]) | (P[12] & P[11] & P[10] & P[9] & C[12]);
    assign C[14] = G[13] | (P[13] & G[12]) | (P[13] & P[12] & G[11]) | (P[13] & P[12] & P[11] & G[10]) | (P[13] & P[12] & P[11] & P[10] & C[12]);
    assign C[15] = G[14] | (P[14] & G[13]) | (P[14] & P[13] & G[12]) | (P[14] & P[13] & P[12] & G[11]) | (P[14] & P[13] & P[12] & P[11] & C[12]);
    assign C[16] = G[15] | (P[15] & G[14]) | (P[15] & P[14] & G[13]) | (P[15] & P[14] & P[13] & G[12]) | (P[15] & P[14] & P[13] & P[12] & C[12]);

    // Sum calculation
    assign Sum_o = A_i ^ B_i ^ C[15:0];
    assign Cout = C[16];
endmodule
