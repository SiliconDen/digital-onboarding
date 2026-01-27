# Digital Implementation Qualification — Submission

This qualification consists of **two required implementation phases**:

1. Physical implementation using the **provided golden FSM**
2. Physical implementation using **your own FSM**

---

## Metrics Requirements

Both implementations must meet the following requirements.

### Violation Checks (Must Be Zero)

| Metric | Required |
|--------|----------|
| `route_opt__drc__viol__tot` | `= 0` |
| `route_opt__timing__tnhs__tot` | `= 0` |
| `route_opt__timing__ntv__tot` | `= 0` |
| `route_opt__timing__nhve__tot` | `= 0` |

> Non-zero values indicate physical or timing violations and are not acceptable for tapeout qualification.

### Timing Quality (Must Be Non-Negative)

| Metric | Required |
|--------|----------|
| `route_opt__timing__whs__worst` | `≥ 0` |

> Negative values indicate failing setup timing.

### Area and Physical Quality (Tolerance-Based)

| Metric | Reference |
|--------|-----------|
| `route_opt__area__cell__tot` | *TBD* |
| `route_opt__area__core__tot` | *TBD* |
| `route_opt__area__util__avg` | *TBD* |
| `route_opt__area__wirelength__tot` | *TBD* |

> Exact tolerance values will be specified separately.

---

## Phase 1 — Golden FSM

### Constraints

| Parameter | Value |
|-----------|-------|
| CLK_PER   |       |
| UTIL      |       |
| MAXLYR    |       |
| MAXTRANS  |       |
| CLKUNCERT |       |

### Results

| Metric | Value |
|--------|-------|
| `route_opt__drc__viol__tot` |  |
| `route_opt__timing__tnhs__tot` |  |
| `route_opt__timing__ntv__tot` |  |
| `route_opt__timing__nhve__tot` |  |
| `route_opt__timing__whs__worst` |  |
| `route_opt__area__cell__tot` |  |
| `route_opt__area__core__tot` |  |
| `route_opt__area__util__avg` |  |
| `route_opt__area__wirelength__tot` |  |

---

## Phase 2 — Custom FSM

### Constraints

| Parameter | Value |
|-----------|-------|
| CLK_PER   |       |
| UTIL      |       |
| MAXLYR    |       |
| MAXTRANS  |       |
| CLKUNCERT |       |

### Results

| Metric | Value |
|--------|-------|
| `route_opt__drc__viol__tot` |  |
| `route_opt__timing__tnhs__tot` |  |
| `route_opt__timing__ntv__tot` |  |
| `route_opt__timing__nhve__tot` |  |
| `route_opt__timing__whs__worst` |  |
| `route_opt__area__cell__tot` |  |
| `route_opt__area__core__tot` |  |
| `route_opt__area__util__avg` |  |
| `route_opt__area__wirelength__tot` |  |
