`uvm_analysis_imp_decl(_cov_axi)

class bridge_coverage extends uvm_subscriber #(axi4lite_transaction);
    `uvm_component_utils(bridge_coverage)

    covergroup axi_cg with function sample(axi4lite_transaction tr);
        option.per_instance = 1;

        cp_kind: coverpoint tr.kind {
            bins write = {axi4lite_transaction::WRITE};
            bins read  = {axi4lite_transaction::READ};
        }

        cp_order: coverpoint tr.write_order {
            bins aw_first = {axi4lite_transaction::AW_FIRST};
            bins w_first  = {axi4lite_transaction::W_FIRST};
        }

        cp_strb: coverpoint tr.strb {
            bins byte0 = {4'h1};
            bins half  = {4'h3};
            bins word  = {4'hF};
            bins other = default;
        }

        cp_prot: coverpoint tr.prot;

        kind_x_strb: cross cp_kind, cp_strb;
    endgroup

    function new(string name = "bridge_coverage", uvm_component parent = null);
        super.new(name, parent);
        axi_cg = new();
    endfunction

    function void write(axi4lite_transaction t);
        axi_cg.sample(t);
    endfunction

    function void report_phase(uvm_phase phase);
        super.report_phase(phase);
        `uvm_info("COVERAGE", $sformatf("AXI transaction coverage = %0.2f%%", axi_cg.get_inst_coverage()), UVM_LOW)
    endfunction
endclass
