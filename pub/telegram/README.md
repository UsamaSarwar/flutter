[![telegram](https://img.shields.io/pub/v/telegram.svg?label=telegram&color=blue)](https://pub.dev/packages/telegram)
[![Points](https://img.shields.io/pub/points/telegram)](https://pub.dev/packages/telegram/score)
[![Popularity](https://img.shields.io/pub/popularity/telegram)](https://pub.dev/packages/telegram/score)
[![Likes](https://img.shields.io/pub/likes/telegram)](https://pub.dev/packages/telegram/score)
[![Telegram](https://img.shields.io/badge/Telegram--blue?logo=telegram&logoColor=white)](https://t.me/UsamaSarwar)
[![WhatsApp](https://img.shields.io/badge/WhatsApp--tgreen?logo=whatsapp&logoColor=white)](https://wa.me/923100007773)
[![Contribute Now](https://img.shields.io/badge/Contribute--blue?logo=Github&logoColor=white)](https://github.com/UsamaSarwar/flutter/blob/main/pub/cmd/CONTRIBUTING.md)
[![Donate Now](https://img.shields.io/badge/Donate--blue?logo=buy-me-a-coffee&logoColor=white)](https://www.buymeacoffee.com/UsamaSarwar)

<p align="justify">
A simple and light weight utility for sending messages via Telegram. Telegram is a globally accessible freemium, cross-platform, cloud-based instant messaging service. The service also provides optional end-to-end encrypted chats and video calling, VoIP, file sharing and several other features. </p>

## Features

<img align="right" alt="flutter cmd" src="https://raw.githubusercontent.com/UsamaSarwar/flutter/main/pub/telegram/assets/coding.gif" height="auto" width ="150"/>

📨 Send Message via Telegram<br>  
🔗 Telegram Link Generator<br>  
📌 Copy Telegram Link<br>  
💬 Open Chat Directly<br>  
📢 Join Telegram Channel/Group<br>  
✅ Check if Telegram is Installed<br>  
📞 Share Contact via Telegram<br>  
👥 Open Telegram Group<br>  
📷 Send Media via Telegram<br>  
🔍 Check Username Availability<br>  
🤖 Open Telegram Bot<br>  
🔥 _more coming soon..._

## Installation

Add **telegram** as dependency by running the command below:

```bash
flutter pub add telegram
```

**OR**

Add **telegram** this in your `pubspec.yaml`:

```yaml
dependencies:
  telegram:
```

## Usage 📨

<img align="right" alt="FAQs" src="https://raw.githubusercontent.com/UsamaSarwar/flutter/main/pub/telegram/assets/faq.png" height="auto" width ="30%"/>

```dart
/// Send message via Telegram
Telegram.send(
  username:'UsamaSarwar',
  message:'Thanks for building Telegram Package :)'
);
```

```dart
/// Copy Telegram message Link to clipboard
Telegram.copyLinkToClipboard(
  username:'UsamaSarwar',
  message:'Thanks for building Telegram Package :)'
);
```

```dart
/// Get Telegram message link as String
Telegram.getLink(
  username:'UsamaSarwar',
  message:'Thanks for building Telegram Package :)'
);
```

```dart
/// Open chat with a specific username
Telegram.openChat(username: 'UsamaSarwar');
```

```dart
/// Join a Telegram channel or group using an invite link
Telegram.joinChannel(inviteLink: 'https://t.me/joinchat/XXXXXXX');
```

```dart
/// Join a Telegram channel or group using an invite link
Telegram.joinChannel(inviteLink: 'https://t.me/joinchat/XXXXXXX');
```

```dart
/// Check if Telegram is installed on the device
bool installed = await Telegram.isTelegramInstalled();
print('Telegram installed: $installed');
```

```dart
/// Share a contact via Telegram
Telegram.shareContact(
  phone: '+923100007773',
  firstName: 'Usama',
  lastName: 'Sarwar'
);
```

```dart
/// Open a Telegram group by username
Telegram.openGroup(username: 'yourgroupname');
```

```dart
/// Send a media file via Telegram
Telegram.sendMedia(filePath: 'https://example.com/sample.jpg');
```

```dart
/// Check if a Telegram username is available
bool exists = await Telegram.checkUsernameAvailability(username: 'exampleUser');
print('Username exists: $exists');
```

```dart
/// Open a Telegram bot using its username
Telegram.openBot(username: 'MyTelegramBot');
```

Import the package and call any of the methods in your Flutter app. For example:
```dart
import 'package:telegram/telegram.dart';

void main() async {
  try {
    await Telegram.send(
      username: 'UsamaSarwar',
      message: 'Thanks for building Telegram Package :)'
    );
  } catch (e) {
    print('Error: $e');
  }
}
```

## Contribution 💙

You are warmly welcome for contributing **telegram** package. Checkout this [contribution guide.](./CONTRIBUTING.md)

<p align="center"> <img src="https://raw.githubusercontent.com/UsamaSarwar/flutter/main/pub/telegram/assets/contribution.svg" alt="telegram contributions" /> </p>

<p align="center">Open Source Contributor from <b>Punjab, Pakistan</b> 🇵🇰 </p>
<div align="center"><br>
<p><a href="https://www.buymeacoffee.com/UsamaSarwar"> <img align="center" src="https://cdn.buymeacoffee.com/buttons/v2/default-yellow.png" height="40" width="168" alt="Buy me a Coffee ☕" /></a></p>
</div>

<br><p align="center"> <img src="https://raw.githubusercontent.com/UsamaSarwar/flutter/main/pub/telegram/assets/flutter.jpg" alt="Flutter telegram package" /> </p>
