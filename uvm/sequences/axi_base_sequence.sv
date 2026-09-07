class axi_base_sequence extends uvm_sequence #(axi4lite_transaction);
    `uvm_object_utils(axi_base_sequence)

    function new(string name = "axi_base_sequence");
        super.new(name);
    endfunction

    task send_write(bit [31:0] addr, bit [31:0] data,
                    bit [3:0] strb = 4'hF,
                    bit [2:0] prot = 3'b000,
                    axi4lite_transaction::order_t order = axi4lite_transaction::AW_FIRST);
        axi4lite_transaction tr;
        tr = axi4lite_transaction::type_id::create("write_item");
        start_item(tr);
        tr.kind = axi4lite_transaction::WRITE;
        tr.addr = addr;
        tr.data = data;
        tr.strb = strb;
        tr.prot = prot;
        tr.write_order = order;
        finish_item(tr);
    endtask

    task send_read(bit [31:0] addr, bit [2:0] prot = 3'b000);
        axi4lite_transaction tr;
        tr = axi4lite_transaction::type_id::create("read_item");
        start_item(tr);
        tr.kind = axi4lite_transaction::READ;
        tr.addr = addr;
        tr.prot = prot;
        finish_item(tr);
    endtask
endclass
