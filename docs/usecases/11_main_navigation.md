# Use Cases: Main App Shell (Navigation)

> **Screen**: `main_app_shell.dart`
> **Status**: COMPLETE
> **Tabs**: Home | Plans | (FAB) | Transactions | Accounts | Settings

---

## Screen Purpose

The main navigation container with bottom navigation bar and floating action button. Uses `IndexedStack` to preserve tab state.

---

## Use Cases Checklist

| # | Use Case | Status |
|---|----------|--------|
| UC-NAV-01 | Switch Between Tabs | ✅ Done |
| UC-NAV-02 | Quick Action via FAB | ✅ Done |

---

## Use Cases

### UC-NAV-01: Switch Between Tabs
| Field        | Description                                                |
|-------------|-------------------------------------------------------------|
| Actor        | User                                                       |
| Trigger      | User taps a bottom navigation item                          |
| Main Flow    | 1. IndexedStack switches to selected tab index               |
|              | 2. Tab state is preserved (not rebuilt)                      |
| Tabs         | 0: Home, 1: Plans (default), 2: Transactions, 3: Accounts, 4: Settings |
| Postcondition| Selected tab's page displayed                                |

### UC-NAV-02: Quick Action via FAB
| Field        | Description                                                |
|-------------|-------------------------------------------------------------|
| Actor        | User                                                       |
| Trigger      | User taps the floating action button (+)                    |
| Main Flow    | 1. Context-dependent action (e.g., create transaction)       |
|              | 2. Navigate to appropriate editor screen                     |
| Note         | Current FAB behavior depends on active tab                   |

---

## Tab → Screen Mapping

| Tab Index | Label        | Screen                          | Status      |
|-----------|-------------|----------------------------------|-------------|
| 0         | Home         | `home_placeholder_page.dart`     | PLACEHOLDER |
| 1         | Plans        | `active_plan_page.dart`          | COMPLETE    |
| 2         | Transactions | `transactions_placeholder_page.dart` | PLACEHOLDER |
| 3         | Accounts     | `account_screen.dart`            | COMPLETE    |
| 4         | Settings     | `settings_placeholder_page.dart` | PLACEHOLDER |

---

## Business Rules

| Rule ID      | Rule                                                          |
|-------------|----------------------------------------------------------------|
| BR-NAV-01   | Default tab is Plans (index 1)                                |
| BR-NAV-02   | Tab state preserved via IndexedStack                          |
| BR-NAV-03   | FAB is always visible on all tabs                             |
