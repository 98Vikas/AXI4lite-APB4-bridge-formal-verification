`timescale 1ns/1ps

interface axi4lite_tb_if #(parameter ADDR_WIDTH = 32,
                           parameter DATA_WIDTH = 32)
(
    input logic ACLK,
    input logic ARESETn
);

    logic [ADDR_WIDTH-1:0] AWADDR;
    logic [2:0]            AWPROT;
    logic                  AWVALID;
    logic                  AWREADY;

    logic [DATA_WIDTH-1:0] WDATA;
    logic [DATA_WIDTH/8-1:0] WSTRB;
    logic                  WVALID;
    logic                  WREADY;

    logic [1:0] BRESP;
    logic       BVALID;
    logic       BREADY;

    logic [ADDR_WIDTH-1:0] ARADDR;
    logic [2:0]            ARPROT;
    logic                  ARVALID;
    logic                  ARREADY;

    logic [DATA_WIDTH-1:0] RDATA;
    logic [1:0]            RRESP;
    logic                  RVALID;
    logic                  RREADY;

endinterface
