class axi_read_sequence extends axi_base_sequence;
    `uvm_object_utils(axi_read_sequence)

    function new(string name = "axi_read_sequence");
        super.new(name);
    endfunction

    task body();
        send_read(32'h0000_0010, 3'b000);
        send_read(32'h0000_0020, 3'b000);
    endtask
endclass
