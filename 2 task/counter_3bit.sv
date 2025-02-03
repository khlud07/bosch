module counter_3bit (
    input  logic        clk,       
    input  logic        reset,     
    input  logic        enable,    
    output logic [2:0] count       
);

    always_ff @(posedge clk) begin
        if (reset) begin
            count <= 3'b000; 
        end else if (enable) begin
            count <= count + 1; 
        end
    end

endmodule
