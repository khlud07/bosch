module spi_master (
    input  logic clk_i,        // clock
    input  logic reset_i,      // Reset
    input  logic [7:0] data_in,// 8-bit data to transmit
    input  logic start_i,      // Start transmission signal
    input  logic MISO,         // Master In Slave Out
    output logic MOSI,         // Master Out Slave In
    output logic SCK,          // SPI Clock
    output logic CS,           // Chip Select (Active Low)
    output logic [7:0] data_out, // Received data from slave
    output logic done          // Transmission complete signal
);

    typedef enum logic [1:0] {
        IDLE  = 2'b00,  // Waiting for start signal
        LOAD  = 2'b01,  // Load data and start shifting
        SHIFT = 2'b10,  // Shift bits out on MOSI
        DONE  = 2'b11   // Transmission completed
    } state_t;

    state_t state, next_state;
    logic [7:0] shift_reg; // Shift register for transmission
    logic [7:0] recv_reg;  // Register for received data
    logic [2:0] bit_count; // Bit counter (0 to 7)
    logic sck_internal;    // Internal SPI clock signal

    always_ff @(posedge clk_i or posedge reset_i) begin
        if (reset_i)
            state <= IDLE;
        else
            state <= next_state;
    end

    always_comb begin
        case (state)
            IDLE:  next_state = (start_i) ? LOAD : IDLE;
            LOAD:  next_state = SHIFT;
            SHIFT: next_state = (bit_count == 3'b111) ? DONE : SHIFT;
            DONE:  next_state = IDLE;
            default: next_state = IDLE;
        endcase
    end

    always_ff @(posedge sck_internal or posedge reset_i) begin
    if (reset_i) begin
        shift_reg <= 8'b0;
        recv_reg <= 8'b0;
        bit_count <= 3'b000;
    end else begin
        if (state == LOAD) begin
            shift_reg <= data_in;
            recv_reg <= 8'b0;
            bit_count <= 3'b000;
        end else if (state == SHIFT) begin
            shift_reg <= {shift_reg[6:0], 1'b0}; // Shift left
            recv_reg <= {recv_reg[6:0], MISO};  // Shift in received bit
            bit_count <= bit_count + 1;
        end
    end
end


    always_ff @(posedge clk_i or posedge reset_i) begin
        if (reset_i)
            sck_internal <= 1'b0;
        else if (state == SHIFT)
            sck_internal <= ~sck_internal; // Toggle SCK
    end

    assign SCK = sck_internal; // internal clock to output SCK
    assign MOSI = shift_reg[7]; // Transmit MSB first
    assign CS = (state == IDLE); // CS is active low, deactivate in IDLE state
    assign data_out = recv_reg;  // Assign received data to output
    assign done = (state == DONE);

endmodule
