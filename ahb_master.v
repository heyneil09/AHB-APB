module ahb_master (
    input  logic        HCLK, HRESETn,
    input  logic        HREADY,
    input  logic [31:0] HRDATA,
    input  logic [1:0]  HRESP,
    output logic [31:0] HADDR,
    output logic [31:0] HWDATA,
    output logic [2:0]  HSIZE,
    output logic [1:0]  HTRANS,
    output logic        HWRITE,
    output logic        HBURST
);
    typedef enum logic [1:0] {IDLE = 2'b00, BUSY = 2'b01, NONSEQ = 2'b10, SEQ = 2'b11} trans_t;
    trans_t trans_state;

    logic [31:0] addr;
    logic [31:0] data;
    logic [2:0]  size;
    logic        write;
    logic [2:0]  burst;

    // Initialize signals
    initial begin
        trans_state = IDLE;
        HADDR = 32'h0;
        HWDATA = 32'h0;
        HSIZE = 3'b010; // 32-bit transfer
        HTRANS = IDLE;
        HWRITE = 1'b0;
        HBURST = 3'b000; // Single burst
    end

    // AHB Master FSM
    always_ff @(posedge HCLK or negedge HRESETn) begin
        if (!HRESETn) begin
            trans_state <= IDLE;
            HTRANS <= IDLE;
        end else begin
            case (trans_state)
                IDLE: begin
                    if (HREADY) begin
                        HADDR <= addr;
                        HWDATA <= data;
                        HTRANS <= NONSEQ;
                        trans_state <= NONSEQ;
                    end
                end
                NONSEQ: begin
                    if (HREADY) begin
                        HADDR <= addr + 4; // Increment address for next transfer
                        HTRANS <= SEQ;
                        trans_state <= SEQ;
                    end
                end
                SEQ: begin
                    if (HREADY) begin
                        HTRANS <= IDLE;
                        trans_state <= IDLE;
                    end
                end
            endcase
        end
    end
endmodule
