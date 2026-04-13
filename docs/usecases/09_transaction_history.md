# Use Cases: Transaction History Screen

> **Screen**: NOT YET BUILT (placeholder at `transactions_placeholder_page.dart`)
> **Design Spec**: `propmt/transaction_history_screen.html` (currently duplicate of account_screen)
> **Status**: NOT STARTED

---

## Screen Purpose

Display a chronological list of all transactions with filtering, search, and summary. This is the main transaction browsing screen accessed from the Transactions tab.

---

## Use Cases Checklist

| # | Use Case | Status |
|---|----------|--------|
| UC-TXN-HIST-01 | Load Transaction History | ⬜ Not Started |
| UC-TXN-HIST-02 | Filter by Date Range | ⬜ Not Started |
| UC-TXN-HIST-03 | Filter by Transaction Type | ⬜ Not Started |
| UC-TXN-HIST-04 | Filter by Account | ⬜ Not Started |
| UC-TXN-HIST-05 | View Transaction Detail | ⬜ Not Started |
| UC-TXN-HIST-06 | Delete Transaction from History | ⬜ Not Started |

---

## Use Cases

### UC-TXN-HIST-01: Load Transaction History
| Field        | Description                                                |
|-------------|-------------------------------------------------------------|
| Actor        | User                                                       |
| Trigger      | User taps the Transactions tab                              |
| Main Flow    | 1. Fetch transactions for current month (default)            |
|              | 2. Group by date                                             |
|              | 3. Show monthly summary (total income, total expense, net)   |
|              | 4. Display grouped list                                      |
| Postcondition| Transactions displayed grouped by date                       |
| Error        | Empty → show "No transactions yet" empty state               |

### UC-TXN-HIST-02: Filter by Date Range
| Field        | Description                                                |
|-------------|-------------------------------------------------------------|
| Actor        | User                                                       |
| Trigger      | User selects month/year or custom date range                |
| Main Flow    | 1. User picks date range                                     |
|              | 2. Re-fetch transactions within range                        |
|              | 3. Update summary and list                                   |
| Postcondition| Only transactions within date range are shown                |

### UC-TXN-HIST-03: Filter by Transaction Type
| Field        | Description                                                |
|-------------|-------------------------------------------------------------|
| Actor        | User                                                       |
| Trigger      | User taps filter (All / Expense / Income / Transfer)        |
| Main Flow    | 1. Apply type filter to current list                         |
|              | 2. Update summary accordingly                                |
| Postcondition| Only matching transactions shown                             |

### UC-TXN-HIST-04: Filter by Account
| Field        | Description                                                |
|-------------|-------------------------------------------------------------|
| Actor        | User                                                       |
| Trigger      | User selects specific account filter                        |
| Main Flow    | 1. Filter transactions by accountId                          |
|              | 2. Update list and summary                                   |
| Postcondition| Only transactions for selected account shown                 |

### UC-TXN-HIST-05: View Transaction Detail
| Field        | Description                                                |
|-------------|-------------------------------------------------------------|
| Actor        | User                                                       |
| Trigger      | User taps on a transaction in the list                      |
| Main Flow    | 1. Navigate to Transaction Editor in view/edit mode          |
|              | 2. Show full transaction details                             |
| Postcondition| Transaction detail displayed                                 |

### UC-TXN-HIST-06: Delete Transaction from History
| Field        | Description                                                |
|-------------|-------------------------------------------------------------|
| Actor        | User                                                       |
| Trigger      | User swipe-to-delete on a transaction                       |
| Main Flow    | 1. Show confirmation                                         |
|              | 2. Reverse balance impact                                    |
|              | 3. Delete from database                                      |
|              | 4. Remove from list, update summary                          |
| Postcondition| Transaction removed, balances corrected                       |

---

## Business Rules

| Rule ID          | Rule                                                         |
|-----------------|---------------------------------------------------------------|
| BR-TXN-HIST-01  | Default view: current month's transactions                   |
| BR-TXN-HIST-02  | Transactions grouped by date (newest first)                  |
| BR-TXN-HIST-03  | Monthly summary: total income, total expense, net (income − expense) |
| BR-TXN-HIST-04  | Each entry shows: type icon, description, amount, account name, date |
| BR-TXN-HIST-05  | Expense amounts shown in red, income in green, transfer in blue |
| BR-TXN-HIST-06  | Pagination or infinite scroll for large datasets              |

---

## Dependencies (To Build)

- `TransactionRepository` — query with filters
- `TransactionBloc` — state management for list + filters
- Navigation to: Transaction Editor
