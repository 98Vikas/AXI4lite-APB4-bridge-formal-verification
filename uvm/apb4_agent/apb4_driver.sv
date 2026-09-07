class apb4_driver extends uvm_driver #(apb4_transaction);
    `uvm_component_utils(apb4_driver)

    virtual apb4_if vif;
    int unsigned wait_cycles = 0;
    bit [31:0] read_data = 32'hA5A55A5A;
    bit slverr = 1'b0;

    function new(string name = "apb4_driver", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if (!uvm_config_db#(virtual apb4_if)::get(this, "", "vif", vif))
            `uvm_fatal("APB_DRV", "APB virtual interface not set")
        void'(uvm_config_db#(int unsigned)::get(this, "", "wait_cycles", wait_cycles));
        void'(uvm_config_db#(bit [31:0])::get(this, "", "read_data", read_data));
        void'(uvm_config_db#(bit)::get(this, "", "slverr", slverr));
    endfunction

    task run_phase(uvm_phase phase);
        vif.pready  <= 1'b0;
        vif.prdata  <= '0;
        vif.pslverr <= 1'b0;

        forever begin
            wait (vif.presetn);
            @(posedge vif.pclk);
            if (vif.psel && !vif.penable) begin
                repeat (wait_cycles) @(posedge vif.pclk);
                vif.prdata  <= read_data;
                vif.pslverr <= slverr;
                vif.pready  <= 1'b1;
                @(posedge vif.pclk);
                vif.pready  <= 1'b0;
                vif.pslverr <= 1'b0;
                vif.prdata  <= '0;
            end
        end
    endtask
endclass
