# Use Cases: Account List Screen

> **Screen**: `account_screen.dart`
> **BLoC**: `AccountBloc`
> **Status**: COMPLETE
> **Design Spec**: `propmt/account_screen.html`

---

## Screen Purpose

Display all user accounts (bank, cash, credit card, etc.) with their balances and a total balance summary.

---

## Use Cases Checklist

| # | Use Case | Status |
|---|----------|--------|
| UC-ACC-LIST-01 | Load All Accounts | ✅ Done |
| UC-ACC-LIST-02 | Refresh Accounts | ✅ Done |
| UC-ACC-LIST-03 | Navigate to Create Account | ✅ Done |
| UC-ACC-LIST-04 | Navigate to Edit Account | ✅ Done |
| UC-ACC-LIST-05 | Delete Account | ✅ Done |

---

## Use Cases

### UC-ACC-LIST-01: Load All Accounts
| Field        | Description                                                |
|-------------|-------------------------------------------------------------|
| Actor        | User                                                       |
| Trigger      | User taps the Accounts tab                                  |
| Main Flow    | 1. BLoC emits `FetchAccountsRequested` event                 |
|              | 2. Fetch all accounts from `AccountRepository.getAccounts()` |
|              | 3. Compute total balance = sum of all account balances        |
|              | 4. Display total balance card + account cards                 |
| Postcondition| All accounts listed with total balance                        |
| Error        | Empty → show "No accounts yet" empty state                    |

### UC-ACC-LIST-02: Refresh Accounts
| Field        | Description                                                |
|-------------|-------------------------------------------------------------|
| Actor        | User                                                       |
| Trigger      | User pulls to refresh                                       |
| Main Flow    | 1. BLoC emits `RefreshAccountsRequested`                     |
|              | 2. Re-fetch all accounts without loading indicator            |
| Postcondition| Account list refreshed silently                               |

### UC-ACC-LIST-03: Navigate to Create Account
| Field        | Description                                                |
|-------------|-------------------------------------------------------------|
| Actor        | User                                                       |
| Trigger      | User taps "Add Account" / FAB                               |
| Main Flow    | 1. Navigate to Account Create Screen (create mode)           |
|              | 2. On save → BLoC emits `CreateAccountRequested`             |
|              | 3. Re-fetch all accounts                                     |
| Postcondition| New account appears in list, total updated                    |

### UC-ACC-LIST-04: Navigate to Edit Account
| Field        | Description                                                |
|-------------|-------------------------------------------------------------|
| Actor        | User                                                       |
| Trigger      | User taps on an account card                                |
| Main Flow    | 1. Navigate to Account Create Screen (edit mode, pre-filled) |
|              | 2. On save → BLoC emits `UpdateAccountRequested`             |
|              | 3. Re-fetch all accounts                                     |
| Postcondition| Account updated, total recalculated                           |

### UC-ACC-LIST-05: Delete Account
| Field        | Description                                                |
|-------------|-------------------------------------------------------------|
| Actor        | User                                                       |
| Trigger      | User taps delete on account card                            |
| Main Flow    | 1. Show confirmation dialog                                 |
|              | 2. On confirm → BLoC emits `DeleteAccountRequested`          |
|              | 3. Account deleted via `AccountRepository.deleteAccount()`   |
|              | 4. Re-fetch all accounts                                     |
| Postcondition| Account removed, total recalculated                           |
| Warning      | Should check if account has linked transactions first         |

---

## Business Rules

| Rule ID         | Rule                                                          |
|----------------|----------------------------------------------------------------|
| BR-ACC-LIST-01 | Total balance = sum of all account `.balance` values           |
| BR-ACC-LIST-02 | Accounts displayed as cards grouped/colored by type            |
| BR-ACC-LIST-03 | Currency is always Thai Baht (฿)                               |
| BR-ACC-LIST-04 | After any mutation (create/update/delete), full list is re-fetched |

---

## Dependencies

- `AccountRepository` (getAccounts, deleteAccount)
- Navigation to: Account Create Screen
