# Use Cases: Plan List Screen

> **Screen**: `plan_list_page.dart`
> **BLoC**: `PlanListBloc`
> **Status**: COMPLETE (missing filter tabs)
> **Design Spec**: `propmt/plan_list_screen.html`

---

## Screen Purpose

Display all budget plans (active, closed, draft) with ability to manage them — create new plans, set active, delete, or view details.

---

## Use Cases Checklist

| # | Use Case | Status |
|---|----------|--------|
| UC-PLAN-LIST-01 | Load All Plans | ✅ Done |
| UC-PLAN-LIST-02 | Refresh Plans | ✅ Done |
| UC-PLAN-LIST-03 | Create New Plan | ✅ Done |
| UC-PLAN-LIST-04 | Set Plan as Active | ✅ Done |
| UC-PLAN-LIST-05 | Delete Plan | ✅ Done |
| UC-PLAN-LIST-06 | View Plan Detail | ✅ Done |
| UC-PLAN-LIST-07 | Filter Plans | ⬜ Not Started |

---

## Use Cases

### UC-PLAN-LIST-01: Load All Plans
| Field        | Description                                                |
|-------------|-------------------------------------------------------------|
| Actor        | User                                                       |
| Trigger      | User navigates to Plan List from Active Plan page           |
| Main Flow    | 1. BLoC emits `LoadAllPlans` event                          |
|              | 2. Fetch all plans from `PlanRepository.getAllPlans()`       |
|              | 3. Sort: active plans first, then by startDate descending   |
|              | 4. Display as card list                                      |
| Postcondition| All plans displayed in sorted order                          |
| Error        | Empty list → show "No plans yet" empty state                 |

### UC-PLAN-LIST-02: Refresh Plans
| Field        | Description                                                |
|-------------|-------------------------------------------------------------|
| Actor        | User                                                       |
| Trigger      | User pulls to refresh                                       |
| Main Flow    | Same as UC-PLAN-LIST-01 without loading indicator            |
| Postcondition| List refreshed silently                                      |

### UC-PLAN-LIST-03: Create New Plan
| Field        | Description                                                |
|-------------|-------------------------------------------------------------|
| Actor        | User                                                       |
| Trigger      | User taps "Add Plan" / FAB button                           |
| Main Flow    | 1. Navigate to Plan Editor (create mode)                    |
|              | 2. User fills: name, start date, end date, expected income  |
|              | 3. On save → BLoC emits `CreatePlanFromListRequested`       |
|              | 4. Plan created via `PlanRepository.createPlan()`           |
|              | 5. New plan added to list                                    |
| Postcondition| New plan appears in the list                                 |
| Validation   | Name required; start date ≤ end date                         |

### UC-PLAN-LIST-04: Set Plan as Active
| Field        | Description                                                |
|-------------|-------------------------------------------------------------|
| Actor        | User                                                       |
| Precondition | Plan exists and is not currently active                      |
| Trigger      | User taps "Set Active" on a plan card                       |
| Main Flow    | 1. BLoC emits `SetActivePlanRequested`                       |
|              | 2. Previous active plan deactivated                          |
|              | 3. Selected plan set active via `PlanRepository.setActivePlan()` |
|              | 4. All plans updated in state (isActive flags refreshed)     |
| Postcondition| Selected plan is now active, previous one deactivated        |

### UC-PLAN-LIST-05: Delete Plan
| Field        | Description                                                |
|-------------|-------------------------------------------------------------|
| Actor        | User                                                       |
| Trigger      | User taps "Delete" on a plan card                           |
| Main Flow    | 1. Show confirmation dialog                                 |
|              | 2. On confirm → BLoC emits `DeletePlanRequested`            |
|              | 3. Plan deleted via `PlanRepository.deletePlan()`           |
|              | 4. Plan removed from list in state                          |
| Postcondition| Plan removed from list                                       |
| Error        | Cannot delete active plan (should deactivate first)          |

### UC-PLAN-LIST-06: View Plan Detail
| Field        | Description                                                |
|-------------|-------------------------------------------------------------|
| Actor        | User                                                       |
| Trigger      | User taps on a plan card                                    |
| Main Flow    | 1. Navigate to Plan Detail page with planId                  |
|              | 2. Display plan details + items                              |
| Postcondition| Plan detail screen shown                                     |

### UC-PLAN-LIST-07: Filter Plans (NOT YET BUILT)
| Field        | Description                                                |
|-------------|-------------------------------------------------------------|
| Actor        | User                                                       |
| Trigger      | User taps filter tab (All / Active / Closed)                |
| Main Flow    | 1. Filter displayed plans by status                          |
|              | 2. Update list accordingly                                   |
| Postcondition| Only plans matching filter are shown                         |
| Note         | Design spec shows tabs but NOT implemented yet               |

---

## Business Rules

| Rule ID          | Rule                                                         |
|-----------------|---------------------------------------------------------------|
| BR-PLAN-LIST-01 | Plans sorted: active first, then by startDate descending      |
| BR-PLAN-LIST-02 | Only one plan can be active at any time                       |
| BR-PLAN-LIST-03 | Setting a new active plan automatically deactivates the current one |
| BR-PLAN-LIST-04 | Each plan card shows: name, period, isActive badge, item count |

---

## Dependencies

- `PlanRepository` (getAllPlans, createPlan, deletePlan, setActivePlan)
- Navigation to: Plan Editor, Plan Detail
