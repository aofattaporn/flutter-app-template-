/// Core module for IngreNote app
/// Contains shared utilities, constants, and base classes
library core;

// ─────────────────────────────────────────────────────────────
// Constants
// ─────────────────────────────────────────────────────────────
export 'constants/app_constants.dart';
export 'constants/api_constants.dart';

// ─────────────────────────────────────────────────────────────
// Errors & Failures
// ─────────────────────────────────────────────────────────────
export 'errors/failures.dart';
export 'errors/exceptions.dart';

// ─────────────────────────────────────────────────────────────
// Network
// ─────────────────────────────────────────────────────────────
export 'network/network_info.dart';
export 'network/api_client.dart';
export 'network/api_response.dart';

// ─────────────────────────────────────────────────────────────
// Utils
// ─────────────────────────────────────────────────────────────
export 'utils/typedefs.dart';
export 'utils/extensions.dart';
export 'utils/logger.dart';
export 'utils/validators.dart';

// ─────────────────────────────────────────────────────────────
// Storage
// ─────────────────────────────────────────────────────────────
export 'storage/local_storage.dart';

// ─────────────────────────────────────────────────────────────
// Base Classes
// ─────────────────────────────────────────────────────────────
export 'base/use_case.dart';
