library telegram;

import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;

/// A comprehensive Telegram utility that supports both client-side URL schemes
/// and server-side Bot API functionality for Flutter applications.
///
/// This package provides methods for:
/// - Sending messages via URL schemes
/// - Bot API integration for automated messaging
/// - Channel and group management
/// - Media sharing and file uploads
/// - User and chat information retrieval
class Telegram {
  static const String _baseApiUrl = 'https://api.telegram.org/bot';

  /// Bot token for API requests. Set this to enable Bot API features.
  static String? _botToken;

  /// Sets the bot token for API requests
  ///
  /// Get your bot token from @BotFather on Telegram
  /// Example: '123456789:ABCdefGHIjklMNOpqrsTUVwxyz'
  static void setBotToken(String token) {
    _botToken = token;
  }

  /// Gets the current bot token
  static String? get botToken => _botToken;

  /// Makes an HTTP request to the Telegram Bot API
  static Future<Map<String, dynamic>> _makeApiRequest(
      String method, Map<String, dynamic> parameters) async {
    if (_botToken == null) {
      throw Exception('Bot token not set. Call Telegram.setBotToken() first.');
    }

    final uri = Uri.parse('$_baseApiUrl$_botToken/$method');

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

  /// Generates a Telegram URL for a given username and optional message.
  ///
  /// This method constructs a URL that can be used to open a Telegram chat
  /// with the specified username. If a message is provided, it will be
  /// included in the URL as a pre-filled text.
  ///
  /// Throws an [ArgumentError] if the username is empty.
  /// Throws a [FormatException] if the URL generation fails.
  ///
  /// - Parameters:
  ///   - username: The Telegram username for which the URL is to be generated.
  ///   - message: An optional message to be included in the URL.
  ///
  /// - Returns: A [Uri] object representing the generated Telegram URL.
  static Uri _generateUrl({required String username, String? message}) {
    if (username.trim().isEmpty) {
      throw ArgumentError('Username cannot be empty.');
    }
    try {
      if (message != null && message.trim().isNotEmpty) {
        return Uri.parse(
            'https://t.me/$username?text=${Uri.encodeFull(message)}');
      } else {
        return Uri.parse('https://t.me/$username');
      }
    } catch (e) {
      throw FormatException('Failed to generate URL: $e');
    }
  }

  /// Copies the Telegram message link to the clipboard.
  ///
  /// This method generates a URL based on the provided [username] and optional [message],
  /// and then copies this URL to the system clipboard.
  ///
  /// If the operation is successful, the URL is printed to the console in debug mode.
  /// If the operation fails, an exception is thrown.
  ///
  /// - Parameters:
  ///   - username: The Telegram username to include in the generated URL. This parameter is required.
  ///   - message: An optional message to include in the generated URL.
  ///
  /// - Throws: An [Exception] if the link could not be copied to the clipboard.
  static Future<void> copyLinkToClipboard({
    required String username,
    String? message,
  }) async {
    Uri url = _generateUrl(username: username, message: message);
    try {
      await Clipboard.setData(ClipboardData(text: url.toString()));
      if (kDebugMode) {
        print('Copied to clipboard: $url');
      }
    } catch (e) {
      throw Exception('Failed to copy link to clipboard: $e');
    }
  }

  /// Returns the Telegram message link as a String.
  ///
  /// This method generates a URL for a Telegram message link based on the provided
  /// username and optional message.
  ///
  /// The [username] parameter is required and should be the Telegram username.
  ///
  /// The [message] parameter is optional and can be used to specify a particular
  /// message within the chat.
  ///
  /// Returns a [String] representing the generated Telegram message link.
  static String getLink({
    required String username,
    String? message,
  }) {
    Uri url = _generateUrl(username: username, message: message);
    return url.toString();
  }

  /// Sends a message via Telegram.
  ///
  /// This method constructs a URL to send a message to a specified Telegram
  /// username and attempts to launch it using the `launchUrl` function.
  ///
  /// If the message is successfully launched, it will print debug information
  /// if the application is in debug mode.
  ///
  /// Throws an [Exception] if the URL could not be launched or if there was
  /// an error during the process.
  ///
  /// Parameters:
  /// - `username` (required): The Telegram username to send the message to.
  /// - `message` (optional): The message to be sent. If not provided, only the
  ///   URL will be launched without any message content.
  ///
  /// Example:
  /// ```dart
  /// await send(username: 'exampleUser', message: 'Hello, this is a test message.');
  /// ```
  static Future<void> send({
    required String username,
    String? message,
  }) async {
    Uri url = _generateUrl(username: username, message: message);
    try {
      bool launched = await launchUrl(
        url,
        mode: LaunchMode.externalNonBrowserApplication,
        webOnlyWindowName: username,
        webViewConfiguration: const WebViewConfiguration(
          headers: <String, String>{
            'User-Agent': 'Telegram',
          },
        ),
      );
      if (!launched) {
        throw Exception('Could not launch Telegram link.');
      }
      if (kDebugMode) {
        if (message != null && message.trim().isNotEmpty) {
          print(
              'Sending message to $username...\nMessage: $message\nURL: $url');
        } else {
          print('Sending message to $username...\nURL: $url');
        }
      }
    } catch (e) {
      throw Exception('Failed to send message: $e');
    }
  }

  /// Checks if Telegram is installed on the device.
  ///
  /// This method attempts to launch a URL using Telegram's custom URL scheme.
  /// If the URL can be launched, it indicates that Telegram is installed on the device.
  ///
  /// Returns a [Future] that completes with `true` if Telegram is installed,
  /// and `false` otherwise.
  ///
  /// Throws an [Exception] if there is an error while attempting to check the
  /// installation status.
  static Future<bool> isTelegramInstalled() async {
    // Using Telegram's custom URL scheme.
    final Uri telegramUri = Uri.parse('tg://resolve?domain=telegram');
    try {
      return await canLaunchUrl(telegramUri);
    } catch (e) {
      throw Exception('Failed to check Telegram installation: $e');
    }
  }

  /// Opens a chat with the given username using Telegram's custom URL scheme.
  ///
  /// This method constructs a Telegram URL with the provided username and attempts
  /// to launch it using the `launchUrl` function. If the username is empty, an
  /// [ArgumentError] is thrown. If the URL cannot be launched, an [Exception] is thrown.
  ///
  /// The method uses the [LaunchMode.externalNonBrowserApplication] mode to open
  /// the Telegram app directly.
  ///
  /// If the app is in debug mode, a message indicating the success of the operation
  /// is printed to the console.
  ///
  /// Throws:
  /// - [ArgumentError] if the username is empty.
  /// - [Exception] if the URL cannot be launched or if any other error occurs.
  ///
  /// Example usage:
  /// ```dart
  /// await openChat(username: 'example_username');
  /// ```
  ///
  /// Parameters:
  /// - `username` (required): The Telegram username to open a chat with.
  static Future<void> openChat({required String username}) async {
    if (username.trim().isEmpty) {
      throw ArgumentError('Username cannot be empty.');
    }
    final Uri chatUri = Uri.parse('tg://resolve?domain=$username');
    try {
      bool launched = await launchUrl(
        chatUri,
        mode: LaunchMode.externalNonBrowserApplication,
      );
      if (!launched) {
        throw Exception('Could not open chat for $username.');
      }
      if (kDebugMode) {
        print('Opened chat for $username using $chatUri');
      }
    } catch (e) {
      throw Exception('Failed to open chat: $e');
    }
  }

  /// Joins a Telegram channel or group using an invite link.
  ///
  /// This method takes an invite link as a required parameter and attempts to
  /// join the corresponding Telegram channel or group. It validates the invite
  /// link, parses it into a URI, and then launches the URI using an external
  /// non-browser application.
  ///
  /// If the invite link is empty or invalid, an appropriate error is thrown.
  /// If the attempt to join the channel fails, an exception is thrown.
  ///
  /// In debug mode, a message is printed to the console indicating the invite
  /// link being used to join the channel.
  ///
  /// Throws:
  /// - [ArgumentError] if the invite link is empty.
  /// - [FormatException] if the invite link is invalid.
  /// - [Exception] if the attempt to join the channel fails.
  ///
  /// Example usage:
  /// ```dart
  /// await joinChannel(inviteLink: 'https://t.me/joinchat/XXXXXXX');
  /// ```
  static Future<void> joinChannel({required String inviteLink}) async {
    if (inviteLink.trim().isEmpty) {
      throw ArgumentError('Invite link cannot be empty.');
    }
    Uri channelUri;
    try {
      channelUri = Uri.parse(inviteLink);
    } catch (e) {
      throw FormatException('Invalid invite link: $e');
    }
    try {
      bool launched = await launchUrl(
        channelUri,
        mode: LaunchMode.externalNonBrowserApplication,
      );
      if (!launched) {
        throw Exception('Could not join channel using $inviteLink.');
      }
      if (kDebugMode) {
        print('Joining channel using $inviteLink');
      }
    } catch (e) {
      throw Exception('Failed to join channel: $e');
    }
  }

  /// Shares a contact via Telegram.
  ///
  /// This method constructs a Telegram link to share a contact.
  /// The contact details include a phone number, first name, and optional last name.
  ///
  /// Throws:
  /// - [ArgumentError] if the phone number or first name is empty.
  /// - [Exception] if the URL cannot be launched.
  ///
  /// Example usage:
  /// ```dart
  /// await shareContact(phone: '+1234567890', firstName: 'John', lastName: 'Doe');
  /// ```
  static Future<void> shareContact({
    required String phone,
    required String firstName,
    String? lastName,
  }) async {
    if (phone.trim().isEmpty || firstName.trim().isEmpty) {
      throw ArgumentError('Phone number and first name cannot be empty.');
    }

    String contactUrl = 'https://t.me/share/url?'
        'url=tel:$phone&'
        'text=Contact: $firstName ${lastName ?? ""}';

    try {
      bool launched = await launchUrl(Uri.parse(contactUrl),
          mode: LaunchMode.externalNonBrowserApplication);
      if (!launched) {
        throw Exception('Could not share contact via Telegram.');
      }
      if (kDebugMode) {
        print('Sharing contact: $firstName ${lastName ?? ""} - $phone');
      }
    } catch (e) {
      throw Exception('Failed to share contact: $e');
    }
  }

  /// Opens a Telegram group by its username.
  ///
  /// Throws:
  /// - [ArgumentError] if the group username is empty.
  /// - [Exception] if the URL cannot be launched.
  ///
  /// Example usage:
  /// ```dart
  /// await openGroup(username: 'yourgroupname');
  /// ```
  static Future<void> openGroup({required String username}) async {
    if (username.trim().isEmpty) {
      throw ArgumentError('Group username cannot be empty.');
    }

    Uri groupUri = Uri.parse('https://t.me/$username');

    try {
      bool launched = await launchUrl(groupUri,
          mode: LaunchMode.externalNonBrowserApplication);
      if (!launched) {
        throw Exception('Could not open group: $username');
      }
      if (kDebugMode) {
        print('Opened Telegram group: $username');
      }
    } catch (e) {
      throw Exception('Failed to open group: $e');
    }
  }

  /// Sends a media file via Telegram.
  ///
  /// The [filePath] should be a valid URL pointing to the media file.
  ///
  /// Throws:
  /// - [ArgumentError] if the filePath is empty.
  /// - [Exception] if the URL cannot be launched.
  ///
  /// Example usage:
  /// ```dart
  /// await sendMedia(filePath: 'https://example.com/sample.jpg');
  /// ```
  static Future<void> sendMedia({required String filePath}) async {
    if (filePath.trim().isEmpty) {
      throw ArgumentError('File path cannot be empty.');
    }

    Uri mediaUri = Uri.parse('https://t.me/share/url?url=$filePath');

    try {
      bool launched = await launchUrl(mediaUri,
          mode: LaunchMode.externalNonBrowserApplication);
      if (!launched) {
        throw Exception('Could not send media file.');
      }
      if (kDebugMode) {
        print('Sending media: $filePath');
      }
    } catch (e) {
      throw Exception('Failed to send media: $e');
    }
  }

  /// Checks if a Telegram username exists.
  ///
  /// Throws:
  /// - [ArgumentError] if the username is empty.
  /// - [Exception] if the request fails.
  ///
  /// Example usage:
  /// ```dart
  /// bool exists = await checkUsernameAvailability(username: 'exampleUser');
  /// ```
  static Future<bool> checkUsernameAvailability(
      {required String username}) async {
    if (username.trim().isEmpty) {
      throw ArgumentError('Username cannot be empty.');
    }

    Uri usernameUri = Uri.parse('https://t.me/$username');

    try {
      bool canOpen = await canLaunchUrl(usernameUri);
      return canOpen;
    } catch (e) {
      throw Exception('Failed to check username availability: $e');
    }
  }

  /// Opens a Telegram bot using its username.
  ///
  /// Throws:
  /// - [ArgumentError] if the bot username is empty.
  /// - [Exception] if the URL cannot be launched.
  ///
  /// Example usage:
  /// ```dart
  /// await openBot(username: 'MyTelegramBot');
  /// ```
  static Future<void> openBot({required String username}) async {
    if (username.trim().isEmpty) {
      throw ArgumentError('Bot username cannot be empty.');
    }

    Uri botUri = Uri.parse('https://t.me/$username');

    try {
      bool launched = await launchUrl(botUri,
          mode: LaunchMode.externalNonBrowserApplication);
      if (!launched) {
        throw Exception('Could not open bot: $username');
      }
      if (kDebugMode) {
        print('Opened Telegram bot: $username');
      }
    } catch (e) {
      throw Exception('Failed to open bot: $e');
    }
  }

  // ============================================================================
  // BOT API METHODS
  // ============================================================================

  /// Gets basic information about the bot via Bot API.
  ///
  /// Returns information like bot id, name, username, and capabilities.
  static Future<Map<String, dynamic>> getMe() async {
    return await _makeApiRequest('getMe', {});
  }

  /// Sends a text message via Bot API.
  ///
  /// [chatId] can be a username (@username) or numeric chat ID.
  /// [text] is the message text to send.
  /// [parseMode] can be 'HTML', 'Markdown', or 'MarkdownV2' for formatting.
  static Future<Map<String, dynamic>> sendMessage({
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

    return await _makeApiRequest('sendMessage', parameters);
  }

  /// Forwards a message via Bot API.
  ///
  /// [fromChatId] is the chat where the message originated.
  /// [messageId] is the ID of the message to forward.
  /// [chatId] is the destination chat.
  static Future<Map<String, dynamic>> forwardMessage({
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

    return await _makeApiRequest('forwardMessage', parameters);
  }

  /// Sends a photo via Bot API.
  static Future<Map<String, dynamic>> sendPhoto({
    required String chatId,
    required String photo, // File path or URL
    String? caption,
    String? parseMode,
    bool? disableNotification,
    int? replyToMessageId,
  }) async {
    final parameters = <String, dynamic>{
      'chat_id': chatId,
      'photo': photo,
    };

    if (caption != null) parameters['caption'] = caption;
    if (parseMode != null) parameters['parse_mode'] = parseMode;
    if (disableNotification != null) {
      parameters['disable_notification'] = disableNotification;
    }
    if (replyToMessageId != null) {
      parameters['reply_to_message_id'] = replyToMessageId;
    }

    return await _makeApiRequest('sendPhoto', parameters);
  }

  /// Sends an audio file via Bot API.
  static Future<Map<String, dynamic>> sendAudio({
    required String chatId,
    required String audio,
    String? caption,
    String? parseMode,
    int? duration,
    String? performer,
    String? title,
    bool? disableNotification,
    int? replyToMessageId,
  }) async {
    final parameters = <String, dynamic>{
      'chat_id': chatId,
      'audio': audio,
    };

    if (caption != null) parameters['caption'] = caption;
    if (parseMode != null) parameters['parse_mode'] = parseMode;
    if (duration != null) parameters['duration'] = duration;
    if (performer != null) parameters['performer'] = performer;
    if (title != null) parameters['title'] = title;
    if (disableNotification != null) {
      parameters['disable_notification'] = disableNotification;
    }
    if (replyToMessageId != null) {
      parameters['reply_to_message_id'] = replyToMessageId;
    }

    return await _makeApiRequest('sendAudio', parameters);
  }

  /// Sends a document via Bot API.
  static Future<Map<String, dynamic>> sendDocument({
    required String chatId,
    required String document,
    String? caption,
    String? parseMode,
    bool? disableNotification,
    int? replyToMessageId,
  }) async {
    final parameters = <String, dynamic>{
      'chat_id': chatId,
      'document': document,
    };

    if (caption != null) parameters['caption'] = caption;
    if (parseMode != null) parameters['parse_mode'] = parseMode;
    if (disableNotification != null) {
      parameters['disable_notification'] = disableNotification;
    }
    if (replyToMessageId != null) {
      parameters['reply_to_message_id'] = replyToMessageId;
    }

    return await _makeApiRequest('sendDocument', parameters);
  }

  /// Sends a video via Bot API.
  static Future<Map<String, dynamic>> sendVideo({
    required String chatId,
    required String video,
    int? duration,
    int? width,
    int? height,
    String? caption,
    String? parseMode,
    bool? supportsStreaming,
    bool? disableNotification,
    int? replyToMessageId,
  }) async {
    final parameters = <String, dynamic>{
      'chat_id': chatId,
      'video': video,
    };

    if (duration != null) parameters['duration'] = duration;
    if (width != null) parameters['width'] = width;
    if (height != null) parameters['height'] = height;
    if (caption != null) parameters['caption'] = caption;
    if (parseMode != null) parameters['parse_mode'] = parseMode;
    if (supportsStreaming != null) {
      parameters['supports_streaming'] = supportsStreaming;
    }
    if (disableNotification != null) {
      parameters['disable_notification'] = disableNotification;
    }
    if (replyToMessageId != null) {
      parameters['reply_to_message_id'] = replyToMessageId;
    }

    return await _makeApiRequest('sendVideo', parameters);
  }

  /// Sends a voice message via Bot API.
  static Future<Map<String, dynamic>> sendVoice({
    required String chatId,
    required String voice,
    String? caption,
    String? parseMode,
    int? duration,
    bool? disableNotification,
    int? replyToMessageId,
  }) async {
    final parameters = <String, dynamic>{
      'chat_id': chatId,
      'voice': voice,
    };

    if (caption != null) parameters['caption'] = caption;
    if (parseMode != null) parameters['parse_mode'] = parseMode;
    if (duration != null) parameters['duration'] = duration;
    if (disableNotification != null) {
      parameters['disable_notification'] = disableNotification;
    }
    if (replyToMessageId != null) {
      parameters['reply_to_message_id'] = replyToMessageId;
    }

    return await _makeApiRequest('sendVoice', parameters);
  }

  /// Sends a video note via Bot API.
  static Future<Map<String, dynamic>> sendVideoNote({
    required String chatId,
    required String videoNote,
    int? duration,
    int? length,
    bool? disableNotification,
    int? replyToMessageId,
  }) async {
    final parameters = <String, dynamic>{
      'chat_id': chatId,
      'video_note': videoNote,
    };

    if (duration != null) parameters['duration'] = duration;
    if (length != null) parameters['length'] = length;
    if (disableNotification != null) {
      parameters['disable_notification'] = disableNotification;
    }
    if (replyToMessageId != null) {
      parameters['reply_to_message_id'] = replyToMessageId;
    }

    return await _makeApiRequest('sendVideoNote', parameters);
  }

  /// Sends an animation via Bot API.
  static Future<Map<String, dynamic>> sendAnimation({
    required String chatId,
    required String animation,
    int? duration,
    int? width,
    int? height,
    String? caption,
    String? parseMode,
    bool? disableNotification,
    int? replyToMessageId,
  }) async {
    final parameters = <String, dynamic>{
      'chat_id': chatId,
      'animation': animation,
    };

    if (duration != null) parameters['duration'] = duration;
    if (width != null) parameters['width'] = width;
    if (height != null) parameters['height'] = height;
    if (caption != null) parameters['caption'] = caption;
    if (parseMode != null) parameters['parse_mode'] = parseMode;
    if (disableNotification != null) {
      parameters['disable_notification'] = disableNotification;
    }
    if (replyToMessageId != null) {
      parameters['reply_to_message_id'] = replyToMessageId;
    }

    return await _makeApiRequest('sendAnimation', parameters);
  }

  /// Sends a sticker via Bot API.
  static Future<Map<String, dynamic>> sendSticker({
    required String chatId,
    required String sticker,
    bool? disableNotification,
    int? replyToMessageId,
  }) async {
    final parameters = <String, dynamic>{
      'chat_id': chatId,
      'sticker': sticker,
    };

    if (disableNotification != null) {
      parameters['disable_notification'] = disableNotification;
    }
    if (replyToMessageId != null) {
      parameters['reply_to_message_id'] = replyToMessageId;
    }

    return await _makeApiRequest('sendSticker', parameters);
  }

  /// Sends a contact via Bot API.
  static Future<Map<String, dynamic>> sendContact({
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

    return await _makeApiRequest('sendContact', parameters);
  }

  /// Sends a venue via Bot API.
  static Future<Map<String, dynamic>> sendVenue({
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

    return await _makeApiRequest('sendVenue', parameters);
  }

  /// Sends a poll via Bot API.
  static Future<Map<String, dynamic>> sendPoll({
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

    return await _makeApiRequest('sendPoll', parameters);
  }

  /// Sends a dice via Bot API.
  static Future<Map<String, dynamic>> sendDice({
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

    return await _makeApiRequest('sendDice', parameters);
  }

  /// Answers a callback query via Bot API.
  static Future<bool> answerCallbackQuery({
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

    final result = await _makeApiRequest('answerCallbackQuery', parameters);
    return result as bool;
  }

  /// Sets the bot's description via Bot API.
  static Future<bool> setMyDescription({
    String? description,
    String? languageCode,
  }) async {
    final parameters = <String, dynamic>{};

    if (description != null) parameters['description'] = description;
    if (languageCode != null) parameters['language_code'] = languageCode;

    final result = await _makeApiRequest('setMyDescription', parameters);
    return result as bool;
  }

  /// Gets the bot's description via Bot API.
  static Future<Map<String, dynamic>> getMyDescription({
    String? languageCode,
  }) async {
    final parameters = <String, dynamic>{};

    if (languageCode != null) parameters['language_code'] = languageCode;

    return await _makeApiRequest('getMyDescription', parameters);
  }

  /// Sets the bot's short description via Bot API.
  static Future<bool> setMyShortDescription({
    String? shortDescription,
    String? languageCode,
  }) async {
    final parameters = <String, dynamic>{};

    if (shortDescription != null) parameters['short_description'] = shortDescription;
    if (languageCode != null) parameters['language_code'] = languageCode;

    final result = await _makeApiRequest('setMyShortDescription', parameters);
    return result as bool;
  }

  /// Gets the bot's short description via Bot API.
  static Future<Map<String, dynamic>> getMyShortDescription({
    String? languageCode,
  }) async {
    final parameters = <String, dynamic>{};

    if (languageCode != null) parameters['language_code'] = languageCode;

    return await _makeApiRequest('getMyShortDescription', parameters);
  }

  /// Exports a chat invite link via Bot API.
  static Future<String> exportChatInviteLink({required String chatId}) async {
    final result = await _makeApiRequest('exportChatInviteLink', {
      'chat_id': chatId,
    });
    return result as String;
  }

  /// Creates a chat invite link via Bot API.
  static Future<Map<String, dynamic>> createChatInviteLink({
    required String chatId,
    String? name,
    int? expireDate,
    int? memberLimit,
    bool? createsJoinRequest,
  }) async {
    final parameters = <String, dynamic>{
      'chat_id': chatId,
    };

    if (name != null) parameters['name'] = name;
    if (expireDate != null) parameters['expire_date'] = expireDate;
    if (memberLimit != null) parameters['member_limit'] = memberLimit;
    if (createsJoinRequest != null) {
      parameters['creates_join_request'] = createsJoinRequest;
    }

    return await _makeApiRequest('createChatInviteLink', parameters);
  }

  /// Edits a chat invite link via Bot API.
  static Future<Map<String, dynamic>> editChatInviteLink({
    required String chatId,
    required String inviteLink,
    String? name,
    int? expireDate,
    int? memberLimit,
    bool? createsJoinRequest,
  }) async {
    final parameters = <String, dynamic>{
      'chat_id': chatId,
      'invite_link': inviteLink,
    };

    if (name != null) parameters['name'] = name;
    if (expireDate != null) parameters['expire_date'] = expireDate;
    if (memberLimit != null) parameters['member_limit'] = memberLimit;
    if (createsJoinRequest != null) {
      parameters['creates_join_request'] = createsJoinRequest;
    }

    return await _makeApiRequest('editChatInviteLink', parameters);
  }

  /// Revokes a chat invite link via Bot API.
  static Future<Map<String, dynamic>> revokeChatInviteLink({
    required String chatId,
    required String inviteLink,
  }) async {
    return await _makeApiRequest('revokeChatInviteLink', {
      'chat_id': chatId,
      'invite_link': inviteLink,
    });
  }

  /// Bans a chat member via Bot API.
  static Future<bool> banChatMember({
    required String chatId,
    required int userId,
    int? untilDate,
    bool? revokeMessages,
  }) async {
    final parameters = <String, dynamic>{
      'chat_id': chatId,
      'user_id': userId,
    };

    if (untilDate != null) parameters['until_date'] = untilDate;
    if (revokeMessages != null) parameters['revoke_messages'] = revokeMessages;

    final result = await _makeApiRequest('banChatMember', parameters);
    return result as bool;
  }

  /// Unbans a chat member via Bot API.
  static Future<bool> unbanChatMember({
    required String chatId,
    required int userId,
    bool? onlyIfBanned,
  }) async {
    final parameters = <String, dynamic>{
      'chat_id': chatId,
      'user_id': userId,
    };

    if (onlyIfBanned != null) parameters['only_if_banned'] = onlyIfBanned;

    final result = await _makeApiRequest('unbanChatMember', parameters);
    return result as bool;
  }

  /// Restricts a chat member via Bot API.
  static Future<bool> restrictChatMember({
    required String chatId,
    required int userId,
    required Map<String, bool> permissions,
    int? untilDate,
  }) async {
    final parameters = <String, dynamic>{
      'chat_id': chatId,
      'user_id': userId,
      'permissions': permissions,
    };

    if (untilDate != null) parameters['until_date'] = untilDate;

    final result = await _makeApiRequest('restrictChatMember', parameters);
    return result as bool;
  }

  /// Promotes a chat member via Bot API.
  static Future<bool> promoteChatMember({
    required String chatId,
    required int userId,
    bool? isAnonymous,
    bool? canManageChat,
    bool? canPostMessages,
    bool? canEditMessages,
    bool? canDeleteMessages,
    bool? canManageVideoChats,
    bool? canRestrictMembers,
    bool? canPromoteMembers,
    bool? canChangeInfo,
    bool? canInviteUsers,
    bool? canPinMessages,
  }) async {
    final parameters = <String, dynamic>{
      'chat_id': chatId,
      'user_id': userId,
    };

    if (isAnonymous != null) parameters['is_anonymous'] = isAnonymous;
    if (canManageChat != null) parameters['can_manage_chat'] = canManageChat;
    if (canPostMessages != null) parameters['can_post_messages'] = canPostMessages;
    if (canEditMessages != null) parameters['can_edit_messages'] = canEditMessages;
    if (canDeleteMessages != null) {
      parameters['can_delete_messages'] = canDeleteMessages;
    }
    if (canManageVideoChats != null) {
      parameters['can_manage_video_chats'] = canManageVideoChats;
    }
    if (canRestrictMembers != null) {
      parameters['can_restrict_members'] = canRestrictMembers;
    }
    if (canPromoteMembers != null) {
      parameters['can_promote_members'] = canPromoteMembers;
    }
    if (canChangeInfo != null) parameters['can_change_info'] = canChangeInfo;
    if (canInviteUsers != null) parameters['can_invite_users'] = canInviteUsers;
    if (canPinMessages != null) parameters['can_pin_messages'] = canPinMessages;

    final result = await _makeApiRequest('promoteChatMember', parameters);
    return result as bool;
  }

  /// Sets a custom title for a chat administrator via Bot API.
  static Future<bool> setChatAdministratorCustomTitle({
    required String chatId,
    required int userId,
    required String customTitle,
  }) async {
    final result = await _makeApiRequest('setChatAdministratorCustomTitle', {
      'chat_id': chatId,
      'user_id': userId,
      'custom_title': customTitle,
    });
    return result as bool;
  }

  /// Deletes a chat photo via Bot API.
  static Future<bool> deleteChatPhoto({required String chatId}) async {
    final result = await _makeApiRequest('deleteChatPhoto', {
      'chat_id': chatId,
    });
    return result as bool;
  }

  /// Sets a chat title via Bot API.
  static Future<bool> setChatTitle({
    required String chatId,
    required String title,
  }) async {
    final result = await _makeApiRequest('setChatTitle', {
      'chat_id': chatId,
      'title': title,
    });
    return result as bool;
  }

  /// Sets a chat description via Bot API.
  static Future<bool> setChatDescription({
    required String chatId,
    String? description,
  }) async {
    final parameters = <String, dynamic>{
      'chat_id': chatId,
    };

    if (description != null) parameters['description'] = description;

    final result = await _makeApiRequest('setChatDescription', parameters);
    return result as bool;
  }

  /// Pins a chat message via Bot API.
  static Future<bool> pinChatMessage({
    required String chatId,
    required int messageId,
    bool? disableNotification,
  }) async {
    final parameters = <String, dynamic>{
      'chat_id': chatId,
      'message_id': messageId,
    };

    if (disableNotification != null) {
      parameters['disable_notification'] = disableNotification;
    }

    final result = await _makeApiRequest('pinChatMessage', parameters);
    return result as bool;
  }

  /// Unpins a chat message via Bot API.
  static Future<bool> unpinChatMessage({
    required String chatId,
    int? messageId,
  }) async {
    final parameters = <String, dynamic>{
      'chat_id': chatId,
    };

    if (messageId != null) parameters['message_id'] = messageId;

    final result = await _makeApiRequest('unpinChatMessage', parameters);
    return result as bool;
  }

  /// Unpins all chat messages via Bot API.
  static Future<bool> unpinAllChatMessages({required String chatId}) async {
    final result = await _makeApiRequest('unpinAllChatMessages', {
      'chat_id': chatId,
    });
    return result as bool;
  }

  /// Leaves a chat via Bot API.
  static Future<bool> leaveChat({required String chatId}) async {
    final result = await _makeApiRequest('leaveChat', {
      'chat_id': chatId,
    });
    return result as bool;
  }

  /// Sets a chat photo via Bot API.
  static Future<bool> setChatPhoto({
    required String chatId,
    required String photo,
  }) async {
    final result = await _makeApiRequest('setChatPhoto', {
      'chat_id': chatId,
      'photo': photo,
    });
    return result as bool;
  }

  /// Sets a chat sticker set via Bot API.
  static Future<bool> setChatStickerSet({
    required String chatId,
    required String stickerSetName,
  }) async {
    final result = await _makeApiRequest('setChatStickerSet', {
      'chat_id': chatId,
      'sticker_set_name': stickerSetName,
    });
    return result as bool;
  }

  /// Deletes a chat sticker set via Bot API.
  static Future<bool> deleteChatStickerSet({required String chatId}) async {
    final result = await _makeApiRequest('deleteChatStickerSet', {
      'chat_id': chatId,
    });
    return result as bool;
  }

  /// Gets updates from the Bot API.
  static Future<List<Map<String, dynamic>>> getUpdates({
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

    final result = await _makeApiRequest('getUpdates', parameters);
    return List<Map<String, dynamic>>.from(result as List);
  }

  /// Sets a webhook for the Bot API.
  static Future<bool> setWebhook({
    required String url,
    String? certificate,
    String? ipAddress,
    int? maxConnections,
    List<String>? allowedUpdates,
    bool? dropPendingUpdates,
    String? secretToken,
  }) async {
    final parameters = <String, dynamic>{
      'url': url,
    };

    if (certificate != null) parameters['certificate'] = certificate;
    if (ipAddress != null) parameters['ip_address'] = ipAddress;
    if (maxConnections != null) parameters['max_connections'] = maxConnections;
    if (allowedUpdates != null) parameters['allowed_updates'] = allowedUpdates;
    if (dropPendingUpdates != null) {
      parameters['drop_pending_updates'] = dropPendingUpdates;
    }
    if (secretToken != null) parameters['secret_token'] = secretToken;

    final result = await _makeApiRequest('setWebhook', parameters);
    return result as bool;
  }

  /// Deletes the webhook for the Bot API.
  static Future<bool> deleteWebhook({bool? dropPendingUpdates}) async {
    final parameters = <String, dynamic>{};

    if (dropPendingUpdates != null) {
      parameters['drop_pending_updates'] = dropPendingUpdates;
    }

    final result = await _makeApiRequest('deleteWebhook', parameters);
    return result as bool;
  }

  /// Gets webhook info for the Bot API.
  static Future<Map<String, dynamic>> getWebhookInfo() async {
    return await _makeApiRequest('getWebhookInfo', {});
  }

  // ============================================================================
  // URL SCHEME METHODS (Original functionality)
  // ============================================================================

  /// Opens Telegram Web App with specified parameters.
  ///
  /// This method opens a Telegram Web App using the provided URL and parameters.
  ///
  /// Throws:
  /// - [ArgumentError] if the webAppUrl is empty.
  /// - [Exception] if the URL cannot be launched.
  ///
  /// Example usage:
  /// ```dart
  /// await openWebApp(
  ///   botUsername: 'mybot', 
  ///   webAppUrl: 'https://mywebapp.com',
  ///   startParam: 'param1'
  /// );
  /// ```
  static Future<void> openWebApp({
    required String botUsername,
    required String webAppUrl,
    String? startParam,
  }) async {
    if (botUsername.trim().isEmpty || webAppUrl.trim().isEmpty) {
      throw ArgumentError('Bot username and web app URL cannot be empty.');
    }

    String url = 'https://t.me/$botUsername?startapp=${Uri.encodeComponent(webAppUrl)}';
    if (startParam != null && startParam.trim().isNotEmpty) {
      url += '&startparam=${Uri.encodeComponent(startParam)}';
    }

    try {
      bool launched = await launchUrl(
        Uri.parse(url),
        mode: LaunchMode.externalNonBrowserApplication,
      );
      if (!launched) {
        throw Exception('Could not open Telegram Web App.');
      }
      if (kDebugMode) {
        print('Opened Telegram Web App: $url');
      }
    } catch (e) {
      throw Exception('Failed to open Telegram Web App: $e');
    }
  }

  /// Creates an inline keyboard button URL for Telegram bots.
  ///
  /// This is useful for creating inline keyboards in bot messages.
  ///
  /// Example usage:
  /// ```dart
  /// String buttonUrl = createInlineKeyboardUrl(
  ///   text: 'Visit Website', 
  ///   url: 'https://example.com'
  /// );
  /// ```
  static String createInlineKeyboardUrl({
    required String text,
    required String url,
  }) {
    if (text.trim().isEmpty || url.trim().isEmpty) {
      throw ArgumentError('Text and URL cannot be empty.');
    }
    
    return 'https://t.me/iv?url=${Uri.encodeComponent(url)}&rhash=${Uri.encodeComponent(text)}';
  }

  /// Generates a Telegram share URL for any content.
  ///
  /// This method creates a URL that can be used to share content on Telegram.
  ///
  /// Example usage:
  /// ```dart
  /// String shareUrl = generateShareUrl(
  ///   text: 'Check out this amazing content!',
  ///   url: 'https://example.com'
  /// );
  /// ```
  static String generateShareUrl({
    String? text,
    String? url,
  }) {
    if ((text == null || text.trim().isEmpty) && 
        (url == null || url.trim().isEmpty)) {
      throw ArgumentError('Either text or URL must be provided.');
    }

    String shareUrl = 'https://t.me/share/url?';
    
    if (url != null && url.trim().isNotEmpty) {
      shareUrl += 'url=${Uri.encodeComponent(url)}';
    }
    
    if (text != null && text.trim().isNotEmpty) {
      if (shareUrl.endsWith('?')) {
        shareUrl += 'text=${Uri.encodeComponent(text)}';
      } else {
        shareUrl += '&text=${Uri.encodeComponent(text)}';
      }
    }

    return shareUrl;
  }

  /// Opens a Telegram sticker set.
  ///
  /// Example usage:
  /// ```dart
  /// await openStickerSet(stickerSetName: 'AnimatedEmojies');
  /// ```
  static Future<void> openStickerSet({required String stickerSetName}) async {
    if (stickerSetName.trim().isEmpty) {
      throw ArgumentError('Sticker set name cannot be empty.');
    }

    Uri stickerUri = Uri.parse('https://t.me/addstickers/$stickerSetName');

    try {
      bool launched = await launchUrl(stickerUri,
          mode: LaunchMode.externalNonBrowserApplication);
      if (!launched) {
        throw Exception('Could not open sticker set $stickerSetName.');
      }
      if (kDebugMode) {
        print('Opened sticker set: $stickerSetName');
      }
    } catch (e) {
      throw Exception('Failed to open sticker set: $e');
    }
  }

  /// Opens a Telegram theme.
  ///
  /// Example usage:
  /// ```dart
  /// await openTheme(themeName: 'day');
  /// ```
  static Future<void> openTheme({required String themeName}) async {
    if (themeName.trim().isEmpty) {
      throw ArgumentError('Theme name cannot be empty.');
    }

    Uri themeUri = Uri.parse('https://t.me/addtheme/$themeName');

    try {
      bool launched = await launchUrl(themeUri,
          mode: LaunchMode.externalNonBrowserApplication);
      if (!launched) {
        throw Exception('Could not open theme $themeName.');
      }
      if (kDebugMode) {
        print('Opened theme: $themeName');
      }
    } catch (e) {
      throw Exception('Failed to open theme: $e');
    }
  }

  // ========== Missing Bot API Methods ==========

  /// Sends a location via Bot API.
  static Future<Map<String, dynamic>> sendLocation({
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

    return await _makeApiRequest('sendLocation', parameters);
  }

  /// Gets information about a chat via Bot API.
  static Future<Map<String, dynamic>> getChat({required String chatId}) async {
    return await _makeApiRequest('getChat', {'chat_id': chatId});
  }

  /// Sets the list of bot commands via Bot API.
  static Future<bool> setMyCommands({
    required List<Map<String, String>> commands,
    String? scope,
    String? languageCode,
  }) async {
    final parameters = <String, dynamic>{
      'commands': commands,
    };

    if (scope != null) parameters['scope'] = scope;
    if (languageCode != null) parameters['language_code'] = languageCode;

    final result = await _makeApiRequest('setMyCommands', parameters);
    return result as bool;
  }

  /// Gets the list of bot commands via Bot API.
  static Future<List<Map<String, dynamic>>> getMyCommands({
    String? scope,
    String? languageCode,
  }) async {
    final parameters = <String, dynamic>{};

    if (scope != null) parameters['scope'] = scope;
    if (languageCode != null) parameters['language_code'] = languageCode;

    final result = await _makeApiRequest('getMyCommands', parameters);
    return List<Map<String, dynamic>>.from(result as List);
  }

  /// Gets a chat administrator via Bot API.
  static Future<List<Map<String, dynamic>>> getChatAdministrators({
    required String chatId,
  }) async {
    final result = await _makeApiRequest('getChatAdministrators', {
      'chat_id': chatId,
    });
    return List<Map<String, dynamic>>.from(result as List);
  }

  /// Gets the number of members in a chat via Bot API.
  static Future<int> getChatMemberCount({required String chatId}) async {
    final result = await _makeApiRequest('getChatMemberCount', {
      'chat_id': chatId,
    });
    return result as int;
  }

  /// Gets information about a chat member via Bot API.
  static Future<Map<String, dynamic>> getChatMember({
    required String chatId,
    required int userId,
  }) async {
    return await _makeApiRequest('getChatMember', {
      'chat_id': chatId,
      'user_id': userId,
    });
  }

  /// Edits a message text via Bot API.
  static Future<Map<String, dynamic>> editMessageText({
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

    return await _makeApiRequest('editMessageText', parameters);
  }

  /// Deletes a message via Bot API.
  static Future<bool> deleteMessage({
    required String chatId,
    required int messageId,
  }) async {
    final result = await _makeApiRequest('deleteMessage', {
      'chat_id': chatId,
      'message_id': messageId,
    });
    return result as bool;
  }

  /// Gets user profile photos via Bot API.
  static Future<Map<String, dynamic>> getUserProfilePhotos({
    required int userId,
    int? offset,
    int? limit,
  }) async {
    final parameters = <String, dynamic>{
      'user_id': userId,
    };

    if (offset != null) parameters['offset'] = offset;
    if (limit != null) parameters['limit'] = limit;

    return await _makeApiRequest('getUserProfilePhotos', parameters);
  }

  /// Gets a file via Bot API.
  static Future<Map<String, dynamic>> getFile({required String fileId}) async {
    return await _makeApiRequest('getFile', {'file_id': fileId});
  }
}
