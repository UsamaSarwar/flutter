import 'dart:convert';

import 'package:http/http.dart' as http;

/// Messaging functionality for Telegram Bot API
class TelegramMessaging {
  static const String _baseApiUrl = 'https://api.telegram.org/bot';

  /// Makes an HTTP request to the Telegram Bot API
  static Future<Map<String, dynamic>> makeApiRequest(String botToken, String method, Map<String, dynamic> parameters) async {
    final uri = Uri.parse('$_baseApiUrl$botToken/$method');

    try {
      final response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(parameters),
      );

      final data = json.decode(response.body);

      if (data['ok'] == true) {
        return data['result'];
      } else {
        throw Exception('Telegram API Error: ${data['description']}');
      }
    } catch (e) {
      throw Exception('Failed to make API request: $e');
    }
  }

  /// Gets information about the bot via Bot API.
  static Future<Map<String, dynamic>> getMe(String botToken) async {
    return await makeApiRequest(botToken, 'getMe', {});
  }

  /// Sends a message via Bot API.
  static Future<Map<String, dynamic>> sendMessage({
    required String botToken,
    required String chatId,
    required String text,
    String? parseMode,
    bool? disableWebPagePreview,
    bool? disableNotification,
    int? replyToMessageId,
  }) async {
    final parameters = <String, dynamic>{
      'chat_id': chatId,
      'text': text,
    };

    if (parseMode != null) parameters['parse_mode'] = parseMode;
    if (disableWebPagePreview != null) {
      parameters['disable_web_page_preview'] = disableWebPagePreview;
    }
    if (disableNotification != null) {
      parameters['disable_notification'] = disableNotification;
    }
    if (replyToMessageId != null) {
      parameters['reply_to_message_id'] = replyToMessageId;
    }

    return await makeApiRequest(botToken, 'sendMessage', parameters);
  }

  /// Forwards a message via Bot API.
  static Future<Map<String, dynamic>> forwardMessage({
    required String botToken,
    required String chatId,
    required String fromChatId,
    required int messageId,
    bool? disableNotification,
  }) async {
    final parameters = <String, dynamic>{
      'chat_id': chatId,
      'from_chat_id': fromChatId,
      'message_id': messageId,
    };

    if (disableNotification != null) {
      parameters['disable_notification'] = disableNotification;
    }

    return await makeApiRequest(botToken, 'forwardMessage', parameters);
  }

  /// Sends a location via Bot API.
  static Future<Map<String, dynamic>> sendLocation({
    required String botToken,
    required String chatId,
    required double latitude,
    required double longitude,
    double? horizontalAccuracy,
    int? livePeriod,
    int? heading,
    int? proximityAlertRadius,
    bool? disableNotification,
    int? replyToMessageId,
  }) async {
    final parameters = <String, dynamic>{
      'chat_id': chatId,
      'latitude': latitude,
      'longitude': longitude,
    };

    if (horizontalAccuracy != null) parameters['horizontal_accuracy'] = horizontalAccuracy;
    if (livePeriod != null) parameters['live_period'] = livePeriod;
    if (heading != null) parameters['heading'] = heading;
    if (proximityAlertRadius != null) parameters['proximity_alert_radius'] = proximityAlertRadius;
    if (disableNotification != null) {
      parameters['disable_notification'] = disableNotification;
    }
    if (replyToMessageId != null) {
      parameters['reply_to_message_id'] = replyToMessageId;
    }

    return await makeApiRequest(botToken, 'sendLocation', parameters);
  }

  /// Sends a venue via Bot API.
  static Future<Map<String, dynamic>> sendVenue({
    required String botToken,
    required String chatId,
    required double latitude,
    required double longitude,
    required String title,
    required String address,
    String? foursquareId,
    String? foursquareType,
    String? googlePlaceId,
    String? googlePlaceType,
    bool? disableNotification,
    int? replyToMessageId,
  }) async {
    final parameters = <String, dynamic>{
      'chat_id': chatId,
      'latitude': latitude,
      'longitude': longitude,
      'title': title,
      'address': address,
    };

    if (foursquareId != null) parameters['foursquare_id'] = foursquareId;
    if (foursquareType != null) parameters['foursquare_type'] = foursquareType;
    if (googlePlaceId != null) parameters['google_place_id'] = googlePlaceId;
    if (googlePlaceType != null) parameters['google_place_type'] = googlePlaceType;
    if (disableNotification != null) {
      parameters['disable_notification'] = disableNotification;
    }
    if (replyToMessageId != null) {
      parameters['reply_to_message_id'] = replyToMessageId;
    }

    return await makeApiRequest(botToken, 'sendVenue', parameters);
  }

  /// Sends a contact via Bot API.
  static Future<Map<String, dynamic>> sendContact({
    required String botToken,
    required String chatId,
    required String phoneNumber,
    required String firstName,
    String? lastName,
    String? vcard,
    bool? disableNotification,
    int? replyToMessageId,
  }) async {
    final parameters = <String, dynamic>{
      'chat_id': chatId,
      'phone_number': phoneNumber,
      'first_name': firstName,
    };

    if (lastName != null) parameters['last_name'] = lastName;
    if (vcard != null) parameters['vcard'] = vcard;
    if (disableNotification != null) {
      parameters['disable_notification'] = disableNotification;
    }
    if (replyToMessageId != null) {
      parameters['reply_to_message_id'] = replyToMessageId;
    }

    return await makeApiRequest(botToken, 'sendContact', parameters);
  }

  /// Sends a poll via Bot API.
  static Future<Map<String, dynamic>> sendPoll({
    required String botToken,
    required String chatId,
    required String question,
    required List<String> options,
    bool? isAnonymous,
    String? type,
    bool? allowsMultipleAnswers,
    int? correctOptionId,
    String? explanation,
    String? explanationParseMode,
    int? openPeriod,
    int? closeDate,
    bool? isClosed,
    bool? disableNotification,
    int? replyToMessageId,
  }) async {
    final parameters = <String, dynamic>{
      'chat_id': chatId,
      'question': question,
      'options': options,
    };

    if (isAnonymous != null) parameters['is_anonymous'] = isAnonymous;
    if (type != null) parameters['type'] = type;
    if (allowsMultipleAnswers != null) {
      parameters['allows_multiple_answers'] = allowsMultipleAnswers;
    }
    if (correctOptionId != null) parameters['correct_option_id'] = correctOptionId;
    if (explanation != null) parameters['explanation'] = explanation;
    if (explanationParseMode != null) {
      parameters['explanation_parse_mode'] = explanationParseMode;
    }
    if (openPeriod != null) parameters['open_period'] = openPeriod;
    if (closeDate != null) parameters['close_date'] = closeDate;
    if (isClosed != null) parameters['is_closed'] = isClosed;
    if (disableNotification != null) {
      parameters['disable_notification'] = disableNotification;
    }
    if (replyToMessageId != null) {
      parameters['reply_to_message_id'] = replyToMessageId;
    }

    return await makeApiRequest(botToken, 'sendPoll', parameters);
  }

  /// Sends a dice via Bot API.
  static Future<Map<String, dynamic>> sendDice({
    required String botToken,
    required String chatId,
    String? emoji,
    bool? disableNotification,
    int? replyToMessageId,
  }) async {
    final parameters = <String, dynamic>{
      'chat_id': chatId,
    };

    if (emoji != null) parameters['emoji'] = emoji;
    if (disableNotification != null) {
      parameters['disable_notification'] = disableNotification;
    }
    if (replyToMessageId != null) {
      parameters['reply_to_message_id'] = replyToMessageId;
    }

    return await makeApiRequest(botToken, 'sendDice', parameters);
  }

  /// Edits a message text via Bot API.
  static Future<Map<String, dynamic>> editMessageText({
    required String botToken,
    String? chatId,
    int? messageId,
    String? inlineMessageId,
    required String text,
    String? parseMode,
    bool? disableWebPagePreview,
  }) async {
    final parameters = <String, dynamic>{
      'text': text,
    };

    if (chatId != null) parameters['chat_id'] = chatId;
    if (messageId != null) parameters['message_id'] = messageId;
    if (inlineMessageId != null) parameters['inline_message_id'] = inlineMessageId;
    if (parseMode != null) parameters['parse_mode'] = parseMode;
    if (disableWebPagePreview != null) {
      parameters['disable_web_page_preview'] = disableWebPagePreview;
    }

    return await makeApiRequest(botToken, 'editMessageText', parameters);
  }

  /// Deletes a message via Bot API.
  static Future<bool> deleteMessage({
    required String botToken,
    required String chatId,
    required int messageId,
  }) async {
    final result = await makeApiRequest(botToken, 'deleteMessage', {
      'chat_id': chatId,
      'message_id': messageId,
    });
    return result as bool;
  }

  /// Answers a callback query via Bot API.
  static Future<bool> answerCallbackQuery({
    required String botToken,
    required String callbackQueryId,
    String? text,
    bool? showAlert,
    String? url,
    int? cacheTime,
  }) async {
    final parameters = <String, dynamic>{
      'callback_query_id': callbackQueryId,
    };

    if (text != null) parameters['text'] = text;
    if (showAlert != null) parameters['show_alert'] = showAlert;
    if (url != null) parameters['url'] = url;
    if (cacheTime != null) parameters['cache_time'] = cacheTime;

    final result = await makeApiRequest(botToken, 'answerCallbackQuery', parameters);
    return result as bool;
  }

  /// Gets updates via Bot API.
  static Future<List<Map<String, dynamic>>> getUpdates({
    required String botToken,
    int? offset,
    int? limit,
    int? timeout,
    List<String>? allowedUpdates,
  }) async {
    final parameters = <String, dynamic>{};

    if (offset != null) parameters['offset'] = offset;
    if (limit != null) parameters['limit'] = limit;
    if (timeout != null) parameters['timeout'] = timeout;
    if (allowedUpdates != null) parameters['allowed_updates'] = allowedUpdates;

    final result = await makeApiRequest(botToken, 'getUpdates', parameters);
    return List<Map<String, dynamic>>.from(result as List);
  }
}
