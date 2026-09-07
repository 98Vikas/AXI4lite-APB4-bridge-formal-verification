class apb4_transaction extends uvm_sequence_item;
    rand bit [31:0] addr;
    rand bit [31:0] data;
    rand bit [3:0]  strb;
    rand bit [2:0]  prot;
    rand bit        write;

    bit [31:0] rdata;
    bit        slverr;

    `uvm_object_utils_begin(apb4_transaction)
        `uvm_field_int(addr, UVM_DEFAULT)
        `uvm_field_int(data, UVM_DEFAULT)
        `uvm_field_int(strb, UVM_DEFAULT)
        `uvm_field_int(prot, UVM_DEFAULT)
        `uvm_field_int(write, UVM_DEFAULT)
        `uvm_field_int(rdata, UVM_DEFAULT)
        `uvm_field_int(slverr, UVM_DEFAULT)
    `uvm_object_utils_end

    function new(string name = "apb4_transaction");
        super.new(name);
        strb = 4'hF;
    endfunction
endclass
