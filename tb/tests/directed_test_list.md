# Directed Test List

The directed simulation environment is intended to exercise the main AXI4-Lite to APB4 bridge transaction scenarios.

## Write Tests

- Basic AXI4-Lite write
- AW channel before W channel
- W channel before AW channel
- AW and W accepted in the same cycle
- APB write with PREADY asserted immediately
- APB write with PREADY delayed
- APB write with PSLVERR asserted
- BVALID held while BREADY is low

## Read Tests

- Basic AXI4-Lite read
- APB read with PREADY asserted immediately
- APB read with PREADY delayed
- APB read with PSLVERR asserted
- RVALID held while RREADY is low

## Reset Tests

- Reset while idle
- Reset during an AXI transaction
- Reset during an APB transaction

## Negative / Corner Cases

- Delayed AWVALID
- Delayed WVALID
- Delayed BREADY
- Delayed RREADY
- APB wait states
- Back-to-back AXI transactions

## Regression Objective

All directed tests should complete without protocol violations and should maintain consistency between AXI transactions and corresponding APB transactions.
