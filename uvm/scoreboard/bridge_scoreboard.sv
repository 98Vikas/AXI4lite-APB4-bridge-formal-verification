`uvm_analysis_imp_decl(_axi)
`uvm_analysis_imp_decl(_apb)

class bridge_scoreboard extends uvm_scoreboard;
    `uvm_component_utils(bridge_scoreboard)

    uvm_analysis_imp_axi #(axi4lite_transaction, bridge_scoreboard) axi_export;
    uvm_analysis_imp_apb #(apb4_transaction, bridge_scoreboard) apb_export;

    axi4lite_transaction axi_q[$];
    apb4_transaction apb_q[$];

    int unsigned matched;
    int unsigned mismatched;

    function new(string name = "bridge_scoreboard", uvm_component parent = null);
        super.new(name, parent);
        axi_export = new("axi_export", this);
        apb_export = new("apb_export", this);
    endfunction

    function void write_axi(axi4lite_transaction tr);
        axi_q.push_back(tr);
        compare_transactions();
    endfunction

    function void write_apb(apb4_transaction tr);
        apb_q.push_back(tr);
        compare_transactions();
    endfunction

    function void compare_transactions();
        axi4lite_transaction axi_tr;
        apb4_transaction apb_tr;

        while ((axi_q.size() != 0) && (apb_q.size() != 0)) begin
            axi_tr = axi_q.pop_front();
            apb_tr = apb_q.pop_front();

            if (axi_tr.kind == axi4lite_transaction::WRITE) begin
                if (apb_tr.write !== 1'b1) begin
                    `uvm_error("SCOREBOARD", "AXI write was not converted to an APB write")
                    mismatched++;
                end else if ((axi_tr.addr !== apb_tr.addr) ||
                             (axi_tr.data !== apb_tr.data) ||
                             (axi_tr.strb !== apb_tr.strb) ||
                             (axi_tr.prot !== apb_tr.prot)) begin
                    `uvm_error("SCOREBOARD", "AXI write fields do not match APB transaction")
                    mismatched++;
                end else begin
                    matched++;
                    `uvm_info("SCOREBOARD", "AXI write matched APB write", UVM_MEDIUM)
                end
            end else begin
                if (apb_tr.write !== 1'b0) begin
                    `uvm_error("SCOREBOARD", "AXI read was not converted to an APB read")
                    mismatched++;
                end else if (axi_tr.addr !== apb_tr.addr) begin
                    `uvm_error("SCOREBOARD", "AXI read address does not match APB address")
                    mismatched++;
                end else if ((axi_tr.rdata !== apb_tr.rdata) ||
                             ((axi_tr.resp == 2'b10) !== apb_tr.slverr)) begin
                    `uvm_error("SCOREBOARD", "APB read result does not match AXI response")
                    mismatched++;
                end else begin
                    matched++;
                    `uvm_info("SCOREBOARD", "AXI read matched APB read", UVM_MEDIUM)
                end
            end
        end
    endfunction

    function void report_phase(uvm_phase phase);
        super.report_phase(phase);
        `uvm_info("SCOREBOARD",
                  $sformatf("Matched=%0d Mismatched=%0d Pending_AXI=%0d Pending_APB=%0d",
                            matched, mismatched, axi_q.size(), apb_q.size()),
                  UVM_LOW)
    endfunction
endclass
