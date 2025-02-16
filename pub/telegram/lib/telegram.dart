library telegram;

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

/// A simple and lightweight utility for sending messages via Telegram.
class Telegram {
  /// Generates a Telegram URL for a given username and optional message.
  ///
  /// This method constructs a URL that can be used to open a Telegram chat
  /// with the specified username. If a message is provided, it will be
  /// included in the URL as a pre-filled text.
  ///
  /// Throws an [ArgumentError] if the username is empty.
  /// Throws a [FormatException] if the URL generation fails.
  ///
  /// - Parameters:
  ///   - username: The Telegram username for which the URL is to be generated.
  ///   - message: An optional message to be included in the URL.
  ///
  /// - Returns: A [Uri] object representing the generated Telegram URL.
  static Uri _generateUrl({required String username, String? message}) {
    if (username.trim().isEmpty) {
      throw ArgumentError('Username cannot be empty.');
    }
    try {
      if (message != null && message.trim().isNotEmpty) {
        return Uri.parse('https://t.me/$username?text=${Uri.encodeFull(message)}');
      } else {
        return Uri.parse('https://t.me/$username');
      }
    } catch (e) {
      throw FormatException('Failed to generate URL: $e');
    }
  }

  /// Copies the Telegram message link to the clipboard.
  ///
  /// This method generates a URL based on the provided [username] and optional [message],
  /// and then copies this URL to the system clipboard.
  ///
  /// If the operation is successful, the URL is printed to the console in debug mode.
  /// If the operation fails, an exception is thrown.
  ///
  /// - Parameters:
  ///   - username: The Telegram username to include in the generated URL. This parameter is required.
  ///   - message: An optional message to include in the generated URL.
  ///
  /// - Throws: An [Exception] if the link could not be copied to the clipboard.
  static Future<void> copyLinkToClipboard({
    required String username,
    String? message,
  }) async {
    Uri url = _generateUrl(username: username, message: message);
    try {
      await Clipboard.setData(ClipboardData(text: url.toString()));
      if (kDebugMode) {
        print('Copied to clipboard: $url');
      }
    } catch (e) {
      throw Exception('Failed to copy link to clipboard: $e');
    }
  }

  /// Returns the Telegram message link as a String.
  ///
  /// This method generates a URL for a Telegram message link based on the provided
  /// username and optional message.
  ///
  /// The [username] parameter is required and should be the Telegram username.
  ///
  /// The [message] parameter is optional and can be used to specify a particular
  /// message within the chat.
  ///
  /// Returns a [String] representing the generated Telegram message link.
  static String getLink({
    required String username,
    String? message,
  }) {
    Uri url = _generateUrl(username: username, message: message);
    return url.toString();
  }

  /// Sends a message via Telegram.
  ///
  /// This method constructs a URL to send a message to a specified Telegram
  /// username and attempts to launch it using the `launchUrl` function.
  ///
  /// If the message is successfully launched, it will print debug information
  /// if the application is in debug mode.
  ///
  /// Throws an [Exception] if the URL could not be launched or if there was
  /// an error during the process.
  ///
  /// Parameters:
  /// - `username` (required): The Telegram username to send the message to.
  /// - `message` (optional): The message to be sent. If not provided, only the
  ///   URL will be launched without any message content.
  ///
  /// Example:
  /// ```dart
  /// await send(username: 'exampleUser', message: 'Hello, this is a test message.');
  /// ```
  static Future<void> send({
    required String username,
    String? message,
  }) async {
    Uri url = _generateUrl(username: username, message: message);
    try {
      bool launched = await launchUrl(
        url,
        mode: LaunchMode.externalNonBrowserApplication,
        webOnlyWindowName: username,
        webViewConfiguration: const WebViewConfiguration(
          headers: <String, String>{
            'User-Agent': 'Telegram',
          },
        ),
      );
      if (!launched) {
        throw Exception('Could not launch Telegram link.');
      }
      if (kDebugMode) {
        if (message != null && message.trim().isNotEmpty) {
          print('Sending message to $username...\nMessage: $message\nURL: $url');
        } else {
          print('Sending message to $username...\nURL: $url');
        }
      }
    } catch (e) {
      throw Exception('Failed to send message: $e');
    }
  }

  /// Checks if Telegram is installed on the device.
  ///
  /// This method attempts to launch a URL using Telegram's custom URL scheme.
  /// If the URL can be launched, it indicates that Telegram is installed on the device.
  ///
  /// Returns a [Future] that completes with `true` if Telegram is installed,
  /// and `false` otherwise.
  ///
  /// Throws an [Exception] if there is an error while attempting to check the
  /// installation status.
  static Future<bool> isTelegramInstalled() async {
    // Using Telegram's custom URL scheme.
    final Uri telegramUri = Uri.parse('tg://resolve?domain=telegram');
    try {
      return await canLaunchUrl(telegramUri);
    } catch (e) {
      throw Exception('Failed to check Telegram installation: $e');
    }
  }

  /// Opens a chat with the given username using Telegram's custom URL scheme.
  ///
  /// This method constructs a Telegram URL with the provided username and attempts
  /// to launch it using the `launchUrl` function. If the username is empty, an
  /// [ArgumentError] is thrown. If the URL cannot be launched, an [Exception] is thrown.
  ///
  /// The method uses the [LaunchMode.externalNonBrowserApplication] mode to open
  /// the Telegram app directly.
  ///
  /// If the app is in debug mode, a message indicating the success of the operation
  /// is printed to the console.
  ///
  /// Throws:
  /// - [ArgumentError] if the username is empty.
  /// - [Exception] if the URL cannot be launched or if any other error occurs.
  ///
  /// Example usage:
  /// ```dart
  /// await openChat(username: 'example_username');
  /// ```
  ///
  /// Parameters:
  /// - `username` (required): The Telegram username to open a chat with.
  static Future<void> openChat({required String username}) async {
    if (username.trim().isEmpty) {
      throw ArgumentError('Username cannot be empty.');
    }
    final Uri chatUri = Uri.parse('tg://resolve?domain=$username');
    try {
      bool launched = await launchUrl(
        chatUri,
        mode: LaunchMode.externalNonBrowserApplication,
      );
      if (!launched) {
        throw Exception('Could not open chat for $username.');
      }
      if (kDebugMode) {
        print('Opened chat for $username using $chatUri');
      }
    } catch (e) {
      throw Exception('Failed to open chat: $e');
    }
  }

  /// Joins a Telegram channel or group using an invite link.
  ///
  /// This method takes an invite link as a required parameter and attempts to
  /// join the corresponding Telegram channel or group. It validates the invite
  /// link, parses it into a URI, and then launches the URI using an external
  /// non-browser application.
  ///
  /// If the invite link is empty or invalid, an appropriate error is thrown.
  /// If the attempt to join the channel fails, an exception is thrown.
  ///
  /// In debug mode, a message is printed to the console indicating the invite
  /// link being used to join the channel.
  ///
  /// Throws:
  /// - [ArgumentError] if the invite link is empty.
  /// - [FormatException] if the invite link is invalid.
  /// - [Exception] if the attempt to join the channel fails.
  ///
  /// Example usage:
  /// ```dart
  /// await joinChannel(inviteLink: 'https://t.me/joinchat/XXXXXXX');
  /// ```
  static Future<void> joinChannel({required String inviteLink}) async {
    if (inviteLink.trim().isEmpty) {
      throw ArgumentError('Invite link cannot be empty.');
    }
    Uri channelUri;
    try {
      channelUri = Uri.parse(inviteLink);
    } catch (e) {
      throw FormatException('Invalid invite link: $e');
    }
    try {
      bool launched = await launchUrl(
        channelUri,
        mode: LaunchMode.externalNonBrowserApplication,
      );
      if (!launched) {
        throw Exception('Could not join channel using $inviteLink.');
      }
      if (kDebugMode) {
        print('Joining channel using $inviteLink');
      }
    } catch (e) {
      throw Exception('Failed to join channel: $e');
    }
  }

  /// Shares a contact via Telegram.
  ///
  /// This method constructs a Telegram link to share a contact.
  /// The contact details include a phone number, first name, and optional last name.
  ///
  /// Throws:
  /// - [ArgumentError] if the phone number or first name is empty.
  /// - [Exception] if the URL cannot be launched.
  ///
  /// Example usage:
  /// ```dart
  /// await shareContact(phone: '+1234567890', firstName: 'John', lastName: 'Doe');
  /// ```
  static Future<void> shareContact({
    required String phone,
    required String firstName,
    String? lastName,
  }) async {
    if (phone.trim().isEmpty || firstName.trim().isEmpty) {
      throw ArgumentError('Phone number and first name cannot be empty.');
    }

    String contactUrl = 'https://t.me/share/url?'
        'url=tel:$phone&'
        'text=Contact: $firstName ${lastName ?? ""}';

    try {
      bool launched = await launchUrl(Uri.parse(contactUrl), mode: LaunchMode.externalNonBrowserApplication);
      if (!launched) {
        throw Exception('Could not share contact via Telegram.');
      }
      if (kDebugMode) {
        print('Sharing contact: $firstName ${lastName ?? ""} - $phone');
      }
    } catch (e) {
      throw Exception('Failed to share contact: $e');
    }
  }

  /// Opens a Telegram group by its username.
  ///
  /// Throws:
  /// - [ArgumentError] if the group username is empty.
  /// - [Exception] if the URL cannot be launched.
  ///
  /// Example usage:
  /// ```dart
  /// await openGroup(username: 'yourgroupname');
  /// ```
  static Future<void> openGroup({required String username}) async {
    if (username.trim().isEmpty) {
      throw ArgumentError('Group username cannot be empty.');
    }

    Uri groupUri = Uri.parse('https://t.me/$username');

    try {
      bool launched = await launchUrl(groupUri, mode: LaunchMode.externalNonBrowserApplication);
      if (!launched) {
        throw Exception('Could not open group: $username');
      }
      if (kDebugMode) {
        print('Opened Telegram group: $username');
      }
    } catch (e) {
      throw Exception('Failed to open group: $e');
    }
  }

  /// Sends a media file via Telegram.
  ///
  /// The [filePath] should be a valid URL pointing to the media file.
  ///
  /// Throws:
  /// - [ArgumentError] if the filePath is empty.
  /// - [Exception] if the URL cannot be launched.
  ///
  /// Example usage:
  /// ```dart
  /// await sendMedia(filePath: 'https://example.com/sample.jpg');
  /// ```
  static Future<void> sendMedia({required String filePath}) async {
    if (filePath.trim().isEmpty) {
      throw ArgumentError('File path cannot be empty.');
    }

    Uri mediaUri = Uri.parse('https://t.me/share/url?url=$filePath');

    try {
      bool launched = await launchUrl(mediaUri, mode: LaunchMode.externalNonBrowserApplication);
      if (!launched) {
        throw Exception('Could not send media file.');
      }
      if (kDebugMode) {
        print('Sending media: $filePath');
      }
    } catch (e) {
      throw Exception('Failed to send media: $e');
    }
  }

  /// Checks if a Telegram username exists.
  ///
  /// Throws:
  /// - [ArgumentError] if the username is empty.
  /// - [Exception] if the request fails.
  ///
  /// Example usage:
  /// ```dart
  /// bool exists = await checkUsernameAvailability(username: 'exampleUser');
  /// ```
  static Future<bool> checkUsernameAvailability({required String username}) async {
    if (username.trim().isEmpty) {
      throw ArgumentError('Username cannot be empty.');
    }

    Uri usernameUri = Uri.parse('https://t.me/$username');

    try {
      bool canOpen = await canLaunchUrl(usernameUri);
      return canOpen;
    } catch (e) {
      throw Exception('Failed to check username availability: $e');
    }
  }

  /// Opens a Telegram bot using its username.
  ///
  /// Throws:
  /// - [ArgumentError] if the bot username is empty.
  /// - [Exception] if the URL cannot be launched.
  ///
  /// Example usage:
  /// ```dart
  /// await openBot(username: 'MyTelegramBot');
  /// ```
  static Future<void> openBot({required String username}) async {
    if (username.trim().isEmpty) {
      throw ArgumentError('Bot username cannot be empty.');
    }

    Uri botUri = Uri.parse('https://t.me/$username');

    try {
      bool launched = await launchUrl(botUri, mode: LaunchMode.externalNonBrowserApplication);
      if (!launched) {
        throw Exception('Could not open bot: $username');
      }
      if (kDebugMode) {
        print('Opened Telegram bot: $username');
      }
    } catch (e) {
      throw Exception('Failed to open bot: $e');
    }
  }
}
