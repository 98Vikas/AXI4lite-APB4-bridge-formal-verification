package bridge_uvm_pkg;
    import uvm_pkg::*;
    `include "uvm_macros.svh"

    `include "axi4lite_agent/axi4lite_transaction.sv"
    `include "axi4lite_agent/axi4lite_sequencer.sv"
    `include "axi4lite_agent/axi4lite_driver.sv"
    `include "axi4lite_agent/axi4lite_monitor.sv"
    `include "axi4lite_agent/axi4lite_agent.sv"

    `include "apb4_agent/apb4_transaction.sv"
    `include "apb4_agent/apb4_sequencer.sv"
    `include "apb4_agent/apb4_driver.sv"
    `include "apb4_agent/apb4_monitor.sv"
    `include "apb4_agent/apb4_agent.sv"

    `include "sequences/axi_base_sequence.sv"
    `include "sequences/axi_write_sequence.sv"
    `include "sequences/axi_read_sequence.sv"

    `include "scoreboard/bridge_scoreboard.sv"
    `include "coverage/bridge_coverage.sv"
    `include "environment/bridge_env.sv"

    `include "tests/base_test.sv"
    `include "tests/write_test.sv"
    `include "tests/read_test.sv"
    `include "tests/reset_test.sv"
endpackage
