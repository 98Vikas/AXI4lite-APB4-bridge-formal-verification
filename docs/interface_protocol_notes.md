# AXI4-Lite and APB4 Protocol Notes

## AXI4-Lite

AXI4-Lite uses five independent channels.

### Write

```text
AW — Write Address
W  — Write Data
B  — Write Response
```

### Read

```text
AR — Read Address
R  — Read Data
```

Each channel uses VALID/READY handshaking.

A transfer occurs when:

```text
VALID && READY
```

---

# APB4

APB uses a simpler two-phase transaction model.

```text
SETUP
  ↓
ACCESS
```

### Setup

```text
PSEL    = 1
PENABLE = 0
```

### Access

```text
PSEL    = 1
PENABLE = 1
```

The peripheral can extend the access phase by keeping:

```text
PREADY = 0
```

The transaction completes when:

```text
PREADY = 1
```

---

# Bridge Verification Focus

The bridge must correctly translate:

```text
AXI request
    ↓
APB request
    ↓
APB completion
    ↓
AXI response
```

The most important verification challenge is preserving the transaction semantics while converting between the two protocol models.
