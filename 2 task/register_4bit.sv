module register_4bit (
    input  logic        clk,        
    input  logic        reset,      
    input  logic        enable,     
    input  logic [3:0]  D,          
    output logic [3:0]  Q           
);

    always_ff @(posedge clk) begin
        if (reset) begin
            Q <= 4'b0000; 
        end else if (enable) begin
            Q <= D; 
        end
    end

endmodule