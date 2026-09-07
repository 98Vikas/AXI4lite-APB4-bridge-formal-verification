module formal_reset_assumptions (
    input logic aclk,
    input logic aresetn
);

    ap_initial_reset:
        assume property (@(posedge aclk) $initstate |-> !aresetn);

    ap_reset_releases:
        assume property (@(posedge aclk) !aresetn |=> aresetn);

endmodule
