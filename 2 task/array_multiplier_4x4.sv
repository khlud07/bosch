module array_multiplier_4x4 (
  input  logic [3:0] A_i, B_i,
  output logic [7:0] Product_o
);
    
    logic [3:0] pp[3:0]; // Partial products
    logic [7:0] sum[2:0]; // Intermediate sums
    
    
    genvar i, j;
    generate
        for (i = 0; i < 4; i++) begin : gen_pp
            for (j = 0; j < 4; j++) begin : gen_pp_inner
              assign pp[i][j] = A_i[j] & B_i[i];
            end
        end
    endgenerate
    
    
    assign sum[0] = {4'b0000, pp[0]};
    
    assign sum[1] = sum[0] + {3'b000, pp[1], 1'b0};
    assign sum[2] = sum[1] + {2'b00, pp[2], 2'b00};
    assign Product_o = sum[2] + {1'b0, pp[3], 3'b000};
    
endmodule