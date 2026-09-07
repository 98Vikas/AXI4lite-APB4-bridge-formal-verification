interface apb4_if #(
    parameter int ADDR_WIDTH = 32,
    parameter int DATA_WIDTH = 32
) (
    input logic pclk,
    input logic presetn
);

    localparam int STRB_WIDTH = DATA_WIDTH / 8;

    logic [ADDR_WIDTH-1:0] paddr;
    logic [2:0]            pprot;
    logic                  psel;
    logic                  penable;
    logic                  pwrite;
    logic [DATA_WIDTH-1:0] pwdata;
    logic [STRB_WIDTH-1:0] pstrb;
    logic                  pready;
    logic [DATA_WIDTH-1:0] prdata;
    logic                  pslverr;

    modport master (
        input  pclk, presetn, pready, prdata, pslverr,
        output paddr, pprot, psel, penable, pwrite, pwdata, pstrb
    );

    modport slave (
        input  pclk, presetn, paddr, pprot, psel, penable,
              pwrite, pwdata, pstrb,
        output pready, prdata, pslverr
    );

endinterface
