import 'messaging.dart';

/// Chat member management functionality for Telegram Bot API
class TelegramMembers {
  /// Bans a chat member via Bot API.
  static Future<bool> banChatMember({
    required String botToken,
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

    final result = await TelegramMessaging.makeApiRequest(botToken, 'banChatMember', parameters);
    return result as bool;
  }

  /// Unbans a chat member via Bot API.
  static Future<bool> unbanChatMember({
    required String botToken,
    required String chatId,
    required int userId,
    bool? onlyIfBanned,
  }) async {
    final parameters = <String, dynamic>{
      'chat_id': chatId,
      'user_id': userId,
    };

    if (onlyIfBanned != null) parameters['only_if_banned'] = onlyIfBanned;

    final result = await TelegramMessaging.makeApiRequest(botToken, 'unbanChatMember', parameters);
    return result as bool;
  }

  /// Restricts a chat member via Bot API.
  static Future<bool> restrictChatMember({
    required String botToken,
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

    final result = await TelegramMessaging.makeApiRequest(botToken, 'restrictChatMember', parameters);
    return result as bool;
  }

  /// Promotes a chat member via Bot API.
  static Future<bool> promoteChatMember({
    required String botToken,
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

    final result = await TelegramMessaging.makeApiRequest(botToken, 'promoteChatMember', parameters);
    return result as bool;
  }

  /// Sets a custom title for a chat administrator via Bot API.
  static Future<bool> setChatAdministratorCustomTitle({
    required String botToken,
    required String chatId,
    required int userId,
    required String customTitle,
  }) async {
    final result = await TelegramMessaging.makeApiRequest(botToken, 'setChatAdministratorCustomTitle', {
      'chat_id': chatId,
      'user_id': userId,
      'custom_title': customTitle,
    });
    return result as bool;
  }
}
