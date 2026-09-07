class axi4lite_driver extends uvm_driver #(axi4lite_transaction);
    `uvm_component_utils(axi4lite_driver)

    virtual axi4lite_if vif;

    function new(string name = "axi4lite_driver", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if (!uvm_config_db#(virtual axi4lite_if)::get(this, "", "vif", vif))
            `uvm_fatal("AXI_DRV", "AXI virtual interface not set")
    endfunction

    task run_phase(uvm_phase phase);
        axi4lite_transaction tr;
        vif.awvalid <= 1'b0;
        vif.wvalid  <= 1'b0;
        vif.bready  <= 1'b0;
        vif.arvalid <= 1'b0;
        vif.rready  <= 1'b0;

        forever begin
            wait (vif.aresetn);
            seq_item_port.get_next_item(tr);
            if (tr.kind == axi4lite_transaction::WRITE)
                drive_write(tr);
            else
                drive_read(tr);
            seq_item_port.item_done();
        end
    endtask

    task drive_write(axi4lite_transaction tr);
        if (tr.write_order == axi4lite_transaction::AW_FIRST) begin
            drive_aw(tr);
            @(posedge vif.aclk);
            drive_w(tr);
        end else begin
            drive_w(tr);
            @(posedge vif.aclk);
            drive_aw(tr);
        end

        @(posedge vif.aclk);
        vif.bready <= 1'b1;
        do @(posedge vif.aclk); while (!vif.bvalid);
        tr.resp = vif.bresp;
        vif.bready <= 1'b0;
    endtask

    task drive_aw(axi4lite_transaction tr);
        vif.awaddr  <= tr.addr;
        vif.awprot  <= tr.prot;
        vif.awvalid <= 1'b1;
        do @(posedge vif.aclk); while (!vif.awready);
        vif.awvalid <= 1'b0;
    endtask

    task drive_w(axi4lite_transaction tr);
        vif.wdata  <= tr.data;
        vif.wstrb  <= tr.strb;
        vif.wvalid <= 1'b1;
        do @(posedge vif.aclk); while (!vif.wready);
        vif.wvalid <= 1'b0;
    endtask

    task drive_read(axi4lite_transaction tr);
        vif.araddr  <= tr.addr;
        vif.arprot  <= tr.prot;
        vif.arvalid <= 1'b1;
        do @(posedge vif.aclk); while (!vif.arready);
        vif.arvalid <= 1'b0;

        @(posedge vif.aclk);
        vif.rready <= 1'b1;
        do @(posedge vif.aclk); while (!vif.rvalid);
        tr.rdata = vif.rdata;
        tr.resp  = vif.rresp;
        vif.rready <= 1'b0;
    endtask
endclass
