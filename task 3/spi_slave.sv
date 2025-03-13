module spi_slave (
    input  logic clk_i,         // System clock
    input  logic reset_i,       // Reset signal
    input  logic SCK,           // SPI Clock from Master
    input  logic MOSI,          // MOSI input
    input  logic SS,            // Slave Select (Active Low)
    output logic MISO,          // MISO output
    output logic [7:0] data_out,// Received 8-bit data
    output logic done           // Data reception complete signal
);

    typedef enum logic [1:0] {
        IDLE    = 2'b00,  // Waiting for SS to go low
        RECEIVE = 2'b01,  // Receiving bits from MOSI
        DONE    = 2'b10   // Data reception complete
    } state_t;

    state_t state, next_state;
    logic [7:0] shift_reg_rx;  // Shift register for received data
    logic [7:0] shift_reg_tx;  // Shift register for transmitted data
    logic [2:0] bit_count;     // Bit counter (0 to 7)
    logic sck_sync_1, sck_sync_2, sck_rising, sck_falling;

    always_ff @(posedge clk_i or posedge reset_i) begin
        if (reset_i) begin
            sck_sync_1 <= 0;
            sck_sync_2 <= 0;
        end else begin
            sck_sync_1 <= SCK;
            sck_sync_2 <= sck_sync_1;
        end
    end

    assign sck_rising  = (sck_sync_1 & ~sck_sync_2); // Rising edge
    assign sck_falling = (~sck_sync_1 & sck_sync_2); // Falling edge

    always_ff @(posedge clk_i or posedge reset_i) begin
        if (reset_i)
            state <= IDLE;
        else
            state <= next_state;
    end

    always_comb begin
        case (state)
            IDLE:    next_state = (SS == 1'b0) ? RECEIVE : IDLE;
            RECEIVE: next_state = (bit_count == 3'b111) ? DONE : RECEIVE;
            DONE:    next_state = (SS == 1'b1) ? IDLE : DONE;
            default: next_state = IDLE;
        endcase
    end

    always_ff @(posedge clk_i or posedge reset_i) begin
        if (reset_i) begin
            shift_reg_rx <= 8'b0;
            bit_count    <= 3'b000;
        end
        else if (sck_rising && state == RECEIVE) begin
            shift_reg_rx <= {shift_reg_rx[6:0], MOSI}; // Shift left, capture MOSI
            bit_count    <= bit_count + 1;
        end
    end

    always_ff @(posedge clk_i or posedge reset_i) begin
        if (reset_i) begin
            shift_reg_tx <= 8'b10101010; // Test value for transmission
        end
        else if (sck_falling && state == RECEIVE) begin
            shift_reg_tx <= {shift_reg_tx[6:0], 1'b0}; // Shift right, send next bit
        end
    end

    assign MISO = shift_reg_tx[7];

    always_ff @(posedge clk_i or posedge reset_i) begin
        if (reset_i)
            data_out <= 8'b0;
        else if (state == DONE)
            data_out <= shift_reg_rx;
    end


    assign done = (state == DONE);

endmodule
