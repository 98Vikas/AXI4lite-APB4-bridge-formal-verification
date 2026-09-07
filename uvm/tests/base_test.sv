class base_test extends uvm_test;
    `uvm_component_utils(base_test)

    bridge_env env;

    function new(string name = "base_test", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        env = bridge_env::type_id::create("env", this);

        uvm_config_db#(int unsigned)::set(this, "env.apb_agent.driver", "wait_cycles", 0);
        uvm_config_db#(bit [31:0])::set(this, "env.apb_agent.driver", "read_data", 32'hA5A5_5A5A);
        uvm_config_db#(bit)::set(this, "env.apb_agent.driver", "slverr", 1'b0);
    endfunction

    task run_phase(uvm_phase phase);
        phase.raise_objection(this);
        #100ns;
        phase.drop_objection(this);
    endtask
endclass
