# Engineering Logbook

This log records major engineering decisions, implementation milestones, verification discoveries and debugging events.

The log is intentionally focused on technically meaningful work rather than daily activity.

---

# Project Start

## Objective

Develop and verify an AXI4-Lite to APB4 bridge using:

* SystemVerilog
* SVA
* UVM
* Cadence Xcelium
* Cadence JasperGold

---

# Architecture

### Key Questions

* How should independent AXI AW and W channels be handled?
* How should read/write arbitration operate?
* How should APB wait states be handled?
* How should AXI backpressure be handled?
* How should reset interact with an active transaction?
* What assumptions are necessary for formal analysis?

---

# Verification

### Initial Verification Questions

* Can every accepted AXI transaction be traced to exactly one APB transaction?
* Can the bridge lose or duplicate transactions?
* Can APB completion occur without a corresponding request?
* Can AXI responses be generated prematurely?
* Are protocol signals stable during required wait periods?
* Can reset create an illegal transaction state?

---

# Formal Analysis

### Initial Formal Questions

* Which properties are safety properties?
* Which scenarios require assumptions?
* Are any assumptions over-constraining the environment?
* Are passing assertions actually exercising the intended scenario?
* Which corner cases are difficult for simulation but easy for formal?
* Which properties produce useful counterexamples?

---

# Debugging Record

Major bugs and verification discoveries are documented under:

`bugs/documented_bugs/`

---

# Lessons Learned

This section is updated as meaningful engineering conclusions emerge.
