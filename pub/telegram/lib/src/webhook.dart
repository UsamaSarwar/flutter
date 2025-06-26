import 'messaging.dart';

/// Webhook functionality for Telegram Bot API
class TelegramWebhook {
  /// Sets a webhook via Bot API.
  static Future<bool> setWebhook({
    required String botToken,
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
    if (dropPendingUpdates != null) parameters['drop_pending_updates'] = dropPendingUpdates;
    if (secretToken != null) parameters['secret_token'] = secretToken;

    final result = await TelegramMessaging.makeApiRequest(botToken, 'setWebhook', parameters);
    return result as bool;
  }

  /// Deletes a webhook via Bot API.
  static Future<bool> deleteWebhook({
    required String botToken,
    bool? dropPendingUpdates,
  }) async {
    final parameters = <String, dynamic>{};

    if (dropPendingUpdates != null) parameters['drop_pending_updates'] = dropPendingUpdates;

    final result = await TelegramMessaging.makeApiRequest(botToken, 'deleteWebhook', parameters);
    return result as bool;
  }

  /// Gets webhook information via Bot API.
  static Future<Map<String, dynamic>> getWebhookInfo({
    required String botToken,
  }) async {
    return await TelegramMessaging.makeApiRequest(botToken, 'getWebhookInfo', {});
  }
}
