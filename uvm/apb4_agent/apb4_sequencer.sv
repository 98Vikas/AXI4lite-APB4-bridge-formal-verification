class apb4_sequencer extends uvm_sequencer #(apb4_transaction);
    `uvm_component_utils(apb4_sequencer)

    function new(string name = "apb4_sequencer", uvm_component parent = null);
        super.new(name, parent);
    endfunction
endclass
