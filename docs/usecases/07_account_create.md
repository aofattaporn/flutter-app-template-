# Use Cases: Account Create/Edit Screen

> **Screen**: `account_create_screen.dart`
> **BLoC**: `AccountBloc`
> **Status**: COMPLETE
> **Design Spec**: `propmt/account_create_screen.html`

---

## Screen Purpose

Create a new account or edit an existing one. User provides account name, type, opening balance, and optionally notes.

---

## Use Cases Checklist

| # | Use Case | Status |
|---|----------|--------|
| UC-ACC-CREATE-01 | Create New Account | ✅ Done |
| UC-ACC-CREATE-02 | Edit Existing Account | ✅ Done |
| UC-ACC-CREATE-03 | Select Account Type | ✅ Done |

---

## Use Cases

### UC-ACC-CREATE-01: Create New Account
| Field        | Description                                                |
|-------------|-------------------------------------------------------------|
| Actor        | User                                                       |
| Trigger      | User taps "Add Account" from Account List                   |
| Main Flow    | 1. Show empty form with account type grid                    |
|              | 2. User enters: account name                                 |
|              | 3. User selects account type from grid (Bank, Cash, Credit Card, etc.) |
|              | 4. User enters opening balance (optional, defaults to 0)     |
|              | 5. User taps "Save"                                          |
|              | 6. Validate inputs                                           |
|              | 7. Call `AccountRepository.createAccount(account)`           |
|              | 8. Return to Account List                                    |
| Postcondition| New account created in database                              |
| Validation   | Name is required; type must be selected                      |

### UC-ACC-CREATE-02: Edit Existing Account
| Field        | Description                                                |
|-------------|-------------------------------------------------------------|
| Actor        | User                                                       |
| Precondition | Account exists                                              |
| Trigger      | User taps on account card from Account List                  |
| Main Flow    | 1. Show form pre-filled with existing account data           |
|              | 2. User modifies any fields                                  |
|              | 3. User taps "Save"                                          |
|              | 4. Validate inputs                                           |
|              | 5. Call `AccountRepository.updateAccount(account)`           |
|              | 6. Return to Account List                                    |
| Postcondition| Account updated in database                                  |

### UC-ACC-CREATE-03: Select Account Type
| Field        | Description                                                |
|-------------|-------------------------------------------------------------|
| Actor        | User                                                       |
| Trigger      | User views account type grid on create/edit form             |
| Main Flow    | 1. Display grid of account types (Bank, Cash, Credit Card, Wallet, etc.) |
|              | 2. User taps a type tile                                     |
|              | 3. Type is highlighted as selected                           |
| Postcondition| Account type stored                                          |

---

## Business Rules

| Rule ID            | Rule                                                       |
|-------------------|------------------------------------------------------------|
| BR-ACC-CREATE-01  | Account name is required and cannot be empty                |
| BR-ACC-CREATE-02  | Account type must be selected from predefined list          |
| BR-ACC-CREATE-03  | Opening balance defaults to 0 if not provided               |
| BR-ACC-CREATE-04  | Balance and opening balance are in Thai Baht (฿)            |
| BR-ACC-CREATE-05  | Negative balance toggle — removed from scope              |
| BR-ACC-CREATE-06  | Notes field — removed from scope                           |

---

## Account Types (Current)

| Type           | Description                |
|---------------|----------------------------|
| Bank Account   | Standard bank account      |
| Cash           | Physical cash              |
| Credit Card    | Credit card account        |
| Wallet         | Digital wallet (e.g. PromptPay) |

---

## Dependencies

- `AccountRepository` (createAccount, updateAccount)
- Called from: Account List screen
