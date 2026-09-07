# Verification Strategy

## Verification Pyramid

```text
                 Formal Verification
                       /\
                      /  \
                     /    \
                    /      \
             Assertion-Based
                  Verification
                  /          \
                 /            \
                /              \
          UVM Simulation     Directed Tests
```

The project does not treat these methods as alternatives.

They address different verification questions.

---

## Directed Testing

Used for:

* Basic functionality
* Boundary conditions
* Debugging
* Reproducing failures

---

## UVM

Used for:

* Transaction-level stimulus
* Reusable agents
* Constrained-random testing
* Scoreboarding
* Functional coverage

---

## SVA

Used for:

* Temporal protocol rules
* Safety properties
* Interface behavior
* Control sequencing

---

## Formal

Used for:

* Exhaustive property analysis within the modeled environment
* Corner-case exploration
* Counterexample generation
* Reachability
* Safety verification
* Coverage exploration

---

## Reference Model

The reference model represents expected transaction-level behavior independently of the DUT implementation.

The scoreboard compares expected and observed behavior.

---

## Regression

Every RTL modification must be followed by regression to ensure that previously verified behavior remains correct.
