module apb_reference_model #(
    parameter ADDR_WIDTH = 32,
    parameter DATA_WIDTH = 32
);

    logic [DATA_WIDTH-1:0] last_write_data;
    logic [ADDR_WIDTH-1:0] last_write_addr;
    logic [DATA_WIDTH-1:0] last_read_data;

    task automatic record_write(
        input logic [ADDR_WIDTH-1:0] addr,
        input logic [DATA_WIDTH-1:0] data
    );
        last_write_addr = addr;
        last_write_data = data;
    endtask

    task automatic record_read(
        input logic [DATA_WIDTH-1:0] data
    );
        last_read_data = data;
    endtask

endmodule
