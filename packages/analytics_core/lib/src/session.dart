import 'dart:io';

import 'package:uuid/uuid.dart';

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
