
module bridge_functional_sva #(
    parameter int ADDR_WIDTH = 32,
    parameter int DATA_WIDTH = 32
) (
    input logic aclk,
    input logic aresetn,

    input logic s_bvalid,
    input logic s_bready,
    input logic [1:0] s_bresp,

    input logic s_rvalid,
    input logic s_rready,
    input logic [DATA_WIDTH-1:0] s_rdata,
    input logic [1:0] s_rresp,

    input logic psel,
    input logic penable,
    input logic pwrite,
    input logic pready,
    input logic [DATA_WIDTH-1:0] prdata,
    input logic pslverr
);

    ap_write_response_after_apb:
        assert property (disable iff (!aresetn)
            psel && penable && pwrite && pready |=> s_bvalid);

    ap_read_response_after_apb:
        assert property (disable iff (!aresetn)
            psel && penable && !pwrite && pready |=> s_rvalid);

    ap_write_error_mapping:
        assert property (disable iff (!aresetn)
            psel && penable && pwrite && pready && pslverr
            |=> s_bvalid && s_bresp == 2'b10);

    ap_write_ok_mapping:
        assert property (disable iff (!aresetn)
            psel && penable && pwrite && pready && !pslverr
            |=> s_bvalid && s_bresp == 2'b00);

    ap_read_error_mapping:
        assert property (disable iff (!aresetn)
            psel && penable && !pwrite && pready && pslverr
            |=> s_rvalid && s_rresp == 2'b10);

    ap_read_data_mapping:
        assert property (disable iff (!aresetn)
            psel && penable && !pwrite && pready
            |=> s_rvalid && s_rdata == $past(prdata));

endmodule
