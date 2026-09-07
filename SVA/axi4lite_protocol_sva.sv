module axi4lite_protocol_sva #(
    parameter int ADDR_WIDTH = 32,
    parameter int DATA_WIDTH = 32
) (
    input logic aclk,
    input logic aresetn,
    input logic [ADDR_WIDTH-1:0] s_awaddr,
    input logic [2:0] s_awprot,
    input logic s_awvalid,
    input logic s_awready,
    input logic [DATA_WIDTH-1:0] s_wdata,
    input logic [(DATA_WIDTH/8)-1:0] s_wstrb,
    input logic s_wvalid,
    input logic s_wready,
    input logic [1:0] s_bresp,
    input logic s_bvalid,
    input logic s_bready,
    input logic [ADDR_WIDTH-1:0] s_araddr,
    input logic [2:0] s_arprot,
    input logic s_arvalid,
    input logic s_arready,
    input logic [DATA_WIDTH-1:0] s_rdata,
    input logic [1:0] s_rresp,
    input logic s_rvalid,
    input logic s_rready
);

    ap_aw_stable:
        assert property (@(posedge aclk) disable iff (!aresetn)
            s_awvalid && !s_awready |=> s_awvalid &&
            $stable(s_awaddr) && $stable(s_awprot));

    ap_w_stable:
        assert property (@(posedge aclk) disable iff (!aresetn)
            s_wvalid && !s_wready |=> s_wvalid &&
            $stable(s_wdata) && $stable(s_wstrb));

    ap_b_stable:
        assert property (@(posedge aclk) disable iff (!aresetn)
            s_bvalid && !s_bready |=> s_bvalid && $stable(s_bresp));

    ap_ar_stable:
        assert property (@(posedge aclk) disable iff (!aresetn)
            s_arvalid && !s_arready |=> s_arvalid &&
            $stable(s_araddr) && $stable(s_arprot));

    ap_r_stable:
        assert property (@(posedge aclk) disable iff (!aresetn)
            s_rvalid && !s_rready |=> s_rvalid &&
            $stable(s_rdata) && $stable(s_rresp));

    ap_no_new_request_during_response:
        assert property (@(posedge aclk) disable iff (!aresetn)
            (s_bvalid || s_rvalid) |->
            !(s_awready || s_wready || s_arready));

endmodule
