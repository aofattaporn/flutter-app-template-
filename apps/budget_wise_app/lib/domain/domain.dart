/// Domain module for IngreNote app
/// Contains business logic, entities, and repository interfaces
library domain;

// ─────────────────────────────────────────────────────────────
// Entities
// ─────────────────────────────────────────────────────────────
export 'entities/user_entity.dart';
export 'entities/plan.dart';
export 'entities/plan_item.dart';

// ─────────────────────────────────────────────────────────────
// Repositories (Interfaces)
// ─────────────────────────────────────────────────────────────
export 'repositories/auth_repository.dart';
export 'repositories/plan_repository.dart';

// ─────────────────────────────────────────────────────────────
// Use Cases
// ─────────────────────────────────────────────────────────────
export 'usecases/auth/login_usecase.dart';
export 'usecases/auth/register_usecase.dart';
export 'usecases/auth/logout_usecase.dart';
export 'usecases/auth/get_current_user_usecase.dart';
export 'usecases/plans/plans_usecases.dart';
