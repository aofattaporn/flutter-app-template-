# Use Cases: Settings Screen

> **Screen**: `settings_placeholder_page.dart`
> **Status**: NOT STARTED (placeholder only)
> **Design Spec**: None

---

## Screen Purpose

App settings and user preferences. No design spec exists yet.

---

## Use Cases Checklist

| # | Use Case | Status |
|---|----------|--------|
| UC-SETTINGS-01 | View Settings | ⬜ Not Started |
| UC-SETTINGS-02 | Switch Backend (Dev) | ⬜ Not Started |
| UC-SETTINGS-03 | Logout | ⬜ Not Started |
| UC-SETTINGS-04 | User Profile | ⬜ Not Started |

---

## Suggested Use Cases

### UC-SETTINGS-01: View Settings
| Field        | Description                                                |
|-------------|-------------------------------------------------------------|
| Actor        | User                                                       |
| Trigger      | User taps Settings tab                                      |
| Main Flow    | Display list of setting options                              |

### UC-SETTINGS-02: Switch Backend (Dev)
| Field        | Description                                                |
|-------------|-------------------------------------------------------------|
| Actor        | Developer                                                   |
| Note         | App supports REST and Supabase backends via `.env`           |
| Main Flow    | Change `BACKEND_TYPE` in config                              |

### UC-SETTINGS-03: Logout
| Field        | Description                                                |
|-------------|-------------------------------------------------------------|
| Actor        | User                                                       |
| Precondition | User is logged in                                           |
| Main Flow    | 1. User taps "Logout"                                       |
|              | 2. Call `LogoutUseCase`                                      |
|              | 3. Clear session                                             |
|              | 4. Navigate to Login screen                                  |
| Note         | Auth UI not yet built — this is future work                  |

### UC-SETTINGS-04: User Profile
| Field        | Description                                                |
|-------------|-------------------------------------------------------------|
| Actor        | User                                                       |
| Main Flow    | View/edit user name, email, avatar                           |
| Note         | `UserEntity` supports name, avatarUrl — no UI yet            |

---

## Dependencies

- `AuthRepository` (logout, getCurrentUser, updateProfile)
- Login/Register screens (NOT YET BUILT)
