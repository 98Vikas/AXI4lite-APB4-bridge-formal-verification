module bridge_covers #(
    parameter int ADDR_WIDTH = 32,
    parameter int DATA_WIDTH = 32
) (
    input logic aclk,
    input logic aresetn,
    input logic s_awvalid,
    input logic s_awready,
    input logic s_wvalid,
    input logic s_wready,
    input logic s_arvalid,
    input logic s_arready,
    input logic psel,
    input logic penable,
    input logic pwrite,
    input logic pready,
    input logic s_bvalid,
    input logic s_rvalid
);

    cp_write_path:
        cover property (@(posedge aclk) disable iff (!aresetn)
            (s_awvalid && s_awready) ##[1:4]
            (s_wvalid && s_wready) ##[1:6]
            (psel && penable && pwrite && pready) ##1
            s_bvalid);

    cp_read_path:
        cover property (@(posedge aclk) disable iff (!aresetn)
            (s_arvalid && s_arready) ##[1:6]
            (psel && penable && !pwrite && pready) ##1
            s_rvalid);

    cp_apb_wait_state:
        cover property (@(posedge aclk) disable iff (!aresetn)
            psel && penable && !pready ##1
            psel && penable && !pready ##1
            psel && penable && pready);

endmodule
