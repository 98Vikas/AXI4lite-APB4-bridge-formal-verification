# AXI4-Lite to APB4 Bridge Architecture

## 1. Architecture Overview

The bridge consists of three primary functional regions:

```text
+------------------------------------------------------+
|                AXI4-Lite Interface                   |
|                                                      |
|  AW/W/B channels             AR/R channels           |
+---------------------+----------------+---------------+
                      |                |
                      v                v
               +-----------------------------+
               | Transaction Control /       |
               | AXI Request Handling        |
               +--------------+--------------+
                              |
                              v
               +-----------------------------+
               | APB Transaction Controller  |
               +--------------+--------------+
                              |
                              v
               +-----------------------------+
               |          APB4 Master        |
               +-----------------------------+
                              |
                              v
                         APB4 Slave
```

---

# 2. AXI Write Path

The write path handles:

* AW channel
* W channel
* APB write generation
* B channel

The bridge must accommodate the fact that AXI4-Lite write address and write data are transmitted through independent channels.

Therefore, the architecture must correctly handle cases where:

```text
AW arrives first
```

or

```text
W arrives first
```

before forming the complete write transaction.

---

# 3. AXI Read Path

The read path handles:

* AR channel
* APB read generation
* R channel

The read address is captured after the required AXI handshake.

The bridge then generates the corresponding APB read transaction.

---

# 4. Transaction Control

The transaction-control logic determines:

* Which AXI transaction is accepted
* When an AXI request is considered complete
* When APB processing begins
* When APB processing completes
* When AXI response generation begins
* When the bridge returns to idle

---

# 5. APB Controller

The APB controller generates the APB transaction sequence.

Conceptually:

```text
             +------+
             | IDLE |
             +--+---+
                |
                v
           +---------+
           |  SETUP  |
           +----+----+
                |
                v
           +---------+
           |  ACCESS |
           +----+----+
                |
          PREADY = 1
                |
                v
           +---------+
           | COMPLETE|
           +----+----+
                |
                v
             +------+
             | IDLE |
             +------+
```

---

# 6. APB Setup Phase

The controller drives:

```text
PSEL    = 1
PENABLE = 0
```

The address and transaction control information are established.

---

# 7. APB Access Phase

The controller drives:

```text
PSEL    = 1
PENABLE = 1
```

The bridge waits for the APB slave to assert `PREADY`.

---

# 8. Completion

When the APB slave indicates completion:

* Read data is captured for read transactions.
* `PSLVERR` is captured.
* The APB transaction is terminated.
* The appropriate AXI response is generated.

---

# 9. State Machine

The exact implementation state machine will be defined around the selected arbitration architecture.

The state machine must ensure:

* Mutually exclusive transaction control
* Correct APB sequencing
* Correct AXI response generation
* Reset recovery
* No illegal state transitions

---

# 10. Critical Architectural Risks

The following areas receive particular attention during verification:

### AXI AW/W independence

Address and data may arrive independently.

### APB wait states

The APB slave can delay completion using `PREADY`.

### Response backpressure

The AXI master may delay `BREADY` or `RREADY`.

### Reset

Reset can interact with an active transaction.

### Arbitration

Simultaneous read/write requests require deterministic handling.

### Transaction conservation

Each accepted transaction must correspond to exactly one supported APB transaction and one corresponding AXI response.

---

# 11. Verification Boundaries

Verification is divided into:

```text
AXI Protocol
     |
     v
Bridge Input Handling
     |
     v
Transaction Conversion
     |
     v
APB Protocol
     |
     v
Response Conversion
     |
     v
AXI Response
```

Each boundary receives dedicated assertions and simulation checks.
