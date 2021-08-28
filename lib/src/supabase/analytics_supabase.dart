import 'dart:developer';

import 'package:supabase/supabase.dart';
import 'package:supabase_analytics/src/core/analytics_core.dart';

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
