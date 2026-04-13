# Use Cases: Plan Item Editor Screen

> **Screen**: `plan_item_editor_page.dart`
> **State**: StatefulWidget (form)
> **Status**: COMPLETE (missing account linking)
> **Design Spec**: `propmt/planItem_editor_screen.html`

---

## Screen Purpose

Create or edit a budget plan item (expense category) within a plan. Allows setting name, expected amount, and icon.

---

## Use Cases Checklist

| # | Use Case | Status |
|---|----------|--------|
| UC-PLANITEM-01 | Create New Plan Item | ✅ Done |
| UC-PLANITEM-02 | Edit Existing Plan Item | ✅ Done |
| UC-PLANITEM-03 | Select Icon / Link Account | 🔶 Partial (icon done, account linking missing) |

---

## Use Cases

### UC-PLANITEM-01: Create New Plan Item
| Field        | Description                                                |
|-------------|-------------------------------------------------------------|
| Actor        | User                                                       |
| Precondition | An active plan exists                                       |
| Trigger      | User taps "Add Item" on Active Plan page                    |
| Main Flow    | 1. Show empty form with icon grid                           |
|              | 2. User selects icon from grid                               |
|              | 3. User enters: item name, expected amount                   |
|              | 4. User taps "Save"                                          |
|              | 5. Validate inputs                                           |
|              | 6. Return new PlanItem to calling page                       |
| Postcondition| New plan item created                                        |
| Validation   | Name required; expected amount > 0                           |

### UC-PLANITEM-02: Edit Existing Plan Item
| Field        | Description                                                |
|-------------|-------------------------------------------------------------|
| Actor        | User                                                       |
| Precondition | Plan item exists                                            |
| Trigger      | User taps on an existing plan item                          |
| Main Flow    | 1. Show form pre-filled with existing item data              |
|              | 2. User modifies fields (name, amount, icon)                 |
|              | 3. User taps "Save"                                          |
|              | 4. Validate inputs                                           |
|              | 5. Return updated PlanItem to calling page                   |
| Postcondition| Plan item updated                                            |

### UC-PLANITEM-03: Select Icon (NOT YET: Link Account)
| Field        | Description                                                |
|-------------|-------------------------------------------------------------|
| Actor        | User                                                       |
| Trigger      | User views icon selection grid                               |
| Main Flow    | 1. Display predefined icon grid                              |
|              | 2. User taps an icon                                         |
|              | 3. Icon is highlighted as selected                           |
| Postcondition| Icon stored with the plan item                               |
| Note         | Design spec also shows account linking — NOT YET BUILT       |

---

## Business Rules

| Rule ID           | Rule                                                        |
|------------------|--------------------------------------------------------------|
| BR-PLANITEM-01   | Item name is required                                        |
| BR-PLANITEM-02   | Expected amount must be > 0                                  |
| BR-PLANITEM-03   | Icon is optional (defaults to a generic icon)                |
| BR-PLANITEM-04   | Account linking not yet implemented (design spec feature)    |
| BR-PLANITEM-05   | Plan item type selector exists in design (expense/income) — partially implemented |

---

## Dependencies

- Called from: Active Plan page, Plan Detail page
- Returns: `PlanItem` entity to parent
