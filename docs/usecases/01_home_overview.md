# Use Cases: Home Overview Screen

> **Screen**: `home_overview_page.dart`
> **BLoC**: `HomeBloc`
> **Status**: PARTIAL (~60% — pending transactions feature)
> **Design Spec**: `propmt/home_overview_screen.html`

---

## Screen Purpose

The Home Overview screen serves as the app's landing dashboard, showing a quick summary of the user's financial status and providing quick actions.

---

## Use Cases Checklist

| # | Use Case | Status |
|---|----------|--------|
| UC-HOME-01 | View Financial Summary | ✅ Done |
| UC-HOME-02 | Quick Create Transaction | ⬜ Blocked (needs transactions feature) |
| UC-HOME-03 | View Recent Transactions | ⬜ Blocked (needs transactions feature) |

---

## Use Cases

### UC-HOME-01: View Financial Summary
| Field        | Description                                                |
|-------------|-------------------------------------------------------------|
| Actor        | User                                                       |
| Precondition | User is logged in and has at least one account              |
| Trigger      | User opens the app or taps the Home tab                    |
| Main Flow    | 1. System loads active plan summary (total budget, spent, remaining) |
|              | 2. System loads total balance across all accounts           |
|              | 3. System loads recent transactions (last 5)                |
|              | 4. Display summary cards on screen                          |
| Postcondition| User sees their financial overview                          |
| Error        | If no active plan → show "No active plan" prompt            |
| Error        | If no accounts → show "Create your first account" prompt    |

### UC-HOME-02: Quick Create Transaction
| Field        | Description                                                |
|-------------|-------------------------------------------------------------|
| Actor        | User                                                       |
| Precondition | User has at least one account                               |
| Trigger      | User taps the FAB (+) button on home screen                 |
| Main Flow    | 1. Navigate to Transaction Editor screen                    |
|              | 2. User fills transaction details                           |
|              | 3. Transaction is saved                                     |
|              | 4. Return to home with updated summary                      |
| Postcondition| Transaction created, balances updated                       |

### UC-HOME-03: View Recent Transactions
| Field        | Description                                                |
|-------------|-------------------------------------------------------------|
| Actor        | User                                                       |
| Precondition | User has created at least one transaction                   |
| Trigger      | Home screen loads or user pulls to refresh                  |
| Main Flow    | 1. System fetches last 5 transactions                       |
|              | 2. Display as list with amount, category, date, account     |
|              | 3. User taps "View All" → navigate to Transaction History   |
| Postcondition| User sees recent transaction list                           |

---

## Business Rules

| Rule ID     | Rule                                                        |
|-------------|-------------------------------------------------------------|
| BR-HOME-01  | Summary shows data from active plan only                    |
| BR-HOME-02  | Total balance = sum of all account balances                 |
| BR-HOME-03  | "Remaining budget" = expected income − total actual spending |
| BR-HOME-04  | Recent transactions sorted by date descending               |

---

## Dependencies

- Account repository (for total balance)
- Plan repository (for active plan summary)
- Transaction repository (NOT YET BUILT)
