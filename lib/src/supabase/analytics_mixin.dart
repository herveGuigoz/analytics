import 'package:supabase_analytics/supabase_analytics.dart';

/// {@template analytics_mixin}
/// A mixin which give access to initialized instance.
/// {@endtemplate}
mixin AnalyticsMixin {
  static Analytics? _instance;

  /// Initialize an instance for supabase API.
  static void initializeWithSupabase(
    String supabaseKEY,
    String supabaseURL, {
    String? table,
  }) {
    _instance = SupabaseAnalytics(supabaseURL, supabaseKEY, table: table);
  }

  /// Instance of [Analytics] which will be used report events.
  Analytics get analytics {
    if (_instance == null) throw const AnalyticsNotFound();
    return _instance!;
  }
}

/// {@template analytics_not_found}
/// Exception thrown if there was no [Analytics] initialized.
/// {@endtemplate}
class AnalyticsNotFound implements Exception {
  /// {@macro analytics_not_found}
  const AnalyticsNotFound();

  @override
  String toString() {
    return 'Analytics was accessed before it was initialized.\n'
        'Please ensure that Analytics has been initialized.\n\n'
        'For example:\n\n'
        'AnalyticsMixin.initializeWithSupabase(supabaseKEY, supabaseURL);';
  }
}
