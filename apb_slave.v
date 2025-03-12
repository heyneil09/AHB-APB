module apb_slave (
    input  logic        PCLK, PRESETn,
    input  logic [31:0] PADDR,
    input  logic [31:0] PWDATA,
    input  logic        PWRITE,
    input  logic        PENABLE,
    input  logic        PSEL,
    output logic        PREADY,
    output logic [31:0] PRDATA
);
    logic [31:0] mem [0:255]; // Memory array

    // Default response
    assign PREADY = 1'b1;

    // Read and write operations
    always_ff @(posedge PCLK or negedge PRESETn) begin
        if (!PRESETn) begin
            PRDATA <= 32'h0;
        end else if (PSEL && PENABLE) begin
            if (PWRITE) begin
                mem[PADDR[9:2]] <= PWDATA; // Write to memory
            end else begin
                PRDATA <= mem[PADDR[9:2]]; // Read from memory
            end
        end
    end
endmodule
