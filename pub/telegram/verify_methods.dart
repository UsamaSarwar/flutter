// Verification script to check that all required methods are available
// This is a compile-time check - if it compiles, all methods exist

import 'lib/telegram.dart';

void main() {
  // Set bot token (required for Bot API methods)
  Telegram.setBotToken('dummy_token_for_verification');

  // Verify missing methods from example app are now available:

  // 1. sendLocation
  Telegram.sendLocation(
    chatId: 'test',
    latitude: 0.0,
    longitude: 0.0,
  );

  // 2. getChat
  Telegram.getChat(chatId: 'test');

  // 3. setMyCommands
  Telegram.setMyCommands(commands: [
    {'command': 'test', 'description': 'Test command'}
  ]);

  // 4. openWebApp
  Telegram.openWebApp(
    botUsername: 'test',
    webAppUrl: 'https://example.com',
  );

  // 5. createInlineKeyboardUrl
  Telegram.createInlineKeyboardUrl(
    text: 'Test Button',
    url: 'https://example.com',
  );

  // Verify that all URL scheme methods are available
  Telegram.send(username: 'test', message: 'test');
  Telegram.openChat(username: 'test');
  Telegram.copyLinkToClipboard(username: 'test', message: 'test');
  Telegram.getLink(username: 'test', message: 'test');

  // Verify Bot API methods are available
  Telegram.getMe();
  Telegram.sendMessage(chatId: 'test', text: 'test');
  Telegram.sendPhoto(chatId: 'test', photo: 'test');

  print('✅ All required methods are available and accessible!');
}
