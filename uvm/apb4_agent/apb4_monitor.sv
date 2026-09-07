class apb4_monitor extends uvm_monitor;
    `uvm_component_utils(apb4_monitor)

    virtual apb4_if vif;
    uvm_analysis_port #(apb4_transaction) item_collected_port;

    function new(string name = "apb4_monitor", uvm_component parent = null);
        super.new(name, parent);
        item_collected_port = new("item_collected_port", this);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if (!uvm_config_db#(virtual apb4_if)::get(this, "", "vif", vif))
            `uvm_fatal("APB_MON", "APB virtual interface not set")
    endfunction

    task run_phase(uvm_phase phase);
        apb4_transaction tr;
        forever begin
            @(posedge vif.pclk);
            if (!vif.presetn)
                continue;

            if (vif.psel && vif.penable && vif.pready) begin
                tr = apb4_transaction::type_id::create("apb_observed");
                tr.addr   = vif.paddr;
                tr.prot   = vif.pprot;
                tr.write  = vif.pwrite;
                tr.data   = vif.pwdata;
                tr.strb   = vif.pstrb;
                tr.rdata  = vif.prdata;
                tr.slverr = vif.pslverr;
                item_collected_port.write(tr);
            end
        end
    endtask
endclass
