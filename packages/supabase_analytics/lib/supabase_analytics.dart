library supabase_analytics;

import 'dart:developer';

import 'package:analytics_core/analytics_core.dart';
import 'package:supabase/supabase.dart';

export 'package:supabase/supabase.dart' show SupabaseClient;

const _kTableName = 'analytics';

/// {@template supabase_analytics}
/// Implementation of [Analytics] with Supabase API
/// {@endtemplate}
class SupabaseAnalytics extends Analytics {
  /// {@macro supabase_analytics}
  SupabaseAnalytics(String supabaseURL, String supabaseKEY, {String? table})
      : _supabaseClient = SupabaseClient(supabaseURL, supabaseKEY),
        tableName = table ?? _kTableName;

  /// {@macro supabase_analytics}
  SupabaseAnalytics.fromClient(SupabaseClient value, {String? table})
      : _supabaseClient = value,
        tableName = table ?? _kTableName;

  final SupabaseClient _supabaseClient;

  /// Table name on Supabase Postgres schema
  final String tableName;

  @override
  Future<void> logEvent({
    required String event,
    Map<String, Object?>? params,
  }) async {
    final response = await _supabaseClient.from(tableName).insert([
      {'session_id': session.uuid, 'event': event, 'data': params}
    ]).execute();

    if (response.error != null) log(response.error!.message);
  }
}

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
