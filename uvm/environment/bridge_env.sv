class bridge_env extends uvm_env;
    `uvm_component_utils(bridge_env)

    axi4lite_agent axi_agent;
    apb4_agent     apb_agent;
    bridge_scoreboard scoreboard;
    bridge_coverage coverage;

    function new(string name = "bridge_env", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        axi_agent = axi4lite_agent::type_id::create("axi_agent", this);
        apb_agent = apb4_agent::type_id::create("apb_agent", this);
        scoreboard = bridge_scoreboard::type_id::create("scoreboard", this);
        coverage = bridge_coverage::type_id::create("coverage", this);

        axi_agent.is_active = UVM_ACTIVE;
        apb_agent.is_active = UVM_ACTIVE;
    endfunction

    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);

        axi_agent.monitor.item_collected_port.connect(scoreboard.axi_export);
        apb_agent.monitor.item_collected_port.connect(scoreboard.apb_export);
        axi_agent.monitor.item_collected_port.connect(coverage.analysis_export);
    endfunction
endclass
