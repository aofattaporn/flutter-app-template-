# Use Cases: Transaction Editor Screen

> **Screen**: NOT YET BUILT (placeholder at `transactions_placeholder_page.dart`)
> **Design Spec**: `propmt/home_overview_screen.html`
> **Status**: NOT STARTED

---

## Screen Purpose

Create or edit a financial transaction (expense, income, or transfer between accounts). This is the core feature that links accounts to plan items and tracks actual spending.

---

## Use Cases Checklist

| # | Use Case | Status |
|---|----------|--------|
| UC-TXN-EDIT-01 | Create Expense Transaction | ⬜ Not Started |
| UC-TXN-EDIT-02 | Create Income Transaction | ⬜ Not Started |
| UC-TXN-EDIT-03 | Create Transfer Transaction | ⬜ Not Started |
| UC-TXN-EDIT-04 | Edit Existing Transaction | ⬜ Not Started |
| UC-TXN-EDIT-05 | Delete Transaction | ⬜ Not Started |

---

## Use Cases

### UC-TXN-EDIT-01: Create Expense Transaction
| Field        | Description                                                |
|-------------|-------------------------------------------------------------|
| Actor        | User                                                       |
| Precondition | At least one account exists                                 |
| Trigger      | User taps FAB (+) or "Add Transaction"                      |
| Main Flow    | 1. Show transaction form with type = "Expense" selected      |
|              | 2. User enters amount                                        |
|              | 3. User selects source account (from which money is spent)   |
|              | 4. User optionally selects a plan item (budget category)     |
|              | 5. User sets date/time (defaults to now)                     |
|              | 6. User enters description/note (optional)                   |
|              | 7. User taps "Save"                                          |
|              | 8. Deduct amount from source account balance                 |
|              | 9. If plan item selected → add to plan item's actualAmount   |
|              | 10. Save transaction to database                             |
| Postcondition| Transaction saved, account balance updated, plan item actual updated |
| Validation   | Amount > 0; account is required                              |

### UC-TXN-EDIT-02: Create Income Transaction
| Field        | Description                                                |
|-------------|-------------------------------------------------------------|
| Actor        | User                                                       |
| Precondition | At least one account exists                                 |
| Trigger      | User selects "Income" type on transaction form               |
| Main Flow    | 1. User enters amount                                        |
|              | 2. User selects destination account (receiving money)        |
|              | 3. User sets date/time                                       |
|              | 4. User enters description (optional)                        |
|              | 5. User taps "Save"                                          |
|              | 6. Add amount to destination account balance                 |
|              | 7. Add to plan's actual income (if active plan exists)       |
|              | 8. Save transaction to database                              |
| Postcondition| Transaction saved, account balance increased, actual income updated |

### UC-TXN-EDIT-03: Create Transfer Transaction
| Field        | Description                                                |
|-------------|-------------------------------------------------------------|
| Actor        | User                                                       |
| Precondition | At least two accounts exist                                 |
| Trigger      | User selects "Transfer" type on transaction form             |
| Main Flow    | 1. User enters amount                                        |
|              | 2. User selects source account (from)                        |
|              | 3. User selects destination account (to)                     |
|              | 4. User sets date/time                                       |
|              | 5. User taps "Save"                                          |
|              | 6. Deduct from source, add to destination                    |
|              | 7. Save transaction to database                              |
| Postcondition| Both account balances updated, transfer recorded              |
| Validation   | Source ≠ destination; amount > 0                              |

### UC-TXN-EDIT-04: Edit Existing Transaction
| Field        | Description                                                |
|-------------|-------------------------------------------------------------|
| Actor        | User                                                       |
| Precondition | Transaction exists                                          |
| Trigger      | User taps on transaction from history                       |
| Main Flow    | 1. Show form pre-filled with transaction data                |
|              | 2. Reverse the original balance impact                       |
|              | 3. User modifies fields                                      |
|              | 4. Apply new balance impact                                  |
|              | 5. Save updated transaction                                  |
| Postcondition| Transaction updated, balances corrected                       |

### UC-TXN-EDIT-05: Delete Transaction
| Field        | Description                                                |
|-------------|-------------------------------------------------------------|
| Actor        | User                                                       |
| Trigger      | User taps delete on transaction                              |
| Main Flow    | 1. Show confirmation dialog                                  |
|              | 2. Reverse the balance impact                                |
|              | 3. Delete transaction from database                          |
| Postcondition| Transaction removed, balances restored                        |

---

## Business Rules

| Rule ID         | Rule                                                          |
|----------------|----------------------------------------------------------------|
| BR-TXN-EDIT-01 | Transaction types: Expense, Income, Transfer                   |
| BR-TXN-EDIT-02 | Expense: deducts from account, adds to plan item actual        |
| BR-TXN-EDIT-03 | Income: adds to account, adds to plan actual income            |
| BR-TXN-EDIT-04 | Transfer: deducts from source, adds to destination (no plan impact) |
| BR-TXN-EDIT-05 | Amount must be > 0                                             |
| BR-TXN-EDIT-06 | Date defaults to current date/time                             |
| BR-TXN-EDIT-07 | Plan item linking is optional for expenses                     |
| BR-TXN-EDIT-08 | Currency is always Thai Baht (฿)                               |
| BR-TXN-EDIT-09 | Editing/deleting must reverse original balance impact first     |

---

## Required Entities (To Build)

```dart
class Transaction {
  final String id;
  final TransactionType type;  // expense, income, transfer
  final double amount;
  final String accountId;       // source account
  final String? toAccountId;    // destination (transfer only)
  final String? planItemId;     // linked budget category (expense only)
  final String? planId;         // linked plan
  final DateTime transactionDate;
  final String? description;
  final DateTime? createdAt;
  final DateTime? updatedAt;
}
```

---

## Dependencies (To Build)

- `TransactionRepository` — CRUD operations
- `TransactionDataSource` — Supabase table `transactions`
- `TransactionBloc` — state management
- `AccountRepository` — balance updates
- `PlanRepository` — actual amount updates
