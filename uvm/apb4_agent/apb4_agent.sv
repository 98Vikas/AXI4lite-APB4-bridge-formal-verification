class apb4_agent extends uvm_agent;
    `uvm_component_utils(apb4_agent)

    apb4_sequencer sequencer;
    apb4_driver    driver;
    apb4_monitor   monitor;

    function new(string name = "apb4_agent", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        monitor = apb4_monitor::type_id::create("monitor", this);
        if (is_active == UVM_ACTIVE) begin
            sequencer = apb4_sequencer::type_id::create("sequencer", this);
            driver    = apb4_driver::type_id::create("driver", this);
        end
    endfunction

    function void connect_phase(uvm_phase phase);
        if (is_active == UVM_ACTIVE)
            driver.seq_item_port.connect(sequencer.seq_item_export);
    endfunction
endclass
