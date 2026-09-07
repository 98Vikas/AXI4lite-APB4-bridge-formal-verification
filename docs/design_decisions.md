# Design Decisions

## 1. Formal-First Verification

Formal verification is treated as a primary verification methodology rather than an additional test at the end of simulation.

**Reason:** Protocol and safety properties are naturally expressed as temporal assertions and can be analyzed across a broad state space.

---

## 2. Simulation as a Complement

Simulation is retained alongside formal verification.

**Reason:** Simulation provides waveform-level debugging, constrained-random testing, scoreboarding and functional coverage.

---

## 3. Explicit Specification

The design specification is maintained separately from the RTL.

**Reason:** Verification properties should represent intended behavior rather than simply restating implementation details.

---

## 4. Separate Protocol and Functional Properties

AXI, APB and bridge-level properties are maintained separately.

**Reason:** This improves debug localization when a property fails.

---

## 5. Explicit Assumption Documentation

Formal assumptions are documented separately from assertions.

**Reason:** Assumptions define the legal environment and must not be confused with DUT guarantees.

---

## 6. Counterexample-Driven Debugging

Formal failures are analyzed using their counterexample traces.

**Reason:** A counterexample provides a concrete sequence demonstrating how the property can fail.

---

## 7. Fault Injection

Selected controlled defects may be introduced.

**Reason:** A verification environment should demonstrate that it can detect realistic implementation errors rather than only pass a correct RTL implementation.

---

## 8. Evidence-Based Results

Verification results are derived from actual tool output and regression data.

**Reason:** Reproducible evidence is more valuable than unsupported claims.
