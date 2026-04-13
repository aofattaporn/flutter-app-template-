# Use Cases: Plan Editor Screen

> **Screen**: `plan_editor_page.dart`
> **State**: Direct repository call (no BLoC)
> **Status**: COMPLETE
> **Design Spec**: `propmt/plan_editor_screen.html` (duplicate of plan_list)

---

## Screen Purpose

Create or edit a budget plan. Used from both Active Plan page and Plan List page.

---

## Use Cases Checklist

| # | Use Case | Status |
|---|----------|--------|
| UC-PLAN-EDIT-01 | Create New Plan | ✅ Done |
| UC-PLAN-EDIT-02 | Edit Existing Plan | ✅ Done |

---

## Use Cases

### UC-PLAN-EDIT-01: Create New Plan
| Field        | Description                                                |
|-------------|-------------------------------------------------------------|
| Actor        | User                                                       |
| Trigger      | User taps "Create Plan" from Active Plan or Plan List       |
| Main Flow    | 1. Show empty form                                          |
|              | 2. User enters: plan name, start date, end date, expected income |
|              | 3. User taps "Save"                                         |
|              | 4. Validate inputs                                           |
|              | 5. Call `PlanRepository.createPlan(plan)`                    |
|              | 6. Return result to calling page                             |
| Postcondition| New plan created in database                                 |
| Validation   | Name is required; start date ≤ end date                      |

### UC-PLAN-EDIT-02: Edit Existing Plan
| Field        | Description                                                |
|-------------|-------------------------------------------------------------|
| Actor        | User                                                       |
| Precondition | Plan exists                                                 |
| Trigger      | User taps "Edit" on plan overview card or plan detail        |
| Main Flow    | 1. Show form pre-filled with existing plan data              |
|              | 2. User modifies fields                                      |
|              | 3. User taps "Save"                                          |
|              | 4. Validate inputs                                           |
|              | 5. Call `PlanRepository.updatePlan(plan)`                    |
|              | 6. Return updated plan to calling page                       |
| Postcondition| Plan updated in database                                     |

---

## Business Rules

| Rule ID          | Rule                                                         |
|-----------------|---------------------------------------------------------------|
| BR-PLAN-EDIT-01 | Plan name is required and cannot be empty                     |
| BR-PLAN-EDIT-02 | Start date must be ≤ end date                                 |
| BR-PLAN-EDIT-03 | Expected income is optional, defaults to 0                    |
| BR-PLAN-EDIT-04 | Editing does not change the plan's active status              |

---

## Dependencies

- `PlanRepository` (createPlan, updatePlan)
