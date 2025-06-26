import 'package:flutter_test/flutter_test.dart';
import 'package:telegram/telegram.dart';

void main() {
  group('Telegram Package Tests', () {
    
    group('Basic URL Generation', () {
      test('should generate correct URL with username only', () {
        final link = Telegram.getLink(username: 'testuser');
        expect(link, equals('https://t.me/testuser'));
      });

      test('should generate correct URL with username and message', () {
        final link = Telegram.getLink(
          username: 'testuser', 
          message: 'Hello World'
        );
        expect(link, equals('https://t.me/testuser?text=Hello%20World'));
      });

      test('should throw error for empty username', () {
        expect(
          () => Telegram.getLink(username: ''),
          throwsA(isA<ArgumentError>()),
        );
      });

      test('should handle special characters in message', () {
        final link = Telegram.getLink(
          username: 'testuser',
          message: 'Hello & Welcome! 🎉',
        );
        expect(link, contains('text=Hello%20%26%20Welcome!%20%F0%9F%8E%89'));
      });
    });

    group('Bot Token Management', () {
      test('should set and get bot token', () {
        const testToken = '123456789:ABCdefGHIjklMNOpqrsTUVwxyz';
        Telegram.setBotToken(testToken);
        expect(Telegram.botToken, equals(testToken));
      });

      test('should return empty string for unset bot token', () {
        Telegram.setBotToken('');
        expect(Telegram.botToken, equals(''));
      });
    });

    group('Share URL Generation', () {
      test('should generate share URL with text only', () {
        final shareUrl = Telegram.generateShareUrl(text: 'Hello World');
        expect(shareUrl, equals('https://t.me/share/url?text=Hello%20World'));
      });

      test('should generate share URL with URL only', () {
        final shareUrl = Telegram.generateShareUrl(url: 'https://example.com');
        expect(shareUrl, equals('https://t.me/share/url?url=https%3A//example.com'));
      });

      test('should generate share URL with both text and URL', () {
        final shareUrl = Telegram.generateShareUrl(
          text: 'Check this out!',
          url: 'https://example.com',
        );
        expect(shareUrl, contains('url=https%3A//example.com'));
        expect(shareUrl, contains('text=Check%20this%20out!'));
      });

      test('should throw error when both text and URL are empty', () {
        expect(
          () => Telegram.generateShareUrl(),
          throwsA(isA<ArgumentError>()),
        );
      });
    });

    group('Inline Keyboard URL Generation', () {
      test('should create inline keyboard URL', () {
        final buttonUrl = Telegram.createInlineKeyboardUrl(
          text: 'Visit Website',
          url: 'https://example.com',
        );
        expect(buttonUrl, contains('https://t.me/iv?url='));
        expect(buttonUrl, contains('rhash='));
      });

      test('should throw error for empty text or URL', () {
        expect(
          () => Telegram.createInlineKeyboardUrl(text: '', url: 'https://example.com'),
          throwsA(isA<ArgumentError>()),
        );
        
        expect(
          () => Telegram.createInlineKeyboardUrl(text: 'Test', url: ''),
          throwsA(isA<ArgumentError>()),
        );
      });
    });

    group('URL Validation', () {
      test('should validate proper usernames', () {
        // These should not throw errors
        expect(() => Telegram.getLink(username: 'validuser'), returnsNormally);
        expect(() => Telegram.getLink(username: 'user123'), returnsNormally);
        expect(() => Telegram.getLink(username: 'user_name'), returnsNormally);
        expect(() => Telegram.getLink(username: 'user-name'), returnsNormally);
      });

      test('should handle edge cases', () {
        // Empty message should work
        expect(() => Telegram.getLink(username: 'user', message: ''), returnsNormally);
        
        // Whitespace-only message should be treated as empty
        final link = Telegram.getLink(username: 'user', message: '   ');
        expect(link, equals('https://t.me/user'));
      });
    });

    group('Error Handling', () {
      test('should handle network-related errors gracefully', () {
        // This test verifies that proper exceptions are thrown
        // when bot token is not set for API calls
        expect(
          () async => await Telegram.getMe(),
          throwsA(isA<Exception>()),
        );
      });
    });

    group('Message Formatting', () {
      test('should handle different message lengths', () {
        // Short message
        final shortLink = Telegram.getLink(username: 'user', message: 'Hi');
        expect(shortLink, contains('text=Hi'));

        // Long message
        final longMessage = 'This is a very long message that contains multiple words and should be properly encoded in the URL without any issues.';
        final longLink = Telegram.getLink(username: 'user', message: longMessage);
        expect(longLink, contains('text='));
        expect(longLink.length, greaterThan(50));
      });

      test('should preserve message content in encoding', () {
        const originalMessage = 'Hello, World! How are you today? 😊';
        final link = Telegram.getLink(username: 'user', message: originalMessage);
        expect(link, contains('text='));
        // The encoded version should contain recognizable parts
        expect(link, contains('Hello'));
      });
    });
  });
}
