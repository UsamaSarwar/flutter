[![telegram](https://img.shields.io/pub/v/telegram.svg?label=telegram&color=blue)](https://pub.dev/packages/telegram)
[![Points](https://img.shields.io/pub/points/telegram)](https://pub.dev/packages/telegram/score)
[![Popularity](https://img.shields.io/pub/popularity/telegram)](https://pub.dev/packages/telegram/score)
[![Likes](https://img.shields.io/pub/likes/telegram)](https://pub.dev/packages/telegram/score)
[![Telegram](https://img.shields.io/badge/Telegram--blue?logo=telegram&logoColor=white)](https://t.me/UsamaSarwar)
[![WhatsApp](https://img.shields.io/badge/WhatsApp--tgreen?logo=whatsapp&logoColor=white)](https://wa.me/923100007773)
[![Contribute Now](https://img.shields.io/badge/Contribute--blue?logo=Github&logoColor=white)](https://github.com/UsamaSarwar/flutter/blob/main/pub/cmd/CONTRIBUTING.md)
[![Donate Now](https://img.shields.io/badge/Donate--blue?logo=buy-me-a-coffee&logoColor=white)](https://www.buymeacoffee.com/UsamaSarwar)

<p align="justify">
A comprehensive Telegram utility for Flutter that provides both client-side URL schemes and server-side Bot API integration. This package enables seamless Telegram functionality including messaging, media sharing, chat management, Web App support, and complete Bot API integration - all wrapped in an easy-to-use Flutter package.
</p>

## 🚀 Features

<img align="right" alt="flutter telegram" src="https://raw.githubusercontent.com/UsamaSarwar/flutter/main/pub/telegram/assets/coding.gif" height="auto" width ="150"/>

### URL Scheme Methods
📨 **Send Messages** - Direct message sending via Telegram URLs<br>  
🔗 **Link Generation** - Generate shareable Telegram links<br>  
📌 **Copy to Clipboard** - Quick link copying functionality<br>  
💬 **Open Chats** - Direct chat opening with users<br>  
📢 **Join Channels/Groups** - Seamless channel/group joining<br>  
✅ **Installation Check** - Verify Telegram app presence<br>  
📞 **Contact Sharing** - Share contacts via Telegram<br>  
🤖 **Bot Interaction** - Open and interact with bots<br>

### Bot API Integration
🤖 **Bot Management** - Full Bot API support<br>  
� **Message Sending** - Send text, media, and formatted messages<br>  
🖼️ **Media Support** - Photos, videos, audio, documents<br>  
📍 **Location Sharing** - Send geographical locations<br>  
� **Chat Management** - Get chat info, member counts<br>  
⚙️ **Bot Commands** - Set and manage bot commands<br>  
✏️ **Message Editing** - Edit and delete messages<br>  
🔄 **Message Forwarding** - Forward messages between chats<br>

### Advanced Features
🌐 **Web Apps** - Telegram Web App integration<br>  
🎨 **Themes & Stickers** - Open theme and sticker sets<br>  
🔗 **Inline Keyboards** - Create interactive button URLs<br>  
� **Share URLs** - Generate content sharing links<br>  
🔍 **Username Validation** - Check username availability<br>  
📱 **Cross-platform** - Works on all Flutter platforms<br>

## 🏗️ Modular Architecture

This package is built with a clean, modular architecture that separates different functionalities into focused modules:

### Core Modules

- **`url_schemes.dart`** - Client-side URL scheme methods for direct Telegram app integration
- **`messaging.dart`** - Bot API messaging methods for sending text, formatted messages, and interactive content
- **`media.dart`** - Media handling for photos, videos, audio, documents, stickers, and animations
- **`chat.dart`** - Chat management including information retrieval, settings, and administrative actions
- **`members.dart`** - Member management for user permissions, roles, and moderation
- **`bot_config.dart`** - Bot configuration including commands, descriptions, and profile settings
- **`webhook.dart`** - Webhook management for real-time message handling and bot updates

### Unified Interface

All modules are seamlessly integrated through the main `Telegram` class, providing a single, comprehensive API while maintaining clean separation of concerns under the hood.

```dart
// All methods are available through the main Telegram class
import 'package:telegram/telegram.dart';

// URL scheme methods
await Telegram.send(username: 'user', message: 'Hello');

// Bot API methods  
await Telegram.sendMessage(chatId: 'chat', text: 'Hello');

// Media methods
await Telegram.sendPhoto(chatId: 'chat', photo: 'url');

// Chat management
await Telegram.getChat(chatId: 'chat');
```

You can also import specific modules if you only need certain functionality:

```dart
// Import only what you need
import 'package:telegram/src/messaging.dart';
import 'package:telegram/src/media.dart';

// Use module classes directly
await TelegramMessaging.sendMessage(chatId: 'chat', text: 'Hello');
await TelegramMedia.sendPhoto(chatId: 'chat', photo: 'url');
```

## 📦 Installation

Add **telegram** as dependency:

```bash
flutter pub add telegram
```

Or add to your `pubspec.yaml`:

```yaml
dependencies:
  telegram: ^1.0.0
```

## 📖 Usage

### Basic URL Scheme Usage

```dart
import 'package:telegram/telegram.dart';

// Send message via Telegram
await Telegram.send(
  username: 'UsamaSarwar',
  message: 'Hello from Flutter! 🚀'
);

// Copy link to clipboard
await Telegram.copyLinkToClipboard(
  username: 'UsamaSarwar',
  message: 'Check out this package!'
);

// Get message link as string
String link = Telegram.getLink(
  username: 'UsamaSarwar',
  message: 'Amazing Flutter package!'
);

// Open chat directly
await Telegram.openChat(username: 'UsamaSarwar');

// Check if Telegram is installed
bool installed = await Telegram.isTelegramInstalled();
```

### Bot API Usage

First, set your bot token (get one from [@BotFather](https://t.me/BotFather)):

```dart
// Set bot token (do this once, typically in main())
Telegram.setBotToken('YOUR_BOT_TOKEN_HERE');

// Get bot information
final botInfo = await Telegram.getMe();
print('Bot name: ${botInfo['first_name']}');

// Send a text message
await Telegram.sendMessage(
  chatId: '@UsamaSarwar', // or numeric chat ID  
  text: 'Hello from my Flutter bot! 🤖',
  parseMode: 'HTML', // optional: HTML, Markdown, or MarkdownV2
);

// Send formatted message with HTML
await Telegram.sendMessage(
  chatId: '@UsamaSarwar',
  text: '<b>Bold Text</b>\n<i>Italic Text</i>\n<code>Code</code>',
  parseMode: 'HTML',
);
```

### Media Messaging

```dart
// Send a photo with caption
await Telegram.sendPhoto(
  chatId: '@UsamaSarwar',
  photo: 'https://example.com/image.jpg', // URL or file path
  caption: 'Beautiful Flutter app screenshot! 📱',
  parseMode: 'HTML',
);

// Send video with details
await Telegram.sendVideo(
  chatId: '@UsamaSarwar',
  video: 'https://example.com/video.mp4',
  caption: 'App demo video',
  duration: 30,
  width: 1920,
  height: 1080,
);

// Send audio file
await Telegram.sendAudio(
  chatId: '@UsamaSarwar',
  audio: 'https://example.com/audio.mp3',
  title: 'My Audio Track',
  performer: 'Artist Name',
  duration: 180,
);

// Send voice message
await Telegram.sendVoice(
  chatId: '@UsamaSarwar',
  voice: 'https://example.com/voice.ogg',
  duration: 10,
);

// Send video note (circular video)
await Telegram.sendVideoNote(
  chatId: '@UsamaSarwar',
  videoNote: 'https://example.com/video_note.mp4',
  duration: 15,
  length: 240,
);

// Send animation/GIF
await Telegram.sendAnimation(
  chatId: '@UsamaSarwar',
  animation: 'https://example.com/animation.gif',
  caption: 'Cool animation!',
);

// Send sticker
await Telegram.sendSticker(
  chatId: '@UsamaSarwar',
  sticker: 'https://example.com/sticker.webp',
);

// Send document
await Telegram.sendDocument(
  chatId: '@UsamaSarwar',
  document: 'https://example.com/document.pdf',
  caption: 'Important document',
);
```

### Location and Contact Sharing

```dart
// Send location
await Telegram.sendLocation(
  chatId: '@UsamaSarwar',
  latitude: 37.7749,
  longitude: -122.4194,
  livePeriod: 900, // Live location for 15 minutes
);

// Send venue
await Telegram.sendVenue(
  chatId: '@UsamaSarwar',
  latitude: 37.7749,
  longitude: -122.4194,
  title: 'My Office',
  address: '123 Main St, San Francisco, CA',
);

// Send contact
await Telegram.sendContact(
  chatId: '@UsamaSarwar',
  phoneNumber: '+1234567890',
  firstName: 'John',
  lastName: 'Doe',
);
```

### Interactive Content

```dart
// Send poll
await Telegram.sendPoll(
  chatId: '@UsamaSarwar',
  question: 'What\'s your favorite Flutter feature?',
  options: ['Hot Reload', 'Widgets', 'Cross-platform', 'Performance'],
  isAnonymous: false,
  allowsMultipleAnswers: true,
);

// Send dice (🎲, 🎯, 🏀, ⚽, 🎳, 🎰)
await Telegram.sendDice(
  chatId: '@UsamaSarwar',
  emoji: '🎲',
);
```

### Message Management

```dart
// Forward a message
await Telegram.forwardMessage(
  chatId: '@UsamaSarwar',
  fromChatId: '@sourcechat',
  messageId: 123,
);

// Edit a message
await Telegram.editMessageText(
  chatId: '@UsamaSarwar',
  messageId: 456,
  text: 'Updated message content',
  parseMode: 'HTML',
);

// Delete a message
bool deleted = await Telegram.deleteMessage(
  chatId: '@UsamaSarwar',
  messageId: 789,
);

// Pin a message
await Telegram.pinChatMessage(
  chatId: '@UsamaSarwar',
  messageId: 123,
  disableNotification: false,
);

// Unpin a message
await Telegram.unpinChatMessage(
  chatId: '@UsamaSarwar',
  messageId: 123,
);

// Unpin all messages
await Telegram.unpinAllChatMessages(chatId: '@UsamaSarwar');
```

### Chat Information and Management

```dart
// Get chat information
final chatInfo = await Telegram.getChat(chatId: '@freelancers_inc');
print('Chat title: ${chatInfo['title']}');
print('Chat type: ${chatInfo['type']}');

// Get chat member count
int memberCount = await Telegram.getChatMemberCount(
  chatId: '@freelancers_inc'
);
print('Members: $memberCount');

// Get chat member info
final memberInfo = await Telegram.getChatMember(
  chatId: '@freelancers_inc',
  userId: 12345,
);

// Set chat title
await Telegram.setChatTitle(
  chatId: '@UsamaSarwar',
  title: 'New Chat Title',
);

// Set chat description
await Telegram.setChatDescription(
  chatId: '@UsamaSarwar',
  description: 'This is the new chat description',
);

// Leave chat
await Telegram.leaveChat(chatId: '@UsamaSarwar');
```

### Member Management

```dart
// Ban a user
await Telegram.banChatMember(
  chatId: '@UsamaSarwar',
  userId: 12345,
  untilDate: DateTime.now().add(Duration(days: 1)).millisecondsSinceEpoch ~/ 1000,
);

// Unban a user
await Telegram.unbanChatMember(
  chatId: '@UsamaSarwar',
  userId: 12345,
);

// Restrict a user
await Telegram.restrictChatMember(
  chatId: '@UsamaSarwar',
  userId: 12345,
  permissions: {
    'can_send_messages': false,
    'can_send_media_messages': false,
  },
);

// Promote a user to admin
await Telegram.promoteChatMember(
  chatId: '@UsamaSarwar',
  userId: 12345,
  canDeleteMessages: true,
  canRestrictMembers: true,
  canInviteUsers: true,
);

// Set admin custom title
await Telegram.setChatAdministratorCustomTitle(
  chatId: '@UsamaSarwar',
  userId: 12345,
  customTitle: 'Super Admin',
);
```

### Invite Link Management

```dart
// Export primary invite link
String inviteLink = await Telegram.exportChatInviteLink(
  chatId: '@UsamaSarwar',
);

// Create custom invite link
final customLink = await Telegram.createChatInviteLink(
  chatId: '@UsamaSarwar',
  name: 'VIP Members',
  memberLimit: 100,
  expireDate: DateTime.now().add(Duration(days: 7)).millisecondsSinceEpoch ~/ 1000,
);

// Edit invite link
await Telegram.editChatInviteLink(
  chatId: '@UsamaSarwar',
  inviteLink: customLink['invite_link'],
  name: 'Updated VIP Members',
);

// Revoke invite link
await Telegram.revokeChatInviteLink(
  chatId: '@UsamaSarwar',
  inviteLink: customLink['invite_link'],
);
```

### Bot Configuration

```dart
// Set bot commands
await Telegram.setMyCommands(commands: [
  {'command': 'start', 'description': 'Start the bot'},
  {'command': 'help', 'description': 'Show help message'},
  {'command': 'settings', 'description': 'Bot settings'},
]);

// Get current bot commands
final commands = await Telegram.getMyCommands();

// Set bot description
await Telegram.setMyDescription(
  description: 'This bot helps with Flutter development',
);

// Set short description
await Telegram.setMyShortDescription(
  shortDescription: 'Flutter Development Bot',
);
```

### Webhook Integration

```dart
// Set webhook for receiving updates
await Telegram.setWebhook(
  url: 'https://yourserver.com/webhook',
  secretToken: 'your_secret_token',
);

// Get webhook info
final webhookInfo = await Telegram.getWebhookInfo();
print('Webhook URL: ${webhookInfo['url']}');

// Delete webhook (switch to polling)
await Telegram.deleteWebhook();

// Get updates manually (polling)
final updates = await Telegram.getUpdates(limit: 10);

// Answer callback query (for inline keyboards)
await Telegram.answerCallbackQuery(
  callbackQueryId: 'callback_query_id',
  text: 'Button pressed!',
  showAlert: true,
);
```
final commands = await Telegram.getMyCommands();
for (var command in commands) {
  print('/${command['command']} - ${command['description']}');
}
```

### Advanced Features

```dart
// Open Telegram Web App
await Telegram.openWebApp(
  botUsername: 'gamebot',
  webAppUrl: 'https://mygame.com',
  startParam: 'level1',
);

// Join channel/group
await Telegram.joinChannel(
  inviteLink: 'https://t.me/freelancers_inc'
);

// Share contact
await Telegram.shareContact(
  phone: '+1234567890',
  firstName: 'John',
  lastName: 'Doe',
);

// Open sticker set
await Telegram.openStickerSet(
  stickerSetName: 'AnimatedEmojies'
);

// Generate share URL
String shareUrl = Telegram.generateShareUrl(
  text: 'Check out this amazing app!',
  url: 'https://myapp.com',
);

// Check username availability  
bool available = await Telegram.checkUsernameAvailability(
  username: 'someusername'
);
```

### Error Handling

```dart
try {
  await Telegram.sendMessage(
    chatId: '@invaliduser',
    text: 'This might fail',
  );
} catch (e) {
  print('Error: $e');
  // Handle specific errors
  if (e.toString().contains('Bot token not set')) {
    // Set bot token first
  } else if (e.toString().contains('chat not found')) {
    // Invalid chat ID
  }
}
```

## 🎯 Example App

The package includes a comprehensive example app showcasing all features:

- **URL Scheme Tab**: Basic Telegram URL operations
- **Bot API Tab**: Full Bot API functionality  
- **Utilities Tab**: Advanced features and utilities

Run the example:
```bash
cd example
flutter run
```

## 🔧 Configuration

### Bot API Setup
1. Message [@BotFather](https://t.me/BotFather) on Telegram
2. Create a new bot with `/newbot`
3. Get your bot token
4. Set it in your app: `Telegram.setBotToken('YOUR_TOKEN')`

### URL Schemes
No additional setup required! URL schemes work out of the box.

## 📚 API Reference

### Bot API Methods

#### Core Methods
| Method | Description | Parameters |
|--------|-------------|------------|
| `setBotToken()` | Set bot token for API access | `token` |
| `getMe()` | Get bot information | None |
| `getUpdates()` | Get updates (polling) | `offset?`, `limit?`, `timeout?`, `allowedUpdates?` |

#### Messaging Methods
| Method | Description | Parameters |
|--------|-------------|------------|
| `sendMessage()` | Send text message | `chatId`, `text`, `parseMode?`, `disableWebPagePreview?`, `disableNotification?`, `replyToMessageId?` |
| `forwardMessage()` | Forward message | `chatId`, `fromChatId`, `messageId`, `disableNotification?` |
| `editMessageText()` | Edit message text | `chatId`, `messageId`, `text`, `parseMode?`, `disableWebPagePreview?` |
| `deleteMessage()` | Delete message | `chatId`, `messageId` |

#### Media Methods
| Method | Description | Parameters |
|--------|-------------|------------|
| `sendPhoto()` | Send photo | `chatId`, `photo`, `caption?`, `parseMode?`, `disableNotification?`, `replyToMessageId?` |
| `sendVideo()` | Send video | `chatId`, `video`, `duration?`, `width?`, `height?`, `caption?`, `parseMode?`, `supportsStreaming?`, `disableNotification?`, `replyToMessageId?` |
| `sendAudio()` | Send audio | `chatId`, `audio`, `caption?`, `parseMode?`, `duration?`, `performer?`, `title?`, `disableNotification?`, `replyToMessageId?` |
| `sendVoice()` | Send voice message | `chatId`, `voice`, `caption?`, `parseMode?`, `duration?`, `disableNotification?`, `replyToMessageId?` |
| `sendVideoNote()` | Send video note | `chatId`, `videoNote`, `duration?`, `length?`, `disableNotification?`, `replyToMessageId?` |
| `sendAnimation()` | Send animation/GIF | `chatId`, `animation`, `duration?`, `width?`, `height?`, `caption?`, `parseMode?`, `disableNotification?`, `replyToMessageId?` |
| `sendSticker()` | Send sticker | `chatId`, `sticker`, `disableNotification?`, `replyToMessageId?` |
| `sendDocument()` | Send document | `chatId`, `document`, `caption?`, `parseMode?`, `disableNotification?`, `replyToMessageId?` |

#### Location and Contact Methods
| Method | Description | Parameters |
|--------|-------------|------------|
| `sendLocation()` | Send location | `chatId`, `latitude`, `longitude`, `livePeriod?`, `heading?`, `proximityAlertRadius?`, `disableNotification?`, `replyToMessageId?` |
| `sendVenue()` | Send venue | `chatId`, `latitude`, `longitude`, `title`, `address`, `foursquareId?`, `foursquareType?`, `googlePlaceId?`, `googlePlaceType?`, `disableNotification?`, `replyToMessageId?` |
| `sendContact()` | Send contact | `chatId`, `phoneNumber`, `firstName`, `lastName?`, `vcard?`, `disableNotification?`, `replyToMessageId?` |

#### Interactive Content Methods
| Method | Description | Parameters |
|--------|-------------|------------|
| `sendPoll()` | Send poll | `chatId`, `question`, `options`, `isAnonymous?`, `type?`, `allowsMultipleAnswers?`, `correctOptionId?`, `explanation?`, `explanationParseMode?`, `openPeriod?`, `closeDate?`, `isClosed?`, `disableNotification?`, `replyToMessageId?` |
| `sendDice()` | Send dice | `chatId`, `emoji?`, `disableNotification?`, `replyToMessageId?` |
| `answerCallbackQuery()` | Answer callback query | `callbackQueryId`, `text?`, `showAlert?`, `url?`, `cacheTime?` |

#### Chat Information Methods
| Method | Description | Parameters |
|--------|-------------|------------|
| `getChat()` | Get chat information | `chatId` |
| `getChatMemberCount()` | Get member count | `chatId` |
| `getChatMember()` | Get member info | `chatId`, `userId` |

#### Chat Management Methods
| Method | Description | Parameters |
|--------|-------------|------------|
| `setChatTitle()` | Set chat title | `chatId`, `title` |
| `setChatDescription()` | Set chat description | `chatId`, `description?` |
| `setChatPhoto()` | Set chat photo | `chatId`, `photo` |
| `deleteChatPhoto()` | Delete chat photo | `chatId` |
| `setChatStickerSet()` | Set chat sticker set | `chatId`, `stickerSetName` |
| `deleteChatStickerSet()` | Delete chat sticker set | `chatId` |
| `leaveChat()` | Leave chat | `chatId` |

#### Message Management Methods
| Method | Description | Parameters |
|--------|-------------|------------|
| `pinChatMessage()` | Pin message | `chatId`, `messageId`, `disableNotification?` |
| `unpinChatMessage()` | Unpin message | `chatId`, `messageId?` |
| `unpinAllChatMessages()` | Unpin all messages | `chatId` |

#### Member Management Methods
| Method | Description | Parameters |
|--------|-------------|------------|
| `banChatMember()` | Ban chat member | `chatId`, `userId`, `untilDate?`, `revokeMessages?` |
| `unbanChatMember()` | Unban chat member | `chatId`, `userId`, `onlyIfBanned?` |
| `restrictChatMember()` | Restrict member | `chatId`, `userId`, `permissions`, `untilDate?` |
| `promoteChatMember()` | Promote member | `chatId`, `userId`, `isAnonymous?`, `canManageChat?`, `canPostMessages?`, `canEditMessages?`, `canDeleteMessages?`, `canManageVideoChats?`, `canRestrictMembers?`, `canPromoteMembers?`, `canChangeInfo?`, `canInviteUsers?`, `canPinMessages?` |
| `setChatAdministratorCustomTitle()` | Set admin title | `chatId`, `userId`, `customTitle` |

#### Invite Link Management Methods
| Method | Description | Parameters |
|--------|-------------|------------|
| `exportChatInviteLink()` | Export primary invite link | `chatId` |
| `createChatInviteLink()` | Create invite link | `chatId`, `name?`, `expireDate?`, `memberLimit?`, `createsJoinRequest?` |
| `editChatInviteLink()` | Edit invite link | `chatId`, `inviteLink`, `name?`, `expireDate?`, `memberLimit?`, `createsJoinRequest?` |
| `revokeChatInviteLink()` | Revoke invite link | `chatId`, `inviteLink` |

#### Bot Configuration Methods
| Method | Description | Parameters |
|--------|-------------|------------|
| `setMyCommands()` | Set bot commands | `commands` |
| `getMyCommands()` | Get bot commands | None |
| `setMyDescription()` | Set bot description | `description?`, `languageCode?` |
| `getMyDescription()` | Get bot description | `languageCode?` |
| `setMyShortDescription()` | Set short description | `shortDescription?`, `languageCode?` |
| `getMyShortDescription()` | Get short description | `languageCode?` |

#### Webhook Methods
| Method | Description | Parameters |
|--------|-------------|------------|
| `setWebhook()` | Set webhook URL | `url`, `certificate?`, `ipAddress?`, `maxConnections?`, `allowedUpdates?`, `dropPendingUpdates?`, `secretToken?` |
| `deleteWebhook()` | Delete webhook | `dropPendingUpdates?` |
| `getWebhookInfo()` | Get webhook info | None |

### URL Scheme Methods

| Method | Description | Parameters |
|--------|-------------|------------|
| `send()` | Send message via URL | `username`, `message?` |
| `getLink()` | Get message link | `username`, `message?` |
| `copyLinkToClipboard()` | Copy link to clipboard | `username`, `message?` |
| `openChat()` | Open chat | `username` |
| `openGroup()` | Open group | `username` |
| `openBot()` | Open bot | `username` |
| `joinChannel()` | Join channel | `inviteLink` |
| `shareContact()` | Share contact | `phone`, `firstName`, `lastName?` |
| `sendMedia()` | Send media file | `filePath` |
| `isTelegramInstalled()` | Check installation | None |
| `checkUsernameAvailability()` | Check username | `username` |
| `openWebApp()` | Open Web App | `botUsername`, `webAppUrl`, `startParam?` |
| `openStickerSet()` | Open sticker set | `stickerSetName` |
| `openTheme()` | Open theme | `themeName` |
| `generateShareUrl()` | Generate share URL | `text?`, `url?` |
| `createInlineKeyboardUrl()` | Create button URL | `text`, `url` |

## 🌟 Demo

**Demo Account**: [@UsamaSarwar](https://t.me/UsamaSarwar)  
**Demo Channel**: [t.me/freelancers_inc](https://t.me/freelancers_inc)

## 🤝 Contributing

Contributions are welcome! Check out our [contribution guide](./CONTRIBUTING.md).

<p align="center"> <img src="https://raw.githubusercontent.com/UsamaSarwar/flutter/main/pub/telegram/assets/contribution.svg" alt="telegram contributions" /> </p>

## 💝 Support

<div align="center">
<p><a href="https://www.buymeacoffee.com/UsamaSarwar"> <img align="center" src="https://cdn.buymeacoffee.com/buttons/v2/default-yellow.png" height="40" width="168" alt="Buy me a Coffee ☕" /></a></p>
</div>

---

<p align="center">Made with ❤️ in Pakistan 🇵🇰</p>
<p align="center"> <img src="https://raw.githubusercontent.com/UsamaSarwar/flutter/main/pub/telegram/assets/flutter.jpg" alt="Flutter telegram package" /> </p>
