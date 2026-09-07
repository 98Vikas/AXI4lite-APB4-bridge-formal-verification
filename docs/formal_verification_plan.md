# Formal Verification Plan

## 1. Objective

The objective of formal verification is to mathematically analyze whether the AXI4-Lite to APB4 bridge satisfies the specified properties for all behaviors allowed by the formal environment.

---

# 2. Formal Methodology

The methodology consists of:

```text
Specification
     ↓
Property Identification
     ↓
SVA Development
     ↓
Environment Modeling
     ↓
Assumption Review
     ↓
Formal Proof
     ↓
Counterexample Analysis
     ↓
Coverage Analysis
     ↓
Refinement
     ↓
Regression
```

---

# 3. Property Classes

## A. Protocol Properties

Verify interface-level protocol requirements.

## B. Functional Properties

Verify transaction conversion and response behavior.

## C. Safety Properties

Verify that illegal states and illegal transactions cannot occur.

## D. Reset Properties

Verify reset initialization and recovery.

## E. Cover Properties

Demonstrate reachability of important legal scenarios.

---

# 4. AXI Properties

The following property classes are planned.

### VALID Stability

When a source asserts VALID and the receiver has not yet asserted READY, required transaction information must remain stable.

### Handshake

A transaction is accepted only on:

```text
VALID && READY
```

### Response Stability

AXI responses must remain available until accepted by the receiving master.

### Channel Integrity

The bridge must not incorrectly associate unrelated channel information.

### Reset

Interface outputs must return to the specified reset state.

---

# 5. APB Properties

### Setup Phase

Verify:

```text
PSEL = 1
PENABLE = 0
```

during setup.

### Access Phase

Verify:

```text
PSEL = 1
PENABLE = 1
```

during access.

### Phase Ordering

An access phase must not occur without the corresponding setup phase.

### Stability

Address and required control information must remain stable during the APB access period.

### Completion

The APB transaction completes only according to the specified `PREADY` behavior.

---

# 6. Bridge Functional Properties

### Write Conservation

Every accepted supported AXI write must correspond to one APB write transaction.

### Read Conservation

Every accepted supported AXI read must correspond to one APB read transaction.

### Address Preservation

The APB address must correspond to the accepted AXI address according to the address mapping specification.

### Write Data Preservation

APB write data must correspond to the accepted AXI write data.

### Read Data Return

APB read data must be returned through the corresponding AXI read response.

### Error Propagation

APB error status must be translated into the defined AXI response.

---

# 7. Safety Properties

The formal environment will investigate properties preventing:

* Simultaneous conflicting internal operations
* Illegal APB phases
* Response generation without a corresponding transaction
* Multiple responses for one transaction
* Transaction loss
* Transaction duplication
* Invalid reset state
* Illegal FSM states

---

# 8. Cover Properties

Cover properties will demonstrate important reachable scenarios.

Examples include:

* AXI write reaching APB access
* AXI read reaching APB access
* APB wait state
* Successful APB completion
* APB error completion
* Delayed AXI response acceptance
* Back-to-back transactions
* Reset followed by successful transaction

---

# 9. Assumption Strategy

Environmental assumptions must describe legal external behavior without unnecessarily restricting the DUT.

The formal environment will distinguish:

```text
DUT Guarantees
        vs.
Environment Assumptions
```

Assumptions will be reviewed for:

* Necessity
* Realism
* Completeness
* Over-constraint risk

---

# 10. Counterexample Analysis

When a property fails:

1. Inspect the formal trace.
2. Identify the first point where expected behavior diverges.
3. Determine whether the failure is caused by:

   * RTL
   * SVA
   * assumption
   * testbench/harness
4. Correct the root cause.
5. Re-run the failing property.
6. Run regression.
7. Record the result.

---

# 11. Vacuity Analysis

Assertions will be reviewed to determine whether a property is passing because:

* The intended scenario is actually exercised, or
* The antecedent is never reachable.

Relevant properties will therefore be complemented with cover properties where appropriate.

---

# 12. Over-Constraint Analysis

The formal environment will be reviewed to determine whether assumptions accidentally eliminate legal behavior.

Particular attention will be paid to:

* READY behavior
* PREADY behavior
* Reset
* Request timing
* Backpressure
* Simultaneous requests

---

# 13. Proof Classification

Each formal property will ultimately be classified as:

* Proven
* Failed
* Inconclusive
* Not applicable

The reason for any unproven property will be documented.

---

# 14. Formal Debugging

A failed assertion is treated as a debugging opportunity.

The expected workflow is:

```text
FAIL
 ↓
Counterexample
 ↓
Trace analysis
 ↓
Root cause
 ↓
Fix
 ↓
Proof
 ↓
Regression
```

---

# 15. Fault Injection

Controlled defects may be introduced into selected RTL versions.

The formal environment should detect faults such as:

* Incorrect handshake logic
* Incorrect APB sequencing
* Incorrect response mapping
* Incorrect reset behavior
* Incorrect transaction completion

This evaluates the effectiveness of the verification environment itself.

---

# 16. Formal Verification Sign-Off

Formal verification is considered complete only after:

* Required safety properties are proven
* Relevant cover scenarios are reached
* Assumptions are reviewed
* Counterexamples are resolved
* Vacuity is investigated where relevant
* Proof limitations are understood
* Known unproven properties are documented
