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
