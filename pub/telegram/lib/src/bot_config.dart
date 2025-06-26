import 'messaging.dart';

/// Bot configuration functionality for Telegram Bot API
class TelegramBotConfig {
  /// Sets the list of bot commands via Bot API.
  static Future<bool> setMyCommands({
    required String botToken,
    required List<Map<String, String>> commands,
    String? scope,
    String? languageCode,
  }) async {
    final parameters = <String, dynamic>{
      'commands': commands,
    };

    if (scope != null) parameters['scope'] = scope;
    if (languageCode != null) parameters['language_code'] = languageCode;

    final result = await TelegramMessaging.makeApiRequest(botToken, 'setMyCommands', parameters);
    return result as bool;
  }

  /// Gets the list of bot commands via Bot API.
  static Future<List<Map<String, dynamic>>> getMyCommands({
    required String botToken,
    String? scope,
    String? languageCode,
  }) async {
    final parameters = <String, dynamic>{};

    if (scope != null) parameters['scope'] = scope;
    if (languageCode != null) parameters['language_code'] = languageCode;

    final result = await TelegramMessaging.makeApiRequest(botToken, 'getMyCommands', parameters);
    return List<Map<String, dynamic>>.from(result as List);
  }

  /// Sets the bot's description via Bot API.
  static Future<bool> setMyDescription({
    required String botToken,
    String? description,
    String? languageCode,
  }) async {
    final parameters = <String, dynamic>{};

    if (description != null) parameters['description'] = description;
    if (languageCode != null) parameters['language_code'] = languageCode;

    final result = await TelegramMessaging.makeApiRequest(botToken, 'setMyDescription', parameters);
    return result as bool;
  }

  /// Gets the bot's description via Bot API.
  static Future<Map<String, dynamic>> getMyDescription({
    required String botToken,
    String? languageCode,
  }) async {
    final parameters = <String, dynamic>{};

    if (languageCode != null) parameters['language_code'] = languageCode;

    return await TelegramMessaging.makeApiRequest(botToken, 'getMyDescription', parameters);
  }

  /// Sets the bot's short description via Bot API.
  static Future<bool> setMyShortDescription({
    required String botToken,
    String? shortDescription,
    String? languageCode,
  }) async {
    final parameters = <String, dynamic>{};

    if (shortDescription != null) parameters['short_description'] = shortDescription;
    if (languageCode != null) parameters['language_code'] = languageCode;

    final result = await TelegramMessaging.makeApiRequest(botToken, 'setMyShortDescription', parameters);
    return result as bool;
  }

  /// Gets the bot's short description via Bot API.
  static Future<Map<String, dynamic>> getMyShortDescription({
    required String botToken,
    String? languageCode,
  }) async {
    final parameters = <String, dynamic>{};

    if (languageCode != null) parameters['language_code'] = languageCode;

    return await TelegramMessaging.makeApiRequest(botToken, 'getMyShortDescription', parameters);
  }
}
