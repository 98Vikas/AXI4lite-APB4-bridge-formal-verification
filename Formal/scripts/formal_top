module formal_top;

    localparam int ADDR_WIDTH = 32;
    localparam int DATA_WIDTH = 32;

    logic aclk;
    logic aresetn;

    logic [ADDR_WIDTH-1:0] s_awaddr;
    logic [2:0] s_awprot;
    logic s_awvalid;
    logic s_awready;

    logic [DATA_WIDTH-1:0] s_wdata;
    logic [(DATA_WIDTH/8)-1:0] s_wstrb;
    logic s_wvalid;
    logic s_wready;

    logic [1:0] s_bresp;
    logic s_bvalid;
    logic s_bready;

    logic [ADDR_WIDTH-1:0] s_araddr;
    logic [2:0] s_arprot;
    logic s_arvalid;
    logic s_arready;

    logic [DATA_WIDTH-1:0] s_rdata;
    logic [1:0] s_rresp;
    logic s_rvalid;
    logic s_rready;

    logic [ADDR_WIDTH-1:0] paddr;
    logic [2:0] pprot;
    logic psel;
    logic penable;
    logic pwrite;
    logic [DATA_WIDTH-1:0] pwdata;
    logic [(DATA_WIDTH/8)-1:0] pstrb;
    logic pready;
    logic [DATA_WIDTH-1:0] prdata;
    logic pslverr;

    axi4lite_apb4_bridge #(
        .ADDR_WIDTH(ADDR_WIDTH),
        .DATA_WIDTH(DATA_WIDTH)
    ) dut (
        .aclk(aclk),
        .aresetn(aresetn),

        .s_awaddr(s_awaddr),
        .s_awprot(s_awprot),
        .s_awvalid(s_awvalid),
        .s_awready(s_awready),

        .s_wdata(s_wdata),
        .s_wstrb(s_wstrb),
        .s_wvalid(s_wvalid),
        .s_wready(s_wready),

        .s_bresp(s_bresp),
        .s_bvalid(s_bvalid),
        .s_bready(s_bready),

        .s_araddr(s_araddr),
        .s_arprot(s_arprot),
        .s_arvalid(s_arvalid),
        .s_arready(s_arready),

        .s_rdata(s_rdata),
        .s_rresp(s_rresp),
        .s_rvalid(s_rvalid),
        .s_rready(s_rready),

        .paddr(paddr),
        .pprot(pprot),
        .psel(psel),
        .penable(penable),
        .pwrite(pwrite),
        .pwdata(pwdata),
        .pstrb(pstrb),
        .pready(pready),
        .prdata(prdata),
        .pslverr(pslverr)
    );

    bind formal_top formal_reset_assumptions reset_assumptions_i (
        .aclk(aclk),
        .aresetn(aresetn)
    );

    bind formal_top bridge_covers covers_i (
        .aclk(aclk),
        .aresetn(aresetn),
        .s_awvalid(s_awvalid),
        .s_awready(s_awready),
        .s_wvalid(s_wvalid),
        .s_wready(s_wready),
        .s_arvalid(s_arvalid),
        .s_arready(s_arready),
        .psel(psel),
        .penable(penable),
        .pwrite(pwrite),
        .pready(pready),
        .s_bvalid(s_bvalid),
        .s_rvalid(s_rvalid)
    );

endmodule
