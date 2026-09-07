module apb4_protocol_sva #(
    parameter int ADDR_WIDTH = 32,
    parameter int DATA_WIDTH = 32
) (
    input logic aclk,
    input logic aresetn,
    input logic [ADDR_WIDTH-1:0] paddr,
    input logic [2:0] pprot,
    input logic psel,
    input logic penable,
    input logic pwrite,
    input logic [DATA_WIDTH-1:0] pwdata,
    input logic [(DATA_WIDTH/8)-1:0] pstrb,
    input logic pready,
    input logic [DATA_WIDTH-1:0] prdata,
    input logic pslverr
);

    ap_penable_requires_psel:
        assert property (@(posedge aclk) disable iff (!aresetn)
            penable |-> psel);

    ap_setup_to_access:
        assert property (@(posedge aclk) disable iff (!aresetn)
            psel && !penable |=> psel && penable);

    ap_access_wait:
        assert property (@(posedge aclk) disable iff (!aresetn)
            psel && penable && !pready |=> psel && penable);

    ap_access_stable:
        assert property (@(posedge aclk) disable iff (!aresetn)
            psel && penable && !pready |=> psel && penable &&
            $stable(paddr) &&
            $stable(pprot) &&
            $stable(pwrite) &&
            $stable(pwdata) &&
            $stable(pstrb));

    ap_idle_penetration:
        assert property (@(posedge aclk) disable iff (!aresetn)
            !psel |-> !penable);

endmodule
