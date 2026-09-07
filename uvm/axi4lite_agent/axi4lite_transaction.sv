class axi4lite_transaction extends uvm_sequence_item;
    typedef enum bit {WRITE, READ} kind_t;
    typedef enum bit {AW_FIRST, W_FIRST} order_t;

    rand kind_t kind;
    rand order_t write_order;
    rand bit [31:0] addr;
    rand bit [31:0] data;
    rand bit [3:0]  strb;
    rand bit [2:0]  prot;

    bit [1:0]  resp;
    bit [31:0] rdata;

    `uvm_object_utils_begin(axi4lite_transaction)
        `uvm_field_enum(kind_t, kind, UVM_DEFAULT)
        `uvm_field_enum(order_t, write_order, UVM_DEFAULT)
        `uvm_field_int(addr, UVM_DEFAULT)
        `uvm_field_int(data, UVM_DEFAULT)
        `uvm_field_int(strb, UVM_DEFAULT)
        `uvm_field_int(prot, UVM_DEFAULT)
        `uvm_field_int(resp, UVM_DEFAULT)
        `uvm_field_int(rdata, UVM_DEFAULT)
    `uvm_object_utils_end

    function new(string name = "axi4lite_transaction");
        super.new(name);
        strb = 4'hF;
        prot = 3'b000;
        write_order = AW_FIRST;
    endfunction
endclass
