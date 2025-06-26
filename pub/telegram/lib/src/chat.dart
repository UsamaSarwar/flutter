import 'messaging.dart';

/// Chat management functionality for Telegram Bot API
class TelegramChat {
  /// Gets information about a chat via Bot API.
  static Future<Map<String, dynamic>> getChat({
    required String botToken,
    required String chatId,
  }) async {
    return await TelegramMessaging.makeApiRequest(botToken, 'getChat', {'chat_id': chatId});
  }

  /// Exports a chat invite link via Bot API.
  static Future<String> exportChatInviteLink({
    required String botToken,
    required String chatId,
  }) async {
    final result = await TelegramMessaging.makeApiRequest(botToken, 'exportChatInviteLink', {
      'chat_id': chatId,
    });
    return result as String;
  }

  /// Creates a chat invite link via Bot API.
  static Future<Map<String, dynamic>> createChatInviteLink({
    required String botToken,
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

    return await TelegramMessaging.makeApiRequest(botToken, 'createChatInviteLink', parameters);
  }

  /// Edits a chat invite link via Bot API.
  static Future<Map<String, dynamic>> editChatInviteLink({
    required String botToken,
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

    return await TelegramMessaging.makeApiRequest(botToken, 'editChatInviteLink', parameters);
  }

  /// Revokes a chat invite link via Bot API.
  static Future<Map<String, dynamic>> revokeChatInviteLink({
    required String botToken,
    required String chatId,
    required String inviteLink,
  }) async {
    return await TelegramMessaging.makeApiRequest(botToken, 'revokeChatInviteLink', {
      'chat_id': chatId,
      'invite_link': inviteLink,
    });
  }

  /// Deletes a chat photo via Bot API.
  static Future<bool> deleteChatPhoto({
    required String botToken,
    required String chatId,
  }) async {
    final result = await TelegramMessaging.makeApiRequest(botToken, 'deleteChatPhoto', {
      'chat_id': chatId,
    });
    return result as bool;
  }

  /// Sets a chat title via Bot API.
  static Future<bool> setChatTitle({
    required String botToken,
    required String chatId,
    required String title,
  }) async {
    final result = await TelegramMessaging.makeApiRequest(botToken, 'setChatTitle', {
      'chat_id': chatId,
      'title': title,
    });
    return result as bool;
  }

  /// Sets a chat description via Bot API.
  static Future<bool> setChatDescription({
    required String botToken,
    required String chatId,
    String? description,
  }) async {
    final parameters = <String, dynamic>{
      'chat_id': chatId,
    };

    if (description != null) parameters['description'] = description;

    final result = await TelegramMessaging.makeApiRequest(botToken, 'setChatDescription', parameters);
    return result as bool;
  }

  /// Pins a chat message via Bot API.
  static Future<bool> pinChatMessage({
    required String botToken,
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

    final result = await TelegramMessaging.makeApiRequest(botToken, 'pinChatMessage', parameters);
    return result as bool;
  }

  /// Unpins a chat message via Bot API.
  static Future<bool> unpinChatMessage({
    required String botToken,
    required String chatId,
    int? messageId,
  }) async {
    final parameters = <String, dynamic>{
      'chat_id': chatId,
    };

    if (messageId != null) parameters['message_id'] = messageId;

    final result = await TelegramMessaging.makeApiRequest(botToken, 'unpinChatMessage', parameters);
    return result as bool;
  }

  /// Unpins all chat messages via Bot API.
  static Future<bool> unpinAllChatMessages({
    required String botToken,
    required String chatId,
  }) async {
    final result = await TelegramMessaging.makeApiRequest(botToken, 'unpinAllChatMessages', {
      'chat_id': chatId,
    });
    return result as bool;
  }

  /// Leaves a chat via Bot API.
  static Future<bool> leaveChat({
    required String botToken,
    required String chatId,
  }) async {
    final result = await TelegramMessaging.makeApiRequest(botToken, 'leaveChat', {
      'chat_id': chatId,
    });
    return result as bool;
  }

  /// Gets the number of members in a chat via Bot API.
  static Future<int> getChatMemberCount({
    required String botToken,
    required String chatId,
  }) async {
    final result = await TelegramMessaging.makeApiRequest(botToken, 'getChatMemberCount', {
      'chat_id': chatId,
    });
    return result as int;
  }

  /// Gets information about a chat member via Bot API.
  static Future<Map<String, dynamic>> getChatMember({
    required String botToken,
    required String chatId,
    required int userId,
  }) async {
    return await TelegramMessaging.makeApiRequest(botToken, 'getChatMember', {
      'chat_id': chatId,
      'user_id': userId,
    });
  }

  /// Gets a chat administrator via Bot API.
  static Future<List<Map<String, dynamic>>> getChatAdministrators({
    required String botToken,
    required String chatId,
  }) async {
    final result = await TelegramMessaging.makeApiRequest(botToken, 'getChatAdministrators', {
      'chat_id': chatId,
    });
    return List<Map<String, dynamic>>.from(result as List);
  }
}
