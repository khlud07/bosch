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

    // Synchronizing SCK signal to clk_i domain
    logic sck_sync_1, sck_sync_2;
    logic sck_rising, sck_falling;

    // Synchronizing MOSI to clk_i domain
    logic mosi_sync_1, mosi_sync_2;
    logic mosi_sync;

    // Synchronizing MISO to SCK domain
    logic miso_sync_1, miso_sync_2, miso_sync_3;
    logic miso_sync;

    // SCK synchronization
    always_ff @(posedge clk_i or posedge reset_i) begin
        if (reset_i) begin
            sck_sync_1 <= 0;
            sck_sync_2 <= 0;
        end else begin
            sck_sync_1 <= SCK;
            sck_sync_2 <= sck_sync_1;
        end
    end

    assign sck_rising  = (sck_sync_1 & ~sck_sync_2); // Rising edge of SCK
    assign sck_falling = (~sck_sync_1 & sck_sync_2); // Falling edge of SCK

    // MOSI synchronization to clk_i domain
    always_ff @(posedge clk_i or posedge reset_i) begin
        if (reset_i) begin
            mosi_sync_1 <= 0;
            mosi_sync_2 <= 0;
        end else begin
            mosi_sync_1 <= MOSI;
            mosi_sync_2 <= mosi_sync_1;
        end
    end

    assign mosi_sync = mosi_sync_2;  // Synced MOSI signal for clk_i domain

    // MISO synchronization to SCK domain (sending out MISO)
    always_ff @(posedge SCK or posedge reset_i) begin
        if (reset_i) begin
            miso_sync_1 <= 0;
            miso_sync_2 <= 0;
            miso_sync_3 <= 0;
        end else begin
            miso_sync_1 <= shift_reg_tx[7]; 
            miso_sync_2 <= miso_sync_1;
            miso_sync_3 <= miso_sync_2;
        end
    end
	
    
  assign miso_sync = (miso_sync_3 == 1'b1 && miso_sync == 1'b0);  // Final synchronized MISO signal

    // State machine for SPI Slave
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

    // Shift registers for receiving and transmitting data
    always_ff @(posedge clk_i or posedge reset_i) begin
        if (reset_i) begin
            shift_reg_rx <= 8'b0;
            bit_count    <= 3'b000;
        end
        else if (sck_rising && state == RECEIVE) begin
            shift_reg_rx <= {shift_reg_rx[6:0], mosi_sync}; // Shift left, capture MOSI
            bit_count    <= bit_count + 1;
        end
    end

    always_ff @(posedge clk_i or posedge reset_i) begin
        if (reset_i) begin
            shift_reg_tx <= 8'b10101010; // Test value for transmission
        end
        else if (sck_falling && state == RECEIVE) begin
            shift_reg_tx <= {shift_reg_tx[6:0], 1'b0}; // Shift right, send next bit on MISO
        end
    end

    // MISO output
    assign MISO = miso_sync;

    // Data output and done flag
    always_ff @(posedge clk_i or posedge reset_i) begin
        if (reset_i)
            data_out <= 8'b0;
        else if (state == DONE)
            data_out <= shift_reg_rx;
    end

    assign done = (state == DONE);

endmodule
