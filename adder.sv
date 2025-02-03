module adder #(parameter N = 4) (
    output logic [N-1:0] Result,   
    input  logic [N-1:0] A, B,     
    input  logic         Sub       
);
    logic [N-1:0] B_modified;      
    logic         Carry;           

    
    assign B_modified = Sub ? ~B : B;

    
    assign {Carry, Result} = A + B_modified + Sub;

endmodule
