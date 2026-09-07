class axi4lite_monitor extends uvm_monitor;
    `uvm_component_utils(axi4lite_monitor)

    virtual axi4lite_if vif;
    uvm_analysis_port #(axi4lite_transaction) item_collected_port;

    bit [31:0] wr_addr;
    bit [2:0]  wr_prot;
    bit [31:0] wr_data;
    bit [3:0]  wr_strb;
    bit         got_aw;
    bit         got_w;

    function new(string name = "axi4lite_monitor", uvm_component parent = null);
        super.new(name, parent);
        item_collected_port = new("item_collected_port", this);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if (!uvm_config_db#(virtual axi4lite_if)::get(this, "", "vif", vif))
            `uvm_fatal("AXI_MON", "AXI virtual interface not set")
    endfunction

    task run_phase(uvm_phase phase);
        axi4lite_transaction tr;
        forever begin
            @(posedge vif.aclk);
            if (!vif.aresetn) begin
                got_aw = 1'b0;
                got_w  = 1'b0;
            end else begin
                if (vif.awvalid && vif.awready) begin
                    wr_addr = vif.awaddr;
                    wr_prot = vif.awprot;
                    got_aw  = 1'b1;
                end
                if (vif.wvalid && vif.wready) begin
                    wr_data = vif.wdata;
                    wr_strb = vif.wstrb;
                    got_w   = 1'b1;
                end
                if (vif.bvalid && vif.bready && got_aw && got_w) begin
                    tr = axi4lite_transaction::type_id::create("write_observed");
                    tr.kind = axi4lite_transaction::WRITE;
                    tr.addr = wr_addr;
                    tr.prot = wr_prot;
                    tr.data = wr_data;
                    tr.strb = wr_strb;
                    tr.resp = vif.bresp;
                    item_collected_port.write(tr);
                    got_aw = 1'b0;
                    got_w  = 1'b0;
                end
                if (vif.arvalid && vif.arready) begin
                    tr = axi4lite_transaction::type_id::create("read_observed");
                    tr.kind = axi4lite_transaction::READ;
                    tr.addr = vif.araddr;
                    tr.prot = vif.arprot;
                    @(posedge vif.aclk);
                    wait (vif.rvalid);
                    tr.rdata = vif.rdata;
                    tr.resp  = vif.rresp;
                    if (vif.rready)
                        item_collected_port.write(tr);
                    else begin
                        do @(posedge vif.aclk); while (!vif.rready);
                        item_collected_port.write(tr);
                    end
                end
            end
        end
    endtask
endclass
