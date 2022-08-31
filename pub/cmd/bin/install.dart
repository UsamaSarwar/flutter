// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:io';

import 'scripts.dart';

/// Integrating Scripts into the code
void main() async {
  /// Repository data
  String repoData;

  /// HTTP client
  HttpClient client = HttpClient();

  /// Try to get the repository data
  try {
    /// Getting all the scripts
    for (String script in scripts) {
      /// Get the script data
      HttpClientRequest request = await client.getUrl(Uri.parse(
          'https://raw.githubusercontent.com/UsamaSarwar/cmd/main/flutter/cmd/$script'));

      /// Get the response
      HttpClientResponse response = await request.close();
      repoData = await response.transform(utf8.decoder).join();
      print(
          '🔹 \x1B[36m$script has been installed at \x1B[37m${Directory.current.path}\\\x1B[36mcmd\\$script\x1B[0m');

      /// Creating the script file
      File('cmd/$script').createSync(recursive: true);

      /// Write the script data to the file
      File('cmd/$script').writeAsStringSync(
        repoData,
        flush: true,
      );
    }
    print('''\n
📁 \x1B[33mcmd has been installed at \x1B[37m${Directory.current.path}\\\x1B[33mcmd\x1B[0m\n\n
✅ \x1B[32mcmd installed successfully!\x1B[0m
''');
  } catch (exception) {
    print('⚠️  \x1B[31m${exception.toString()}\x1B[0m');
  } finally {
    /// Close the HTTP client
    client.close();
  }
}
