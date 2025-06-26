library telegram;

import 'src/bot_config.dart';
import 'src/chat.dart';
import 'src/media.dart';
import 'src/members.dart';
import 'src/messaging.dart';
// Import all modules for the main Telegram class
import 'src/url_schemes.dart';
import 'src/webhook.dart';

export 'src/bot_config.dart';
export 'src/chat.dart';
export 'src/media.dart';
export 'src/members.dart';
export 'src/messaging.dart';
// Export all modules
export 'src/url_schemes.dart';
export 'src/webhook.dart';

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

  // ========== URL Schemes Methods ==========

  /// Copies the Telegram message link to the clipboard.
  static Future<void> copyLinkToClipboard({
    required String username,
    String? message,
  }) async {
    return TelegramUrlSchemes.copyLinkToClipboard(
      username: username,
      message: message,
    );
  }

  /// Returns the Telegram message link as a String.
  static String getLink({
    required String username,
    String? message,
  }) {
    return TelegramUrlSchemes.getLink(
      username: username,
      message: message,
    );
  }

  /// Sends a message via Telegram.
  static Future<void> send({
    required String username,
    String? message,
  }) async {
    return TelegramUrlSchemes.send(
      username: username,
      message: message,
    );
  }

  /// Checks if Telegram is installed on the device.
  static Future<bool> isTelegramInstalled() async {
    return TelegramUrlSchemes.isTelegramInstalled();
  }

  /// Opens a chat with the given username using Telegram's custom URL scheme.
  static Future<void> openChat({required String username}) async {
    return TelegramUrlSchemes.openChat(username: username);
  }

  /// Joins a Telegram channel or group using an invite link.
  static Future<void> joinChannel({required String inviteLink}) async {
    return TelegramUrlSchemes.joinChannel(inviteLink: inviteLink);
  }

  /// Shares a contact via Telegram.
  static Future<void> shareContact({
    required String phone,
    required String firstName,
    String? lastName,
  }) async {
    return TelegramUrlSchemes.shareContact(
      phone: phone,
      firstName: firstName,
      lastName: lastName,
    );
  }

  /// Opens a Telegram group by its username.
  static Future<void> openGroup({required String username}) async {
    return TelegramUrlSchemes.openGroup(username: username);
  }

  /// Sends a media file via Telegram.
  static Future<void> sendMedia({required String filePath}) async {
    return TelegramUrlSchemes.sendMedia(filePath: filePath);
  }

  /// Checks if a Telegram username exists.
  static Future<bool> checkUsernameAvailability({required String username}) async {
    return TelegramUrlSchemes.checkUsernameAvailability(username: username);
  }

  /// Opens a Telegram bot using its username.
  static Future<void> openBot({required String username}) async {
    return TelegramUrlSchemes.openBot(username: username);
  }

  /// Generates a share URL for content.
  static String generateShareUrl({
    String? text,
    String? url,
  }) {
    return TelegramUrlSchemes.generateShareUrl(text: text, url: url);
  }

  /// Opens a Telegram sticker set.
  static Future<void> openStickerSet({required String stickerSetName}) async {
    return TelegramUrlSchemes.openStickerSet(stickerSetName: stickerSetName);
  }

  /// Opens a Telegram theme.
  static Future<void> openTheme({required String themeName}) async {
    return TelegramUrlSchemes.openTheme(themeName: themeName);
  }

  /// Opens a Telegram Web App.
  static Future<void> openWebApp({
    required String botUsername,
    required String webAppUrl,
    String? startParam,
  }) async {
    return TelegramUrlSchemes.openWebApp(
      botUsername: botUsername,
      webAppUrl: webAppUrl,
      startParam: startParam,
    );
  }

  /// Creates an inline keyboard URL for Telegram.
  static String createInlineKeyboardUrl({
    required String text,
    required String url,
  }) {
    return TelegramUrlSchemes.createInlineKeyboardUrl(
      text: text,
      url: url,
    );
  }

  // ========== Bot API Methods ==========

  /// Helper method to ensure bot token is set
  static void _ensureBotToken() {
    if (_botToken == null || _botToken!.trim().isEmpty) {
      throw Exception('Bot token not set. Call Telegram.setBotToken() first.');
    }
  }

  /// Gets information about the bot via Bot API.
  static Future<Map<String, dynamic>> getMe() async {
    if (_botToken == null || _botToken!.trim().isEmpty) {
      throw Exception('Bot token not set. Call Telegram.setBotToken() first.');
    }
    return TelegramMessaging.getMe(_botToken!);
  }

  /// Sends a message via Bot API.
  static Future<Map<String, dynamic>> sendMessage({
    required String chatId,
    required String text,
    String? parseMode,
    bool? disableWebPagePreview,
    bool? disableNotification,
    int? replyToMessageId,
  }) async {
    _ensureBotToken();
    return TelegramMessaging.sendMessage(
      botToken: _botToken!,
      chatId: chatId,
      text: text,
      parseMode: parseMode,
      disableWebPagePreview: disableWebPagePreview,
      disableNotification: disableNotification,
      replyToMessageId: replyToMessageId,
    );
  }

  /// Forwards a message via Bot API.
  static Future<Map<String, dynamic>> forwardMessage({
    required String chatId,
    required String fromChatId,
    required int messageId,
    bool? disableNotification,
  }) async {
    _ensureBotToken();
    return TelegramMessaging.forwardMessage(
      botToken: _botToken!,
      chatId: chatId,
      fromChatId: fromChatId,
      messageId: messageId,
      disableNotification: disableNotification,
    );
  }

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
    _ensureBotToken();
    return TelegramMessaging.sendLocation(
      botToken: _botToken!,
      chatId: chatId,
      latitude: latitude,
      longitude: longitude,
      horizontalAccuracy: horizontalAccuracy,
      livePeriod: livePeriod,
      heading: heading,
      proximityAlertRadius: proximityAlertRadius,
      disableNotification: disableNotification,
      replyToMessageId: replyToMessageId,
    );
  }

  // ========== Media Methods ==========

  /// Sends a photo via Bot API.
  static Future<Map<String, dynamic>> sendPhoto({
    required String chatId,
    required String photo,
    String? caption,
    String? parseMode,
    bool? disableNotification,
    int? replyToMessageId,
  }) async {
    _ensureBotToken();
    return TelegramMedia.sendPhoto(
      botToken: _botToken!,
      chatId: chatId,
      photo: photo,
      caption: caption,
      parseMode: parseMode,
      disableNotification: disableNotification,
      replyToMessageId: replyToMessageId,
    );
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
    _ensureBotToken();
    return TelegramMedia.sendAudio(
      botToken: _botToken!,
      chatId: chatId,
      audio: audio,
      caption: caption,
      parseMode: parseMode,
      duration: duration,
      performer: performer,
      title: title,
      disableNotification: disableNotification,
      replyToMessageId: replyToMessageId,
    );
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
    _ensureBotToken();
    return TelegramMedia.sendDocument(
      botToken: _botToken!,
      chatId: chatId,
      document: document,
      caption: caption,
      parseMode: parseMode,
      disableNotification: disableNotification,
      replyToMessageId: replyToMessageId,
    );
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
    _ensureBotToken();
    return TelegramMedia.sendVideo(
      botToken: _botToken!,
      chatId: chatId,
      video: video,
      duration: duration,
      width: width,
      height: height,
      caption: caption,
      parseMode: parseMode,
      supportsStreaming: supportsStreaming,
      disableNotification: disableNotification,
      replyToMessageId: replyToMessageId,
    );
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
    _ensureBotToken();
    return TelegramMedia.sendVoice(
      botToken: _botToken!,
      chatId: chatId,
      voice: voice,
      caption: caption,
      parseMode: parseMode,
      duration: duration,
      disableNotification: disableNotification,
      replyToMessageId: replyToMessageId,
    );
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
    _ensureBotToken();
    return TelegramMedia.sendVideoNote(
      botToken: _botToken!,
      chatId: chatId,
      videoNote: videoNote,
      duration: duration,
      length: length,
      disableNotification: disableNotification,
      replyToMessageId: replyToMessageId,
    );
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
    _ensureBotToken();
    return TelegramMedia.sendAnimation(
      botToken: _botToken!,
      chatId: chatId,
      animation: animation,
      duration: duration,
      width: width,
      height: height,
      caption: caption,
      parseMode: parseMode,
      disableNotification: disableNotification,
      replyToMessageId: replyToMessageId,
    );
  }

  /// Sends a sticker via Bot API.
  static Future<Map<String, dynamic>> sendSticker({
    required String chatId,
    required String sticker,
    bool? disableNotification,
    int? replyToMessageId,
  }) async {
    _ensureBotToken();
    return TelegramMedia.sendSticker(
      botToken: _botToken!,
      chatId: chatId,
      sticker: sticker,
      disableNotification: disableNotification,
      replyToMessageId: replyToMessageId,
    );
  }

  // ========== Chat Management Methods ==========

  /// Gets information about a chat via Bot API.
  static Future<Map<String, dynamic>> getChat({required String chatId}) async {
    _ensureBotToken();
    return TelegramChat.getChat(
      botToken: _botToken!,
      chatId: chatId,
    );
  }

  /// Exports a chat invite link via Bot API.
  static Future<String> exportChatInviteLink({required String chatId}) async {
    _ensureBotToken();
    return TelegramChat.exportChatInviteLink(
      botToken: _botToken!,
      chatId: chatId,
    );
  }

  /// Creates a chat invite link via Bot API.
  static Future<Map<String, dynamic>> createChatInviteLink({
    required String chatId,
    String? name,
    int? expireDate,
    int? memberLimit,
    bool? createsJoinRequest,
  }) async {
    _ensureBotToken();
    return TelegramChat.createChatInviteLink(
      botToken: _botToken!,
      chatId: chatId,
      name: name,
      expireDate: expireDate,
      memberLimit: memberLimit,
      createsJoinRequest: createsJoinRequest,
    );
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
    _ensureBotToken();
    return TelegramChat.editChatInviteLink(
      botToken: _botToken!,
      chatId: chatId,
      inviteLink: inviteLink,
      name: name,
      expireDate: expireDate,
      memberLimit: memberLimit,
      createsJoinRequest: createsJoinRequest,
    );
  }

  /// Revokes a chat invite link via Bot API.
  static Future<Map<String, dynamic>> revokeChatInviteLink({
    required String chatId,
    required String inviteLink,
  }) async {
    _ensureBotToken();
    return TelegramChat.revokeChatInviteLink(
      botToken: _botToken!,
      chatId: chatId,
      inviteLink: inviteLink,
    );
  }

  // ========== Bot Configuration Methods ==========

  /// Sets the list of bot commands via Bot API.
  static Future<bool> setMyCommands({
    required List<Map<String, String>> commands,
    String? scope,
    String? languageCode,
  }) async {
    _ensureBotToken();
    return TelegramBotConfig.setMyCommands(
      botToken: _botToken!,
      commands: commands,
      scope: scope,
      languageCode: languageCode,
    );
  }

  /// Gets the list of bot commands via Bot API.
  static Future<List<Map<String, dynamic>>> getMyCommands({
    String? scope,
    String? languageCode,
  }) async {
    _ensureBotToken();
    return TelegramBotConfig.getMyCommands(
      botToken: _botToken!,
      scope: scope,
      languageCode: languageCode,
    );
  }

  // ========== Additional Bot API Methods ==========

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
    _ensureBotToken();
    return TelegramMessaging.sendContact(
      botToken: _botToken!,
      chatId: chatId,
      phoneNumber: phoneNumber,
      firstName: firstName,
      lastName: lastName,
      vcard: vcard,
      disableNotification: disableNotification,
      replyToMessageId: replyToMessageId,
    );
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
    _ensureBotToken();
    return TelegramMessaging.sendVenue(
      botToken: _botToken!,
      chatId: chatId,
      latitude: latitude,
      longitude: longitude,
      title: title,
      address: address,
      foursquareId: foursquareId,
      foursquareType: foursquareType,
      googlePlaceId: googlePlaceId,
      googlePlaceType: googlePlaceType,
      disableNotification: disableNotification,
      replyToMessageId: replyToMessageId,
    );
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
    _ensureBotToken();
    return TelegramMessaging.sendPoll(
      botToken: _botToken!,
      chatId: chatId,
      question: question,
      options: options,
      isAnonymous: isAnonymous,
      type: type,
      allowsMultipleAnswers: allowsMultipleAnswers,
      correctOptionId: correctOptionId,
      explanation: explanation,
      explanationParseMode: explanationParseMode,
      openPeriod: openPeriod,
      closeDate: closeDate,
      isClosed: isClosed,
      disableNotification: disableNotification,
      replyToMessageId: replyToMessageId,
    );
  }

  /// Sends a dice via Bot API.
  static Future<Map<String, dynamic>> sendDice({
    required String chatId,
    String? emoji,
    bool? disableNotification,
    int? replyToMessageId,
  }) async {
    _ensureBotToken();
    return TelegramMessaging.sendDice(
      botToken: _botToken!,
      chatId: chatId,
      emoji: emoji,
      disableNotification: disableNotification,
      replyToMessageId: replyToMessageId,
    );
  }

  /// Answers a callback query via Bot API.
  static Future<bool> answerCallbackQuery({
    required String callbackQueryId,
    String? text,
    bool? showAlert,
    String? url,
    int? cacheTime,
  }) async {
    _ensureBotToken();
    return TelegramMessaging.answerCallbackQuery(
      botToken: _botToken!,
      callbackQueryId: callbackQueryId,
      text: text,
      showAlert: showAlert,
      url: url,
      cacheTime: cacheTime,
    );
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
    _ensureBotToken();
    return TelegramMessaging.editMessageText(
      botToken: _botToken!,
      chatId: chatId,
      messageId: messageId,
      inlineMessageId: inlineMessageId,
      text: text,
      parseMode: parseMode,
      disableWebPagePreview: disableWebPagePreview,
    );
  }

  /// Deletes a message via Bot API.
  static Future<bool> deleteMessage({
    required String chatId,
    required int messageId,
  }) async {
    _ensureBotToken();
    return TelegramMessaging.deleteMessage(
      botToken: _botToken!,
      chatId: chatId,
      messageId: messageId,
    );
  }

  /// Gets updates via Bot API.
  static Future<List<Map<String, dynamic>>> getUpdates({
    int? offset,
    int? limit,
    int? timeout,
    List<String>? allowedUpdates,
  }) async {
    _ensureBotToken();
    return TelegramMessaging.getUpdates(
      botToken: _botToken!,
      offset: offset,
      limit: limit,
      timeout: timeout,
      allowedUpdates: allowedUpdates,
    );
  }

  /// Gets user profile photos via Bot API.
  static Future<Map<String, dynamic>> getUserProfilePhotos({
    required int userId,
    int? offset,
    int? limit,
  }) async {
    _ensureBotToken();
    return TelegramMedia.getUserProfilePhotos(
      botToken: _botToken!,
      userId: userId,
      offset: offset,
      limit: limit,
    );
  }

  /// Gets a file via Bot API.
  static Future<Map<String, dynamic>> getFile({required String fileId}) async {
    _ensureBotToken();
    return TelegramMedia.getFile(
      botToken: _botToken!,
      fileId: fileId,
    );
  }

  // ========== Additional Chat Management Methods ==========

  /// Gets the number of members in a chat via Bot API.
  static Future<int> getChatMemberCount({required String chatId}) async {
    _ensureBotToken();
    return TelegramChat.getChatMemberCount(
      botToken: _botToken!,
      chatId: chatId,
    );
  }

  /// Gets information about a chat member via Bot API.
  static Future<Map<String, dynamic>> getChatMember({
    required String chatId,
    required int userId,
  }) async {
    _ensureBotToken();
    return TelegramChat.getChatMember(
      botToken: _botToken!,
      chatId: chatId,
      userId: userId,
    );
  }

  /// Gets a chat administrator via Bot API.
  static Future<List<Map<String, dynamic>>> getChatAdministrators({
    required String chatId,
  }) async {
    _ensureBotToken();
    return TelegramChat.getChatAdministrators(
      botToken: _botToken!,
      chatId: chatId,
    );
  }

  // ========== Member Management Methods ==========

  /// Bans a chat member via Bot API.
  static Future<bool> banChatMember({
    required String chatId,
    required int userId,
    int? untilDate,
    bool? revokeMessages,
  }) async {
    _ensureBotToken();
    return TelegramMembers.banChatMember(
      botToken: _botToken!,
      chatId: chatId,
      userId: userId,
      untilDate: untilDate,
      revokeMessages: revokeMessages,
    );
  }

  /// Unbans a chat member via Bot API.
  static Future<bool> unbanChatMember({
    required String chatId,
    required int userId,
    bool? onlyIfBanned,
  }) async {
    _ensureBotToken();
    return TelegramMembers.unbanChatMember(
      botToken: _botToken!,
      chatId: chatId,
      userId: userId,
      onlyIfBanned: onlyIfBanned,
    );
  }

  /// Restricts a chat member via Bot API.
  static Future<bool> restrictChatMember({
    required String chatId,
    required int userId,
    required Map<String, bool> permissions,
    int? untilDate,
  }) async {
    _ensureBotToken();
    return TelegramMembers.restrictChatMember(
      botToken: _botToken!,
      chatId: chatId,
      userId: userId,
      permissions: permissions,
      untilDate: untilDate,
    );
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
    _ensureBotToken();
    return TelegramMembers.promoteChatMember(
      botToken: _botToken!,
      chatId: chatId,
      userId: userId,
      isAnonymous: isAnonymous,
      canManageChat: canManageChat,
      canPostMessages: canPostMessages,
      canEditMessages: canEditMessages,
      canDeleteMessages: canDeleteMessages,
      canManageVideoChats: canManageVideoChats,
      canRestrictMembers: canRestrictMembers,
      canPromoteMembers: canPromoteMembers,
      canChangeInfo: canChangeInfo,
      canInviteUsers: canInviteUsers,
      canPinMessages: canPinMessages,
    );
  }

  /// Sets a custom title for a chat administrator via Bot API.
  static Future<bool> setChatAdministratorCustomTitle({
    required String chatId,
    required int userId,
    required String customTitle,
  }) async {
    _ensureBotToken();
    return TelegramMembers.setChatAdministratorCustomTitle(
      botToken: _botToken!,
      chatId: chatId,
      userId: userId,
      customTitle: customTitle,
    );
  }

  // ========== Webhook Methods ==========

  /// Sets a webhook via Bot API.
  static Future<bool> setWebhook({
    required String url,
    String? certificate,
    String? ipAddress,
    int? maxConnections,
    List<String>? allowedUpdates,
    bool? dropPendingUpdates,
    String? secretToken,
  }) async {
    _ensureBotToken();
    return TelegramWebhook.setWebhook(
      botToken: _botToken!,
      url: url,
      certificate: certificate,
      ipAddress: ipAddress,
      maxConnections: maxConnections,
      allowedUpdates: allowedUpdates,
      dropPendingUpdates: dropPendingUpdates,
      secretToken: secretToken,
    );
  }

  /// Deletes a webhook via Bot API.
  static Future<bool> deleteWebhook({bool? dropPendingUpdates}) async {
    _ensureBotToken();
    return TelegramWebhook.deleteWebhook(
      botToken: _botToken!,
      dropPendingUpdates: dropPendingUpdates,
    );
  }

  /// Gets webhook information via Bot API.
  static Future<Map<String, dynamic>> getWebhookInfo() async {
    _ensureBotToken();
    return TelegramWebhook.getWebhookInfo(botToken: _botToken!);
  }

  // ========== Additional Bot Configuration Methods ==========

  /// Sets the bot's description via Bot API.
  static Future<bool> setMyDescription({
    String? description,
    String? languageCode,
  }) async {
    _ensureBotToken();
    return TelegramBotConfig.setMyDescription(
      botToken: _botToken!,
      description: description,
      languageCode: languageCode,
    );
  }

  /// Gets the bot's description via Bot API.
  static Future<Map<String, dynamic>> getMyDescription({
    String? languageCode,
  }) async {
    _ensureBotToken();
    return TelegramBotConfig.getMyDescription(
      botToken: _botToken!,
      languageCode: languageCode,
    );
  }

  /// Sets the bot's short description via Bot API.
  static Future<bool> setMyShortDescription({
    String? shortDescription,
    String? languageCode,
  }) async {
    _ensureBotToken();
    return TelegramBotConfig.setMyShortDescription(
      botToken: _botToken!,
      shortDescription: shortDescription,
      languageCode: languageCode,
    );
  }

  /// Gets the bot's short description via Bot API.
  static Future<Map<String, dynamic>> getMyShortDescription({
    String? languageCode,
  }) async {
    _ensureBotToken();
    return TelegramBotConfig.getMyShortDescription(
      botToken: _botToken!,
      languageCode: languageCode,
    );
  }

  // ========== Additional Chat Management Methods ==========

  /// Deletes a chat photo via Bot API.
  static Future<bool> deleteChatPhoto({required String chatId}) async {
    _ensureBotToken();
    return TelegramChat.deleteChatPhoto(
      botToken: _botToken!,
      chatId: chatId,
    );
  }

  /// Sets a chat title via Bot API.
  static Future<bool> setChatTitle({
    required String chatId,
    required String title,
  }) async {
    _ensureBotToken();
    return TelegramChat.setChatTitle(
      botToken: _botToken!,
      chatId: chatId,
      title: title,
    );
  }

  /// Sets a chat description via Bot API.
  static Future<bool> setChatDescription({
    required String chatId,
    String? description,
  }) async {
    _ensureBotToken();
    return TelegramChat.setChatDescription(
      botToken: _botToken!,
      chatId: chatId,
      description: description,
    );
  }

  /// Pins a chat message via Bot API.
  static Future<bool> pinChatMessage({
    required String chatId,
    required int messageId,
    bool? disableNotification,
  }) async {
    _ensureBotToken();
    return TelegramChat.pinChatMessage(
      botToken: _botToken!,
      chatId: chatId,
      messageId: messageId,
      disableNotification: disableNotification,
    );
  }

  /// Unpins a chat message via Bot API.
  static Future<bool> unpinChatMessage({
    required String chatId,
    int? messageId,
  }) async {
    _ensureBotToken();
    return TelegramChat.unpinChatMessage(
      botToken: _botToken!,
      chatId: chatId,
      messageId: messageId,
    );
  }

  /// Unpins all chat messages via Bot API.
  static Future<bool> unpinAllChatMessages({
    required String chatId,
  }) async {
    _ensureBotToken();
    return TelegramChat.unpinAllChatMessages(
      botToken: _botToken!,
      chatId: chatId,
    );
  }

  /// Leaves a chat via Bot API.
  static Future<bool> leaveChat({required String chatId}) async {
    _ensureBotToken();
    return TelegramChat.leaveChat(
      botToken: _botToken!,
      chatId: chatId,
    );
  }
}
