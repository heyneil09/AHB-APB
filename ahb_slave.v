module ahb_slave (
    input  logic        HCLK, HRESETn,
    input  logic [31:0] HADDR,
    input  logic [31:0] HWDATA,
    input  logic [2:0]  HSIZE,
    input  logic [1:0]  HTRANS,
    input  logic        HWRITE,
    input  logic        HSEL,
    output logic        HREADY,
    output logic [31:0] HRDATA,
    output logic [1:0]  HRESP
);
    logic [31:0] mem [0:255]; // Memory array

    // Default responses
    assign HREADY = 1'b1;
    assign HRESP = 2'b00; // OKAY response

    // Read and write operations
    always_ff @(posedge HCLK or negedge HRESETn) begin
        if (!HRESETn) begin
            HRDATA <= 32'h0;
        end else if (HSEL && HREADY) begin
            if (HWRITE) begin
                mem[HADDR[9:2]] <= HWDATA; // Write to memory
            end else begin
                HRDATA <= mem[HADDR[9:2]]; // Read from memory
            end
        end
    end
endmodule
