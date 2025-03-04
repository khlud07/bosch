module spi_slave (
    input  logic clk_i,         // System clock
    input  logic reset_i,       // Reset signal
    input  logic SCK,           // SPI Clock from Master
    input  logic MOSI,          // Master Out Slave In (Data input)
    input  logic SS,            // Slave Select (Active Low)
    output logic [7:0] data_out,// Received 8-bit data
    output logic done           // Data reception complete signal
);

    typedef enum logic [1:0] {
        IDLE  = 2'b00,  // Waiting for SS to go low
        RECEIVE = 2'b01,// Receiving bits from MOSI
        DONE  = 2'b10   // Data reception complete
    } state_t;

    state_t state, next_state;
    logic [7:0] shift_reg; // Shift register to store received data
    logic [2:0] bit_count; // Bit counter (0 to 7)

    // State Transition Logic (Sequential)
    always_ff @(posedge clk_i or posedge reset_i) begin
        if (reset_i)
            state <= IDLE;
        else
            state <= next_state;
    end

    // Next State Logic (Combinational)
    always_comb begin
        case (state)
            IDLE:   next_state = (SS == 1'b0) ? RECEIVE : IDLE;
            RECEIVE: next_state = (bit_count == 3'b111) ? DONE : RECEIVE;
            DONE:   next_state = (SS == 1'b1) ? IDLE : DONE;
            default: next_state = IDLE;
        endcase
    end

    // Shift Register Logic: Data is received on the rising edge of SCK
    always_ff @(posedge SCK or posedge reset_i) begin
        if (reset_i) begin
            shift_reg <= 8'b0;
            bit_count <= 3'b000;
        end
        else if (state == RECEIVE) begin
            shift_reg <= {shift_reg[6:0], MOSI}; // Shift in data from MOSI
            bit_count <= bit_count + 1;
        end
    end

    // Output Assignments
    always_ff @(posedge clk_i or posedge reset_i) begin
        if (reset_i)
            data_out <= 8'b0;
        else if (state == DONE)
            data_out <= shift_reg; // Latch final received data
    end

    assign done = (state == DONE);

endmodule
