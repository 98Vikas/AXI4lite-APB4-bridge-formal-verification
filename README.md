# Formal Verification of an AXI4-Lite to APB4 Bridge

**SystemVerilog | SVA | UVM | Xcelium | Cadence JasperGold**

---

## Overview

This project implements and verifies a synthesizable **AXI4-Lite to APB4 protocol bridge**.

The bridge accepts AXI4-Lite read and write transactions and converts them into APB4 transactions. Responses from the APB4 peripheral are converted back into the corresponding AXI4-Lite response channels.

The project is developed with a **formal-verification-first methodology**, complemented by simulation-based verification.

The primary objective is to demonstrate the ability to reason about and verify:

* AMBA protocol behavior
* Handshake sequencing
* Transaction conversion
* Control-state correctness
* Reset behavior
* Data and address integrity
* Transaction ordering
* Error propagation
* Safety properties
* Reachability and cover properties
* Formal assumptions
* Counterexample-driven debugging
* Verification completeness and limitations

---

# 1. Project Motivation

AXI4-Lite and APB4 serve different purposes within an AMBA-based SoC.

AXI4-Lite provides a memory-mapped interface with independent read and write channels and VALID/READY handshaking, while APB4 uses a simpler setup/access transaction sequence intended for lower-complexity peripherals.

A protocol bridge therefore has to translate between two different transaction models while preserving the required architectural behavior.

The bridge introduces verification challenges involving:

* Independent AXI read and write channels
* VALID/READY handshakes
* Address and data channel coordination
* APB setup and access phases
* PREADY-dependent transaction completion
* PSLVERR propagation
* Response generation
* Back-to-back transactions
* Reset transitions
* Illegal state prevention
* Transaction loss or duplication
* Control-signal stability

These characteristics make the design suitable for both **assertion-based verification and formal verification**.

---

# 2. Verification Philosophy

The project follows the principle:

> **Simulation demonstrates behavior in selected scenarios; formal verification analyzes whether specified properties hold across all behaviors permitted by the formal environment.**

The verification flow therefore combines:

```text
                 Specification
                       |
                       v
                 Verification Plan
                       |
          +------------+------------+
          |                         |
          v                         v
   Simulation-Based            Formal Verification
     Verification                  |
          |                         |
          v                         v
   Directed/UVM Tests         Assumptions + SVA
          |                         |
          v                         v
   Scoreboard/Coverage        Proof + Cover
          |                         |
          +------------+------------+
                       |
                       v
                Counterexample
                    Analysis
                       |
                       v
                    Debug
                       |
                       v
                 Re-verification
```

---

# 3. Design Objective

The bridge is intended to:

1. Accept legal AXI4-Lite transactions.
2. Convert accepted AXI4-Lite writes into APB4 write transactions.
3. Convert accepted AXI4-Lite reads into APB4 read transactions.
4. Preserve address and write-data information.
5. Return APB read data through the AXI4-Lite read response path.
6. Convert APB error information into the appropriate AXI response.
7. Maintain protocol-correct handshake behavior.
8. Prevent transaction loss and duplication.
9. Maintain correct behavior during reset.
10. Prevent illegal internal control states.

---

# 4. High-Level Architecture

```text
                         AXI4-Lite Master
                               |
             +-----------------+-----------------+
             |                                   |
             v                                   v
       AXI Write Channels                  AXI Read Channels
             |                                   |
             +-----------------+-----------------+
                               |
                               v
                    +----------------------+
                    | AXI4-Lite Interface  |
                    |      Handling        |
                    +----------+-----------+
                               |
                               v
                    +----------------------+
                    | Transaction Control  |
                    | / Arbitration Logic  |
                    +----------+-----------+
                               |
                               v
                    +----------------------+
                    |      APB4 Master     |
                    |   Control / Engine   |
                    +----------+-----------+
                               |
                               v
                          APB4 Slave
                         Peripheral
```

The exact microarchitecture and state transitions are documented in:

`docs/architecture.md`

---

# 5. AXI4-Lite Interface

The AXI4-Lite side consists of the five independent AXI channels:

### Write Address Channel

* `AWADDR`
* `AWPROT`
* `AWVALID`
* `AWREADY`

### Write Data Channel

* `WDATA`
* `WSTRB`
* `WVALID`
* `WREADY`

### Write Response Channel

* `BRESP`
* `BVALID`
* `BREADY`

### Read Address Channel

* `ARADDR`
* `ARPROT`
* `ARVALID`
* `ARREADY`

### Read Data Channel

* `RDATA`
* `RRESP`
* `RVALID`
* `RREADY`

The supported widths and feature subset are defined in the project specification.

---

# 6. APB4 Interface

The APB4 side contains:

* `PCLK`
* `PRESETn`
* `PADDR`
* `PSEL`
* `PENABLE`
* `PWRITE`
* `PWDATA`
* `PSTRB`
* `PRDATA`
* `PREADY`
* `PSLVERR`

The bridge acts as an APB4 master and the connected peripheral is modeled as the APB4 slave.

---

# 7. AXI4-Lite to APB4 Transaction Flow

## Write Transaction

```text
AXI Master
    |
    | AWVALID/AWREADY
    | WVALID/WREADY
    v
Bridge accepts write
    |
    v
APB SETUP
PSEL = 1
PENABLE = 0
    |
    v
APB ACCESS
PSEL = 1
PENABLE = 1
    |
    | wait for PREADY
    v
Transaction completes
    |
    v
AXI BVALID
    |
    | BREADY
    v
Write response completes
```

---

## Read Transaction

```text
AXI Master
    |
    | ARVALID/ARREADY
    v
Bridge accepts read
    |
    v
APB SETUP
PSEL = 1
PENABLE = 0
    |
    v
APB ACCESS
PSEL = 1
PENABLE = 1
    |
    | wait for PREADY
    v
APB PRDATA / PSLVERR
    |
    v
AXI RVALID
    |
    | RREADY
    v
Read response completes
```

---

# 8. Verification Components

The verification environment contains two complementary layers.

## Simulation Layer

```text
                 UVM Test
                    |
                    v
              Virtual Sequence
               /            \
              v              v
      AXI4-Lite Agent      APB4 Agent
              |              |
              v              v
           Driver          Driver
              |              |
              v              v
             DUT <----------+
              |
       +------+------+
       |             |
       v             v
   AXI Monitor    APB Monitor
       |             |
       +------+------+
              |
              v
          Scoreboard
              |
              v
       Expected vs Actual
```

Additional components include:

* Functional coverage
* Protocol monitors
* Reference model
* Directed tests
* Constrained-random sequences
* Regression infrastructure

---

# 9. Formal Verification Architecture

The formal environment consists of:

```text
             Formal Harness
                  |
       +----------+----------+
       |                     |
       v                     v
 Environmental          DUT
 Assumptions               |
       |                   |
       +---------+---------+
                 |
                 v
             SVA Properties
                 |
          +------+------+
          |             |
          v             v
        Assert         Cover
          |             |
          +------+------+
                 |
                 v
        JasperGold Analysis
                 |
          +------+------+ 
          |             |
          v             v
        Proof       Counterexample
          |             |
          |             v
          |           Debug
          |             |
          +-------------+
```

---

# 10. Formal Property Categories

The formal environment will contain properties covering the following categories.

## AXI4-Lite Protocol

* VALID/READY handshake correctness
* Stability while waiting for handshake
* Response generation
* Response completion
* Reset behavior
* Channel sequencing
* Illegal control behavior

## APB4 Protocol

* Setup phase correctness
* Access phase correctness
* `PSEL` behavior
* `PENABLE` sequencing
* Address stability
* Control stability
* Completion using `PREADY`
* Response behavior
* Reset behavior

## Bridge-Level Functional Correctness

* Accepted AXI write produces the corresponding APB write.
* Accepted AXI read produces the corresponding APB read.
* APB read data is returned through the AXI read response.
* APB error status is correctly propagated.
* Transactions are not duplicated.
* Transactions are not lost.
* Address information is preserved.
* Write data and byte enables are preserved.
* Supported transaction ordering is maintained.

---

# 11. Formal Assumptions

Formal verification requires a realistic model of the environment.

The formal harness therefore defines assumptions for:

* Clock behavior
* Reset behavior
* AXI master behavior
* APB slave behavior
* Legal APB responses
* Legal AXI requests
* Environmental response timing

Assumptions are treated as part of the verification environment rather than as a mechanism to artificially simplify the proof.

Particular attention is given to avoiding **over-constraint**, where excessive assumptions can remove legal behaviors and allow an incorrect design to appear formally correct.

---

# 12. Counterexample-Driven Debugging

A formal failure is analyzed using:

```text
Property Failure
       |
       v
Counterexample Trace
       |
       v
Find First Incorrect Transition
       |
       v
Classify Failure
       |
       +---- RTL defect
       |
       +---- Property defect
       |
       +---- Assumption defect
       |
       +---- Environment/model defect
       |
       v
Correct Root Cause
       |
       v
Re-run Property
       |
       v
Regression
```

Counterexamples are treated as debugging evidence rather than simply as failed testcases.

---

# 13. Fault Injection

Selected RTL defects will be deliberately introduced to evaluate the strength of the verification environment.

Potential fault classes include:

* Incorrect AXI handshake condition
* Incorrect APB state transition
* Incorrect `PENABLE` generation
* Incorrect response generation
* Incorrect address propagation
* Incorrect write-data propagation
* Incorrect `PSLVERR` mapping
* Incorrect reset behavior
* Incorrect transaction completion condition

Each fault will be documented with:

1. Fault description
2. Modified behavior
3. Detection mechanism
4. Formal counterexample or simulation evidence
5. Root cause
6. Correct implementation
7. Re-verification result

---

# 14. Verification Metrics

The project tracks:

### Simulation

* Number of tests
* Pass/fail status
* Functional coverage
* Protocol coverage
* Corner-case coverage

### Formal

* Number of assertions
* Proven properties
* Failed properties
* Inconclusive properties
* Cover properties
* Reachability observations
* Counterexamples
* Proof complexity
* Assumption analysis

The final repository will contain the measured results and supporting reports.

---

# 15. Important Corner Cases

The verification plan specifically targets:

### AXI

* VALID asserted before READY
* READY asserted before VALID
* Independent AW/W arrival
* Delayed write response
* Delayed read response
* Back-to-back requests
* Reset during transaction
* Response backpressure

### APB

* `PREADY` delayed for multiple cycles
* Immediate `PREADY`
* `PSLVERR` asserted
* Back-to-back APB transactions
* Reset during APB transaction

### Bridge

* AXI write followed immediately by read
* Read followed by write
* Independent AW/W timing
* APB peripheral stalls
* APB error response
* AXI response backpressure
* Reset at transaction boundaries
* Reset during active transaction

---

# 16. Verification Deliverables

The completed repository contains:

* Synthesizable RTL
* AXI4-Lite interface definitions
* APB4 interface definitions
* SystemVerilog Assertions
* Formal assumptions
* Formal cover properties
* Formal harness
* JasperGold scripts
* Directed tests
* UVM verification environment
* AXI4-Lite agent
* APB4 agent
* Scoreboard
* Reference model
* Functional coverage
* Simulation scripts
* Regression scripts
* Formal reports
* Simulation results
* Coverage results
* Counterexamples
* Bug reports
* Design documentation

---

# 17. Tools

The project uses the following tools and languages where applicable:

| Tool / Technology  | Purpose                           |
| ------------------ | --------------------------------- |
| SystemVerilog      | RTL and verification              |
| SVA                | Assertion-based verification      |
| UVM                | Simulation-based verification     |
| Cadence Xcelium    | RTL/UVM simulation                |
| Cadence JasperGold | Formal verification               |
| Git                | Version control                   |
| GitHub             | Project repository                |
| Python/Tcl/Shell   | Automation and regression support |

---

# 18. Repository Structure

```text
AXI4lite-APB4-bridge-formal-verification/
│
├── README.md
├── LICENSE
├── .gitignore
├── ENGINEERING_LOGBOOK.md
│
├── docs/
│   ├── architecture.md
│   ├── specification.md
│   ├── verification_plan.md
│   ├── formal_verification_plan.md
│   ├── interface_protocol_notes.md
│   ├── design_decisions.md
│   └── verification_strategy.md
│
├── rtl/
│   ├── axi4lite_if.sv
│   ├── apb4_if.sv
│   └── axi4lite_apb4_bridge.sv
│
├── SVA/
│   ├── axi4lite_protocol_sva.sv
│   ├── apb4_protocol_sva.sv
│   ├── bridge_functional_sva.sv
│   ├── reset_sva.sv
│   └── bridge_bind.sv
│
├── Formal/
│   ├── assumptions/
│   │   └── formal_reset_assumptions.sv
│   ├── covers/
│   │   └── bridge_covers.sv
│   ├── properties/
│   │   └── formal_property_notes.sv
│   ├── reports/
│   │   └── .gitkeep
│   └── scripts/
│       ├── formal_sources.f
│       ├── formal_top.sv
│       ├── rtl.f
│       ├── sva.f
│       └── run_formal.tcl
│
├── tb/
│   ├── interfaces/
│   │   └── tb_interfaces.sv
│   ├── directed/
│   │   └── bridge_smoke_tb.sv
│   ├── reference_model/
│   │   └── apb_reference_model.sv
│   ├── tests/
│   │   └── directed_test_list.md
│   └── files.f
│
├── uvm/
│   ├── axi4lite_agent/
│   │   ├── axi4lite_transaction.sv
│   │   ├── axi4lite_driver.sv
│   │   ├── axi4lite_monitor.sv
│   │   ├── axi4lite_sequencer.sv
│   │   └── axi4lite_agent.sv
│   ├── apb4_agent/
│   │   ├── apb4_transaction.sv
│   │   ├── apb4_driver.sv
│   │   ├── apb4_monitor.sv
│   │   ├── apb4_sequencer.sv
│   │   └── apb4_agent.sv
│   ├── sequences/
│   │   ├── axi_base_sequence.sv
│   │   ├── axi_write_sequence.sv
│   │   └── axi_read_sequence.sv
│   ├── scoreboard/
│   │   └── bridge_scoreboard.sv
│   ├── coverage/
│   │   └── bridge_coverage.sv
│   ├── environment/
│   │   └── bridge_env.sv
│   ├── tests/
│   │   ├── base_test.sv
│   │   ├── write_test.sv
│   │   ├── read_test.sv
│   │   └── reset_test.sv
│   └── uvm_pkg.sv
│
├── scripts/
│   ├── xcelium/
│   │   ├── compile.f
│   │   └── run_directed.sh
│   ├── jaspergold/
│   │   └── run_formal.tcl
│   └── regression/
│       ├── regression_list.txt
│       └── run_all.sh
│
├── results/
│   ├── simulation/
│   ├── formal/
│   ├── coverage/
│   └── waveforms/
│
└── bugs/
    ├── README.md
    └── documented_bugs/
```

---

# 19. Bugs and Debugging

Actual design and verification defects discovered during development are documented separately.

Each bug report follows:

```text
Bug ID
Title
Severity
Detection Method
Observed Behavior
Expected Behavior
Counterexample / Waveform
Root Cause
RTL / SVA / Assumption Classification
Fix
Regression Result
Lesson Learned
```

---

# 20. Design Decisions

Important architectural and verification decisions are documented in:

`docs/design_decisions.md`

The rationale behind decisions is recorded so that the repository documents not only what was implemented, but why it was implemented that way.

---

# 21. Limitations

The project explicitly documents limitations involving:

* Supported AXI4-Lite feature subset
* Supported APB4 feature subset
* Transaction concurrency
* Outstanding transaction handling
* Bridge throughput
* Environmental assumptions
* Formal state-space complexity
* Proof convergence
* Unsupported protocol features

Limitations are treated as engineering observations rather than hidden from the verification results.

---

# 22. Final Verification Objective

The ultimate objective of this project is to demonstrate a verification methodology capable of answering:

> **Does the AXI4-Lite to APB4 bridge satisfy its specified protocol and functional requirements for all behaviors allowed by the verification environment?**

The answer is supported through a combination of:

**simulation + assertions + formal proof + coverage + counterexample analysis + regression.**

---

## Author

**Vikas Kumar**

M.E. VLSI — Manipal Academy of Higher Education

Primary Interest: **Formal Verification / Design Verification**
