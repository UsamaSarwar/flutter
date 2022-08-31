library telegram;

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

/// A simple and light weight utility for sending messages via Telegram.
class Telegram {
  /// Copy Telegram message Link to clipboard
  static void copyLinkToClipboard({required String username, String? message}) {
    Uri? url;
    try {
      if (message != null && message != '') {
        url =
            Uri.parse('https://t.me/$username?text=${Uri.encodeFull(message)}');
      } else {
        url = Uri.parse('https://t.me/$username');
      }
      if (username != '') {
        // Copy link to clipboard
        Clipboard.setData(ClipboardData(text: url.toString()));
        if (kDebugMode) {
          print('Copied to clipboard: $url');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('\x1B[31mGenerating link failed!\nError: $e\x1B[0m');
      }
    }
  }

  /// Get Telegram message link as String
  static String getLink({required String username, String? message}) {
    Uri? url;
    try {
      if (message != null && message != '') {
        url =
            Uri.parse('https://t.me/$username?text=${Uri.encodeFull(message)}');
      } else {
        url = Uri.parse('https://t.me/$username');
      }
    } catch (e) {
      if (kDebugMode) {
        print('\x1B[31mGenerating link failed!\nError: $e\x1B[0m');
      }
    }
    return url.toString();
  }

  /// Send message via Telegram
  static void send({required String username, String? message}) {
    Uri? url;
    try {
      if (message != null && message != '') {
        url =
            Uri.parse('https://t.me/$username?text=${Uri.encodeFull(message)}');
      } else {
        url = Uri.parse('https://t.me/$username');
      }
      launchUrl(
        url,
        mode: LaunchMode.externalNonBrowserApplication,
        webOnlyWindowName: username,
        webViewConfiguration: const WebViewConfiguration(
          headers: <String, String>{
            'User-Agent': 'Telegram',
          },
        ),
      );
      if (kDebugMode) {
        if (message != null && message != '') {
          print(
              '\x1B[32mSending message to $username...\nMessage: $message\x1B[0m\nURL: https://t.me/$username?text=${Uri.encodeFull(message)}');
        } else {
          print('\x1B[32mSending message to $username...\x1B[0m');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('\x1B[31mSending failed!\nError: $e\x1B[0m');
      }
    }
  }
}
