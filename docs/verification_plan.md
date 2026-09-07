# Verification Plan

## 1. Objective

The verification plan defines how the AXI4-Lite to APB4 bridge will be verified using simulation and formal verification.

---

# 2. Verification Levels

Verification is divided into:

1. Interface protocol verification
2. Block-level functional verification
3. Transaction-level verification
4. Corner-case verification
5. Assertion-based verification
6. Formal verification
7. Fault-injection testing
8. Regression

---

# 3. Directed Tests

## AXI Write

* Single write
* Multiple writes
* AW before W
* W before AW
* Simultaneous AW/W
* Delayed AW
* Delayed W
* Delayed BREADY

## AXI Read

* Single read
* Multiple reads
* Delayed RREADY
* Back-to-back reads

## APB

* Immediate PREADY
* Delayed PREADY
* PSLVERR asserted
* Multiple wait states

## Reset

* Reset while idle
* Reset during AXI request
* Reset during APB setup
* Reset during APB access
* Reset during AXI response

---

# 4. Negative Testing

The verification environment will investigate behavior associated with:

* Illegal handshake assumptions
* Invalid protocol sequences
* Unexpected APB responses
* Reset interactions
* Unsupported transaction combinations

Negative tests will distinguish between:

* DUT errors
* protocol violations
* environment violations

---

# 5. Scoreboard

The scoreboard compares:

```text
AXI Transaction
      |
      v
Reference Model
      |
      v
Expected APB / AXI Behavior
      |
      v
Observed DUT Behavior
```

The scoreboard checks:

* Address
* Write data
* Read data
* Direction
* Byte strobes
* Response
* Transaction ordering

---

# 6. Functional Coverage

Coverage points include:

### AXI

* Read/write transaction
* AW/W ordering
* VALID/READY timing relationships
* Response backpressure

### APB

* Read/write
* Wait-state count
* PREADY timing
* PSLVERR

### Bridge

* Read conversion
* Write conversion
* Back-to-back transactions
* Reset interaction

Cross coverage will be used where it provides meaningful verification value.

---

# 7. Regression

The regression environment executes:

* Directed tests
* Randomized tests
* Corner-case tests
* Fault-injection tests where applicable

Every RTL correction must be followed by regression.

---

# 8. Sign-Off Criteria

Verification sign-off requires:

* Required protocol assertions proven
* Functional assertions proven
* Relevant cover properties reached
* Directed tests passing
* Regression passing
* Coverage reviewed
* Counterexamples resolved
* Known limitations documented
* No unexplained failures

The exact numerical targets are defined after the final verification environment is implemented.
