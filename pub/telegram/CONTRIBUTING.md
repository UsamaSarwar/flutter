# Welcome to `telegram` contributing guide 👋🏻

_Comprehensive Telegram API Integration for Flutter_

Thank you for investing your time in contributing to **telegram** project! Any contribution you make will be reflected on [pub.dev/packages/telegram](https://pub.dev/packages/telegram).

Read our [Code of Conduct](./CODE_OF_CONDUCT.md) to keep our community approachable and respectable.

## 📁 Project Structure

```bash
├── telegram/
│   ├── lib/
│   │   └── telegram.dart           # Main library with Bot API & URL schemes
│   ├── example/
│   │   └── lib/
│   │       └── main.dart           # Comprehensive demo app
│   ├── test/
│   │   └── telegram_test.dart      # Unit tests
│   ├── assets/                     # Documentation assets
│   ├── README.md                   # Package documentation
│   ├── CHANGELOG.md               # Version history
│   └── pubspec.yaml               # Package configuration
```

## 🚀 Features Covered

### ✅ Implemented
- **Bot API Integration**: Complete Telegram Bot API support
- **URL Schemes**: Direct Telegram app integration
- **Media Support**: Photos, videos, audio, documents
- **Chat Management**: Info, members, commands
- **Web Apps**: Telegram Web App integration
- **Advanced Features**: Stickers, themes, sharing

### 🔄 Areas for Contribution
- **File Upload**: Local file upload support
- **Webhook Integration**: Webhook handling for bots
- **Inline Queries**: Inline bot functionality
- **Games**: Telegram Games API
- **Payments**: Telegram Payments integration
- **More Tests**: Comprehensive test coverage

## 💻 Development Setup

1. **Clone the repository**
   ```bash
   git clone https://github.com/UsamaSarwar/flutter.git
   cd flutter/pub/telegram
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   cd example && flutter pub get
   ```

3. **Run the example**
   ```bash
   cd example
   flutter run
   ```

4. **Run tests**
   ```bash
   flutter test
   ```

## 🔧 Adding New Features

### Bot API Methods
1. Add method to `lib/telegram.dart`
2. Follow existing pattern with `_makeApiRequest()`
3. Add comprehensive documentation
4. Update example app
5. Add tests

### URL Scheme Methods
1. Add method to `lib/telegram.dart`
2. Use `launchUrl()` for external app calls
3. Include error handling
4. Update documentation

### Example
```dart
/// New Bot API method example
static Future<Map<String, dynamic>> newBotMethod({
  required String chatId,
  required String parameter,
}) async {
  final parameters = <String, dynamic>{
    'chat_id': chatId,
    'parameter': parameter,
  };

  return await _makeApiRequest('newMethod', parameters);
}
```

## 📝 Pull Request Guidelines

1. **Create a feature branch**
   ```bash
   git checkout -b feature/your-feature-name
   ```

2. **Follow the code style**
   - Use consistent naming conventions
   - Add comprehensive documentation
   - Include error handling
   - Follow Dart formatting guidelines

3. **Update documentation**
   - Update README.md if needed
   - Add method to API reference table
   - Update CHANGELOG.md

4. **Test your changes**
   - Run existing tests
   - Add new tests for your feature
   - Test with the example app

5. **Submit your PR**
   - Clear title and description
   - Reference any related issues
   - Include before/after examples

## 📚 Resources

- [Telegram Bot API Documentation](https://core.telegram.org/bots/api)
- [Telegram URL Schemes](https://core.telegram.org/api/links)
- [Flutter Package Development](https://docs.flutter.dev/development/packages-and-plugins/developing-packages)

## 🙋‍♂️ Getting Help

- Open an issue for bugs or feature requests
- Join our [Telegram channel](https://t.me/freelancers_inc) for discussions
- Contact [@UsamaSarwar](https://t.me/UsamaSarwar) for direct support

Thank you for contributing! 🚀