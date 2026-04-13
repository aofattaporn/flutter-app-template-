# Use Cases: Active Plan Screen

> **Screen**: `active_plan_page.dart`
> **BLoC**: `ActivePlanBloc`
> **Status**: COMPLETE
> **Design Spec**: `propmt/plan_active_screen.html`

---

## Screen Purpose

Shows the currently active budget plan with its income, expense items, progress tracking, and overall budget health.

---

## Use Cases Checklist

| # | Use Case | Status |
|---|----------|--------|
| UC-PLAN-ACTIVE-01 | Load Active Plan | ✅ Done |
| UC-PLAN-ACTIVE-02 | Refresh Active Plan | ✅ Done |
| UC-PLAN-ACTIVE-03 | Add Plan Item | ✅ Done |
| UC-PLAN-ACTIVE-04 | Edit Plan Item | ✅ Done |
| UC-PLAN-ACTIVE-05 | Delete Plan Item | ✅ Done |
| UC-PLAN-ACTIVE-06 | Close Active Plan | ✅ Done |
| UC-PLAN-ACTIVE-07 | Navigate to Plan Editor | ✅ Done |
| UC-PLAN-ACTIVE-08 | Create New Plan and Set Active | ✅ Done |

---

## Use Cases

### UC-PLAN-ACTIVE-01: Load Active Plan
| Field        | Description                                                |
|-------------|-------------------------------------------------------------|
| Actor        | User                                                       |
| Precondition | User has at least one plan marked as active                 |
| Trigger      | User taps the Plans tab                                     |
| Main Flow    | 1. BLoC emits `LoadActivePlan` event                        |
|              | 2. Fetch active plan from `PlanRepository.getActivePlan()`  |
|              | 3. Fetch plan items from `PlanRepository.getPlanItems(planId)` |
|              | 4. Fetch actual income from `PlanRepository.getActualIncome(planId)` |
|              | 5. Display plan overview card, income section, plan items list |
| Postcondition| Screen shows active plan with all items and progress        |
| Error        | No active plan → show "No Active Plan" empty state          |
| Error        | Network error → show error message with retry button        |

### UC-PLAN-ACTIVE-02: Refresh Active Plan
| Field        | Description                                                |
|-------------|-------------------------------------------------------------|
| Actor        | User                                                       |
| Trigger      | User pulls to refresh                                       |
| Main Flow    | 1. BLoC emits `RefreshActivePlan` event                     |
|              | 2. Same as UC-PLAN-ACTIVE-01 but without loading indicator  |
| Postcondition| Screen data refreshed silently                              |

### UC-PLAN-ACTIVE-03: Add Plan Item
| Field        | Description                                                |
|-------------|-------------------------------------------------------------|
| Actor        | User                                                       |
| Precondition | Active plan exists                                          |
| Trigger      | User taps "Add Item" button                                 |
| Main Flow    | 1. Navigate to Plan Item Editor (create mode)               |
|              | 2. User fills: name, expected amount, icon                  |
|              | 3. On save → BLoC emits `AddPlanItemRequested`              |
|              | 4. Item saved via `PlanRepository.addPlanItem()`            |
|              | 5. Item appended to current items list in state             |
| Postcondition| New plan item appears in the items list                     |
| Validation   | Name required, amount > 0                                   |

### UC-PLAN-ACTIVE-04: Edit Plan Item
| Field        | Description                                                |
|-------------|-------------------------------------------------------------|
| Actor        | User                                                       |
| Trigger      | User taps on an existing plan item                          |
| Main Flow    | 1. Navigate to Plan Item Editor (edit mode, pre-filled)     |
|              | 2. User modifies fields                                     |
|              | 3. On save → BLoC emits `UpdatePlanItemRequested`           |
|              | 4. Item updated via `PlanRepository.updatePlanItem()`       |
|              | 5. Item replaced in state list                              |
| Postcondition| Plan item updated on screen                                 |

### UC-PLAN-ACTIVE-05: Delete Plan Item
| Field        | Description                                                |
|-------------|-------------------------------------------------------------|
| Actor        | User                                                       |
| Trigger      | User swipe-to-delete or taps delete on item                 |
| Main Flow    | 1. Show confirmation dialog                                 |
|              | 2. On confirm → BLoC emits `DeletePlanItemRequested`        |
|              | 3. Item deleted via `PlanRepository.deletePlanItem()`       |
|              | 4. Item removed from state list                             |
| Postcondition| Plan item removed from screen                               |

### UC-PLAN-ACTIVE-06: Close Active Plan
| Field        | Description                                                |
|-------------|-------------------------------------------------------------|
| Actor        | User                                                       |
| Precondition | Active plan exists                                          |
| Trigger      | User taps "Close Plan" option                               |
| Main Flow    | 1. Show confirmation dialog                                 |
|              | 2. On confirm → BLoC emits `CloseActivePlanRequested`       |
|              | 3. Plan closed via `PlanRepository.closePlan()`             |
|              | 4. State cleared → shows "No Active Plan" empty state       |
| Postcondition| Plan is no longer active, screen shows empty state          |

### UC-PLAN-ACTIVE-07: Navigate to Plan Editor
| Field        | Description                                                |
|-------------|-------------------------------------------------------------|
| Actor        | User                                                       |
| Trigger      | User taps "Edit" on the plan overview card                  |
| Main Flow    | 1. Navigate to Plan Editor (edit mode, pre-filled)          |
|              | 2. On save → BLoC emits `UpdatePlanRequested`               |
|              | 3. Full reload of active plan                               |
| Postcondition| Plan updated, screen refreshed                              |

### UC-PLAN-ACTIVE-08: Create New Plan and Set Active
| Field        | Description                                                |
|-------------|-------------------------------------------------------------|
| Actor        | User                                                       |
| Precondition | No active plan currently                                    |
| Trigger      | User taps "Create Plan" from empty state                    |
| Main Flow    | 1. Navigate to Plan Editor (create mode)                    |
|              | 2. User fills plan details                                   |
|              | 3. BLoC emits `CreatePlanRequested`                          |
|              | 4. Plan created + set as active via repo                     |
|              | 5. Full reload                                               |
| Postcondition| New active plan displayed                                    |

---

## Business Rules

| Rule ID          | Rule                                                         |
|-----------------|---------------------------------------------------------------|
| BR-PLAN-ACT-01  | Only one plan can be active at a time                         |
| BR-PLAN-ACT-02  | Plan item progress = actualAmount / expectedAmount × 100%     |
| BR-PLAN-ACT-03  | Status: `onTrack` (< 85%), `nearLimit` (≥ 85%), `overBudget` (> 100%) |
| BR-PLAN-ACT-04  | Total planned = sum of all plan item expected amounts          |
| BR-PLAN-ACT-05  | Remaining budget = expected income − total planned             |
| BR-PLAN-ACT-06  | Plan has `isInProgress` if today is between startDate and endDate |
| BR-PLAN-ACT-07  | `actualAmount` currently always returns 0 (TODO: needs transactions) |

---

## Dependencies

- `PlanRepository` (getActivePlan, getPlanItems, getActualIncome, addPlanItem, updatePlanItem, deletePlanItem, closePlan)
- Navigation to: Plan Editor, Plan Item Editor
