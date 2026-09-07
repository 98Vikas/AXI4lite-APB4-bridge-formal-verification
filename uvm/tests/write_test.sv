class write_test extends base_test;
    `uvm_component_utils(write_test)

    function new(string name = "write_test", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    task run_phase(uvm_phase phase);
        axi_write_sequence seq;
        phase.raise_objection(this);
        seq = axi_write_sequence::type_id::create("seq");
        seq.start(env.axi_agent.sequencer);
        #20ns;
        phase.drop_objection(this);
    endtask
endclass
