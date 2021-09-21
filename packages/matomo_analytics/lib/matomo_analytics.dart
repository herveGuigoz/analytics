library matomo_analytics;

import 'dart:math';

import 'package:analytics_core/analytics_core.dart';
import 'package:http/http.dart' as http;

/// {@template supabase_analytics}
/// Implementation of [Analytics] with Matomo API
/// https://developer.matomo.org/api-reference/tracking-api
/// {@endtemplate}
class MatomoAnalytics extends Analytics {
  /// Instance of [Analytics] which will be used report events.
  MatomoAnalytics._(this.url, this.idsite);

  static MatomoAnalytics? _instance;
  factory MatomoAnalytics() {
    if (_instance == null) throw const AnalyticsNotFound();
    return _instance!;
  }

  static MatomoAnalytics build({int? idsite, required String url}) {
    return _instance ??= MatomoAnalytics._(url, idsite ?? 1);
  }

  final int idsite;
  final String url;

  @override
  Future<void> logEvent({
    required String event,
    Map<String, Object?>? params,
  }) async {
    final now = DateTime.now();

    await http.post(
      Uri.parse(url),
      body: <String, dynamic>{
        'cvar': {
          '1': ['OS', session.os]
        },
        'lang': session.locale,
        'idsite': idsite,
        'rec': 1,
        'rand': Random().nextInt(1000000000),
        'h': now.hour,
        'm': now.minute,
        's': now.second,
        '_id': session.uuid,
        'action_name': event,
      },
    );
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
        'Please ensure that Analytics has been initialized.\n\n';
  }
}
