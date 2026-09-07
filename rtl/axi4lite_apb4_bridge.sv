module axi4lite_apb4_bridge #(
    parameter int ADDR_WIDTH = 32,
    parameter int DATA_WIDTH = 32
) (
    input  logic                  aclk,
    input  logic                  aresetn,

    input  logic [ADDR_WIDTH-1:0] s_awaddr,
    input  logic [2:0]            s_awprot,
    input  logic                  s_awvalid,
    output logic                  s_awready,

    input  logic [DATA_WIDTH-1:0] s_wdata,
    input  logic [(DATA_WIDTH/8)-1:0] s_wstrb,
    input  logic                  s_wvalid,
    output logic                  s_wready,

    output logic [1:0]            s_bresp,
    output logic                  s_bvalid,
    input  logic                  s_bready,

    input  logic [ADDR_WIDTH-1:0] s_araddr,
    input  logic [2:0]            s_arprot,
    input  logic                  s_arvalid,
    output logic                  s_arready,

    output logic [DATA_WIDTH-1:0] s_rdata,
    output logic [1:0]            s_rresp,
    output logic                  s_rvalid,
    input  logic                  s_rready,

    output logic [ADDR_WIDTH-1:0] paddr,
    output logic [2:0]            pprot,
    output logic                  psel,
    output logic                  penable,
    output logic                  pwrite,
    output logic [DATA_WIDTH-1:0] pwdata,
    output logic [(DATA_WIDTH/8)-1:0] pstrb,
    input  logic                  pready,
    input  logic [DATA_WIDTH-1:0] prdata,
    input  logic                  pslverr
);

    localparam int STRB_WIDTH = DATA_WIDTH / 8;

    typedef enum logic [2:0] {
        ST_IDLE,
        ST_APB_SETUP,
        ST_APB_ACCESS,
        ST_WRITE_RESP,
        ST_READ_RESP
    } state_t;

    state_t state;

    logic [ADDR_WIDTH-1:0] awaddr_reg;
    logic [2:0]            awprot_reg;
    logic                  aw_pending;

    logic [DATA_WIDTH-1:0] wdata_reg;
    logic [STRB_WIDTH-1:0] wstrb_reg;
    logic                  w_pending;

    logic [ADDR_WIDTH-1:0] araddr_reg;
    logic [2:0]            arprot_reg;

    logic                  apb_is_write;
    logic [1:0]            bresp_reg;
    logic [DATA_WIDTH-1:0] rdata_reg;
    logic [1:0]            rresp_reg;

    assign s_awready = (state == ST_IDLE) && !aw_pending;
    assign s_wready  = (state == ST_IDLE) && !w_pending;

    // Give a write priority when a write channel is active in the current cycle.
    assign s_arready = (state == ST_IDLE) &&
                       !aw_pending &&
                       !w_pending &&
                       !s_awvalid &&
                       !s_wvalid;

    assign s_bvalid = (state == ST_WRITE_RESP);
    assign s_bresp  = bresp_reg;

    assign s_rvalid = (state == ST_READ_RESP);
    assign s_rdata  = rdata_reg;
    assign s_rresp  = rresp_reg;

    assign psel    = (state == ST_APB_SETUP) || (state == ST_APB_ACCESS);
    assign penable = (state == ST_APB_ACCESS);
    assign pwrite  = apb_is_write;

    assign paddr  = apb_is_write ? awaddr_reg : araddr_reg;
    assign pprot  = apb_is_write ? awprot_reg : arprot_reg;
    assign pwdata = wdata_reg;
    assign pstrb  = apb_is_write ? wstrb_reg : '0;

    always_ff @(posedge aclk or negedge aresetn) begin
        if (!aresetn) begin
            state        <= ST_IDLE;
            awaddr_reg   <= '0;
            awprot_reg   <= '0;
            aw_pending   <= 1'b0;
            wdata_reg    <= '0;
            wstrb_reg    <= '0;
            w_pending    <= 1'b0;
            araddr_reg   <= '0;
            arprot_reg   <= '0;
            apb_is_write <= 1'b0;
            bresp_reg    <= 2'b00;
            rdata_reg    <= '0;
            rresp_reg    <= 2'b00;
        end else begin
            case (state)

                ST_IDLE: begin
                    if (s_awvalid && s_awready) begin
                        awaddr_reg <= s_awaddr;
                        awprot_reg <= s_awprot;
                        aw_pending <= 1'b1;
                    end

                    if (s_wvalid && s_wready) begin
                        wdata_reg <= s_wdata;
                        wstrb_reg <= s_wstrb;
                        w_pending <= 1'b1;
                    end

                    if (s_arvalid && s_arready) begin
                        araddr_reg   <= s_araddr;
                        arprot_reg   <= s_arprot;
                        apb_is_write <= 1'b0;
                        state        <= ST_APB_SETUP;
                    end

                    if ((aw_pending && w_pending) &&
                        !(s_arvalid && s_arready)) begin
                        apb_is_write <= 1'b1;
                        aw_pending   <= 1'b0;
                        w_pending    <= 1'b0;
                        state        <= ST_APB_SETUP;
                    end
                end

                ST_APB_SETUP: begin
                    state <= ST_APB_ACCESS;
                end

                ST_APB_ACCESS: begin
                    if (pready) begin
                        if (apb_is_write) begin
                            bresp_reg <= pslverr ? 2'b10 : 2'b00;
                            state     <= ST_WRITE_RESP;
                        end else begin
                            rdata_reg <= prdata;
                            rresp_reg <= pslverr ? 2'b10 : 2'b00;
                            state     <= ST_READ_RESP;
                        end
                    end
                end

                ST_WRITE_RESP: begin
                    if (s_bready) begin
                        state <= ST_IDLE;
                    end
                end

                ST_READ_RESP: begin
                    if (s_rready) begin
                        state <= ST_IDLE;
                    end
                end

                default: begin
                    state <= ST_IDLE;
                end

            endcase
        end
    end

endmodule
