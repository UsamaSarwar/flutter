import 'messaging.dart';

/// Media functionality for Telegram Bot API
class TelegramMedia {
  /// Sends a photo via Bot API.
  static Future<Map<String, dynamic>> sendPhoto({
    required String botToken,
    required String chatId,
    required String photo,
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

    return await TelegramMessaging.makeApiRequest(botToken, 'sendPhoto', parameters);
  }

  /// Sends an audio file via Bot API.
  static Future<Map<String, dynamic>> sendAudio({
    required String botToken,
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

    return await TelegramMessaging.makeApiRequest(botToken, 'sendAudio', parameters);
  }

  /// Sends a document via Bot API.
  static Future<Map<String, dynamic>> sendDocument({
    required String botToken,
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

    return await TelegramMessaging.makeApiRequest(botToken, 'sendDocument', parameters);
  }

  /// Sends a video via Bot API.
  static Future<Map<String, dynamic>> sendVideo({
    required String botToken,
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

    return await TelegramMessaging.makeApiRequest(botToken, 'sendVideo', parameters);
  }

  /// Sends a voice message via Bot API.
  static Future<Map<String, dynamic>> sendVoice({
    required String botToken,
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

    return await TelegramMessaging.makeApiRequest(botToken, 'sendVoice', parameters);
  }

  /// Sends a video note via Bot API.
  static Future<Map<String, dynamic>> sendVideoNote({
    required String botToken,
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

    return await TelegramMessaging.makeApiRequest(botToken, 'sendVideoNote', parameters);
  }

  /// Sends an animation via Bot API.
  static Future<Map<String, dynamic>> sendAnimation({
    required String botToken,
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

    return await TelegramMessaging.makeApiRequest(botToken, 'sendAnimation', parameters);
  }

  /// Sends a sticker via Bot API.
  static Future<Map<String, dynamic>> sendSticker({
    required String botToken,
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

    return await TelegramMessaging.makeApiRequest(botToken, 'sendSticker', parameters);
  }

  /// Gets user profile photos via Bot API.
  static Future<Map<String, dynamic>> getUserProfilePhotos({
    required String botToken,
    required int userId,
    int? offset,
    int? limit,
  }) async {
    final parameters = <String, dynamic>{
      'user_id': userId,
    };

    if (offset != null) parameters['offset'] = offset;
    if (limit != null) parameters['limit'] = limit;

    return await TelegramMessaging.makeApiRequest(botToken, 'getUserProfilePhotos', parameters);
  }

  /// Gets a file via Bot API.
  static Future<Map<String, dynamic>> getFile({
    required String botToken,
    required String fileId,
  }) async {
    return await TelegramMessaging.makeApiRequest(botToken, 'getFile', {'file_id': fileId});
  }
}
