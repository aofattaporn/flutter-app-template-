/// Data module for IngreNote app
/// Contains models, data sources, and repository implementations
library data;

// ─────────────────────────────────────────────────────────────
// Config
// ─────────────────────────────────────────────────────────────
export 'config/backend_config.dart';

// ─────────────────────────────────────────────────────────────
// Models
// ─────────────────────────────────────────────────────────────
export 'models/user_model.dart';
export 'models/plan_model.dart';
export 'models/plan_item_model.dart';

// ─────────────────────────────────────────────────────────────
// Data Sources
// ─────────────────────────────────────────────────────────────
export 'datasources/auth_datasource.dart';
export 'datasources/rest/auth_rest_datasource.dart';
export 'datasources/supabase/auth_supabase_datasource.dart';
export 'datasources/plan_datasource.dart';
export 'datasources/supabase/plan_supabase_datasource.dart';

// ─────────────────────────────────────────────────────────────
// Repositories
// ─────────────────────────────────────────────────────────────
export 'repositories/auth_repository_impl.dart';
export 'repositories/plan_repository_impl.dart';
