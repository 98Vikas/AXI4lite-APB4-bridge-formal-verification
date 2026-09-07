interface axi4lite_if #(
    parameter int ADDR_WIDTH = 32,
    parameter int DATA_WIDTH = 32
) (
    input logic aclk,
    input logic aresetn
);

    localparam int STRB_WIDTH = DATA_WIDTH / 8;

    logic [ADDR_WIDTH-1:0] awaddr;
    logic [2:0]            awprot;
    logic                  awvalid;
    logic                  awready;

    logic [DATA_WIDTH-1:0] wdata;
    logic [STRB_WIDTH-1:0] wstrb;
    logic                  wvalid;
    logic                  wready;

    logic [1:0]            bresp;
    logic                  bvalid;
    logic                  bready;

    logic [ADDR_WIDTH-1:0] araddr;
    logic [2:0]            arprot;
    logic                  arvalid;
    logic                  arready;

    logic [DATA_WIDTH-1:0] rdata;
    logic [1:0]            rresp;
    logic                  rvalid;
    logic                  rready;

    modport master (
        input  aclk, aresetn, awready, wready, bresp, bvalid,
              arready, rdata, rresp, rvalid,
        output awaddr, awprot, awvalid, wdata, wstrb, wvalid,
               bready, araddr, arprot, arvalid, rready
    );

    modport slave (
        input  aclk, aresetn, awaddr, awprot, awvalid, wdata, wstrb,
              wvalid, bready, araddr, arprot, arvalid, rready,
        output awready, wready, bresp, bvalid, arready, rdata,
               rresp, rvalid
    );

endinterface
