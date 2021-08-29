import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:supabase_analytics/src/core/analytics_observer.dart';
import 'package:uuid/uuid.dart';

/// {@template analytics}
/// Analytics API
/// {@endtemplate}
abstract class Analytics {
  /// {@macro supabase_analytics}
  Analytics() : session = AnalyticsSession();

  /// Unique identifier for current analytics session.
  final AnalyticsSession session;

  AnalyticsObserver? _routeObserver;

  /// A NavigatorObserver that sends events when the currently active
  /// PageRoute changes.
  AnalyticsObserver getRouteObserver(ScreenNameExtractor nameExtractor) {
    return _routeObserver ??= AnalyticsObserver(
      analytics: this,
      nameExtractor: nameExtractor,
    );
  }

  /// Logs analytics event with the given [event] and [params].
  Future<void> logEvent({required String event, Map<String, Object?>? params});

  /// Logs the standard `app_open` event.
  Future<void> logAppOpen({String? appVersion}) async {
    return logEvent(
      event: AnalyticEvent.appOpen,
      params: filterOutNulls({
        'appVersion': appVersion,
        'os': session.os,
        'locale': session.locale,
      }),
    );
  }

  /// This event indicates that a user has signed up for an account in your
  /// app. The parameter signifies the method by which the user signed up. Use
  /// this event to understand the different behaviors between logged in and
  /// logged out users.
  Future<void> logSignUp({String? method}) {
    return logEvent(
      event: AnalyticEvent.signUp,
      params: filterOutNulls({'method': method}),
    );
  }

  /// Apps with a login feature can report this event to signify that a user
  /// has logged in.
  Future<void> logLogin({
    String? method,
  }) {
    return logEvent(
      event: AnalyticEvent.login,
      params: filterOutNulls({'method': method}),
    );
  }

  /// This helps identify the areas in your app where users spend their time
  /// and how they interact with your app.
  Future<void> setCurrentScreen({required String? screenName}) {
    return logEvent(
      event: AnalyticEvent.screenViewed,
      params: filterOutNulls({'screen': screenName}),
    );
  }

  /// Log this event when a user joins a group such as a guild, team or family.
  /// Use this event to analyze how popular certain groups or social features
  /// are in your app.
  Future<void> logJoinGroup({required String groupId}) {
    return logEvent(
      event: AnalyticEvent.joinedGroup,
      params: filterOutNulls({'group_id': groupId}),
    );
  }

  /// Logs the standard `share` event.
  ///
  /// Apps with social features can log the Share event to identify the most
  /// viral content.
  Future<void> logShare({required String contentType, required String itemId}) {
    return logEvent(
      event: AnalyticEvent.shared,
      params: filterOutNulls({
        'content_type': contentType,
        'item_id': itemId,
      }),
    );
  }

  /// This event signifies that some content was shown to the user.
  Future<void> logViewItem({required String itemId, required String itemName}) {
    return logEvent(
      event: AnalyticEvent.viewedItem,
      params: filterOutNulls({
        'item_name': itemName,
        'item_id': itemId,
      }),
    );
  }

  /// Creates a new map containing all of the key/value pairs from [parameters]
  /// except those whose value is `null`.
  @visibleForTesting
  Map<String, Object> filterOutNulls(Map<String, Object?> parameters) {
    final filtered = <String, Object>{};
    parameters.forEach((String key, Object? value) {
      if (value != null) filtered[key] = value;
    });
    return filtered;
  }
}

/// {@template analytics}
/// Information about current user
/// {@endtemplate}
class AnalyticsSession {
  /// {@macro analytics}
  factory AnalyticsSession() => _instance ??= AnalyticsSession._();

  AnalyticsSession._()
      : uuid = const Uuid().v1(),
        os = Platform.operatingSystem,
        locale = Platform.localeName;

  static AnalyticsSession? _instance;

  /// Unique identifier for current analytics session.
  final String uuid;

  /// The operating system or platform.
  final String os;

  /// The name of the current locale.
  final String locale;
}

/// {@template analytic_event}
/// In app events
/// {@endtemplate}
abstract class AnalyticEvent {
  /// App started
  static String appOpen = 'app_open';

  /// User sign up
  static String signUp = 'sign_up';

  /// User log in
  static String login = 'login';

  /// User log out
  static String logOut = 'logout';

  /// New screen pushed
  static String screenViewed = 'screen_viewed';

  /// User joined group
  static String joinedGroup = 'joined_group';

  /// User pressed list item
  static String viewedItem = 'viewed_item';

  /// User shared ressource
  static String shared = 'shared';
}
