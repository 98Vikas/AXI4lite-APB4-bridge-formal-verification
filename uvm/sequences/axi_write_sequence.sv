class axi_write_sequence extends axi_base_sequence;
    `uvm_object_utils(axi_write_sequence)

    function new(string name = "axi_write_sequence");
        super.new(name);
    endfunction

    task body();
        send_write(32'h0000_0010, 32'h1234_5678, 4'hF, 3'b000,
                   axi4lite_transaction::AW_FIRST);
        send_write(32'h0000_0020, 32'hA5A5_5A5A, 4'h3, 3'b000,
                   axi4lite_transaction::W_FIRST);
    endtask
endclass
