# Bug Database

This directory contains documented design and verification bugs discovered during development.

Each bug is documented independently.

## Bug Classification

### RTL Bug

Incorrect implementation of the intended behavior.

### SVA Bug

Incorrect or incomplete assertion.

### Assumption Bug

Incorrect environmental constraint.

### Verification Environment Bug

Incorrect scoreboard, monitor, driver, reference model or testbench behavior.

---

# Bug Report Format

Each bug report contains:

## Bug ID

Unique identifier.

## Title

Short description of the defect.

## Severity

Impact classification.

## Detection Method

Examples:

* Directed simulation
* UVM regression
* Assertion
* Formal proof
* Formal cover analysis

## Observed Behavior

What actually happened.

## Expected Behavior

What should have happened.

## Failure Evidence

Waveform or formal counterexample.

## Root Cause

Technical reason for the failure.

## Fix

Implementation or verification correction.

## Regression

Tests/properties executed after the fix.

## Lesson Learned

Engineering conclusion from the failure.
