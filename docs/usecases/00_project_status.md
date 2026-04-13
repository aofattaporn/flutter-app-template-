# BudgetWise - Project Status Overview

> Last updated: April 13, 2026

## Architecture

| Layer        | Pattern              | Tech                              |
|-------------|----------------------|-----------------------------------|
| Presentation | BLoC (flutter_bloc) | Flutter widgets, BlocProvider      |
| Domain       | Use Cases + Repo     | Equatable entities, dartz Either   |
| Data         | Repo Impl + Sources  | Supabase, Dio (REST), SharedPrefs  |
| DI           | Service Locator      | GetIt                              |
| Routing      | GoRouter (minimal)   | Imperative Navigator.push mostly   |
| Config       | .env driven          | flutter_dotenv                     |

**Currency**: Thai Baht (฿)

---

## Feature Status

| Feature        | Status             | Use Cases | Done | Notes                                       |
|---------------|--------------------|-----------|----- |----------------------------------------------|
| Plans          | ~90% Complete      | 19        | 17   | Missing: filter tabs, actuals from txn       |
| Accounts       | ~80% Complete      | 8         | 8    | Missing: error handling, notes field          |
| Transactions   | NOT STARTED        | 11        | 0    | No entity/model/repo/BLoC                     |
| Home Overview  | NOT STARTED        | 3         | 0    | Placeholder only                              |
| Settings       | NOT STARTED        | 4         | 0    | Placeholder only, no design spec              |
| Navigation     | COMPLETE           | 2         | 2    | Bottom nav + FAB working                      |
| **TOTAL**      |                    | **47**    | **27** | **57% complete**                            |

---

## What's Implemented (Screens)

### ✅ Plans Feature
- **Active Plan Page** — View active plan with items, income, progress bars
- **Plan List Page** — View all plans, sorted active-first
- **Plan Editor Page** — Create / Edit plan (name, dates, income)
- **Plan Detail Page** — View single plan details
- **Plan Item Editor Page** — Add / Edit plan items (name, amount, icon)

### ✅ Accounts Feature
- **Account List Screen** — All accounts with total balance
- **Account Create Screen** — Create / Edit account (name, type, balance)

### ❌ Not Yet Built
- **Transaction Editor Screen** — Design exists in `propmt/home_overview_screen.html`
- **Transaction History Screen** — Design exists (but file is duplicate of account_screen)
- **Home Overview Screen** — Should show dashboard or quick-create transaction
- **Settings Screen** — No design spec
- **Login / Register Screens** — Auth code exists but no UI

---

## Known Issues & Technical Debt

1. **Plan use cases exist but aren't used** — 9 plan use cases defined in `domain/usecases/plans/` but NOT registered in DI. BLoCs call repositories directly.
2. **`actualAmount` always returns 0** — `getPlanItemActuals()` is a TODO stub. Needs transactions feature to work.
3. **Error handling inconsistency** — Auth repo uses `dartz Either`, Plan/Account repos throw raw exceptions.
4. **Account feature is feature-local** — Has its own `domain/` and `data/` inside `features/accounts/`, while Plans/Auth use shared `lib/domain/` and `lib/data/`.
5. **SSL bypass in production code** — `_DevHttpOverrides` always runs when Supabase is configured.
6. **HTML prompt files have duplicates** — `transaction_history_screen.html`, `transaction_editor_screen.html`, and `plan_editor_screen.html` are copies of other screens.

---

## Next Priority (Recommended)

1. **Build Transactions feature** — This is the critical missing piece that blocks plan item actuals and home overview.
2. **Build Auth UI** — Login/Register screens + auth guard in router.
3. **Wire up Plan use cases** — Register in DI, use from BLoCs instead of direct repo calls.
4. **Standardize error handling** — Use `dartz Either` everywhere or switch to a unified approach.
