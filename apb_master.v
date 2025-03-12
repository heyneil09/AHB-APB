module apb_master (
    input  logic        PCLK, PRESETn,
    input  logic        PREADY,
    input  logic [31:0] PRDATA,
    output logic [31:0] PADDR,
    output logic [31:0] PWDATA,
    output logic        PWRITE,
    output logic        PENABLE,
    output logic        PSEL
);
    typedef enum logic {IDLE = 1'b0, SETUP = 1'b1, ACCESS = 1'b1} state_t;
    state_t state;

    // Initialize signals
    initial begin
        state = IDLE;
        PADDR = 32'h0;
        PWDATA = 32'h0;
        PWRITE = 1'b0;
        PENABLE = 1'b0;
        PSEL = 1'b0;
    end

    // APB Master FSM
    always_ff @(posedge PCLK or negedge PRESETn) begin
        if (!PRESETn) begin
            state <= IDLE;
            PENABLE <= 1'b0;
            PSEL <= 1'b0;
        end else begin
            case (state)
                IDLE: begin
                    PSEL <= 1'b1;
                    PENABLE <= 1'b0;
                    state <= SETUP;
                end
                SETUP: begin
                    PENABLE <= 1'b1;
                    state <= ACCESS;
                end
                ACCESS: begin
                    if (PREADY) begin
                        PSEL <= 1'b0;
                        PENABLE <= 1'b0;
                        state <= IDLE;
                    end
                end
            endcase
        end
    end
endmodule
