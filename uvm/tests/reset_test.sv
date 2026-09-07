class reset_test extends base_test;
    `uvm_component_utils(reset_test)

    function new(string name = "reset_test", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    task run_phase(uvm_phase phase);
        phase.raise_objection(this);
        wait (env.axi_agent.driver.vif.aresetn);
        repeat (5) @(posedge env.axi_agent.driver.vif.aclk);
        if (env.axi_agent.driver.vif.bvalid ||
            env.axi_agent.driver.vif.rvalid ||
            env.apb_agent.driver.vif.psel ||
            env.apb_agent.driver.vif.penable)
            `uvm_error("RESET_TEST", "Bridge did not remain idle after reset")
        phase.drop_objection(this);
    endtask
endclass
