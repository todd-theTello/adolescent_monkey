/// entity containing static strings
class Endpoints {
  /// connection timeout duration
  static const Duration connectionTimeout = Duration(milliseconds: 150000);

  /// receive timeout duration
  static const Duration receiveTimeout = Duration(milliseconds: 150000);

  /// Base url for network requests
  static const String baseUrl = 'https://91dd-41-155-61-14.ngrok-free.app/';

  /// Get login endpoint
  static String login = 'api/login';

  /// Get login endpoint
  static String register = 'api/register';

  /// Get login endpoint
  static String user = 'api/user';

  /// Get login endpoint
  static String bot = 'api/bot';

  /// Get login endpoint
  static String chats = 'api/chats';
}
