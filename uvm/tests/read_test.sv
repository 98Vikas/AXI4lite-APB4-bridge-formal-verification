class read_test extends base_test;
    `uvm_component_utils(read_test)

    function new(string name = "read_test", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    task run_phase(uvm_phase phase);
        axi_read_sequence seq;
        phase.raise_objection(this);
        seq = axi_read_sequence::type_id::create("seq");
        seq.start(env.axi_agent.sequencer);
        #20ns;
        phase.drop_objection(this);
    endtask
endclass
