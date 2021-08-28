import 'dart:developer';

import 'package:supabase/supabase.dart';
import 'package:supabase_analytics/src/core/analytics_core.dart';

export 'package:supabase/supabase.dart' show SupabaseClient;

const _kTableName = 'actions';

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

  bool _isSessionSaved = false;

  /// Upsert current device informations
  Future<bool> _saveSession() async {
    if (!_isSessionSaved) {
      final response = await _supabaseClient.from('sessions').upsert([
        {
          'id': session.uuid,
          'os': session.os,
          'version': session.version,
          'locale': session.locale,
        }
      ]).execute();

      if (response.error != null) log(response.error!.message);

      return _isSessionSaved = response.error == null;
    }

    return true;
  }

  @override
  Future<void> logEvent({
    required String event,
    Map<String, Object?>? params,
  }) async {
    if (await _saveSession()) {
      final response = await _supabaseClient.from(tableName).insert([
        {'session_id': session.uuid, 'event': event, 'data': params}
      ]).execute();

      if (response.error != null) log(response.error!.message);
    }
  }
}
