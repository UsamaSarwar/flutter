import 'package:flutter/material.dart';
import 'package:telegram/telegram.dart';

void main() {
  runApp(const TelegramApp());
}

class TelegramApp extends StatefulWidget {
  const TelegramApp({super.key});

  @override
  State<TelegramApp> createState() => _TelegramAppState();
}

class _TelegramAppState extends State<TelegramApp> {
  final _key = GlobalKey<FormState>();
  String? username;
  String? message;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Telegram',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          centerTitle: false,
          title: Text(
              username == null || username == '' ? 'Telegram' : '@$username'),
          actions: [
            // Copy to clipboard
            IconButton(
              tooltip: 'Copy to clipboard',
              onPressed: () {
                if (_key.currentState!.validate()) {
                  Telegram.copyLinkToClipboard(
                      username: username ?? '', message: message);
                }
              },
              icon: const Icon(Icons.content_copy),
            ),
            // Send via telegram
            IconButton(
              tooltip: 'Send',
              onPressed: () {
                if (_key.currentState!.validate()) {
                  if (message == null) {
                    Telegram.send(username: username!);
                  } else {
                    Telegram.send(
                      username: username!,
                      message: message,
                    );
                  }
                }
              },
              icon: const Icon(Icons.send),
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Form(
                  key: _key,
                  child: Column(
                    children: [
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Username',
                        ),
                        onChanged: (String value) {
                          setState(() {
                            username = value;
                          });
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Username is required';
                          }
                          if (value.length < 5) {
                            return 'Username must be at least 5 characters long';
                          }
                          // Validating username with regex
                          if (!RegExp(r'^([a-zA-Z0-9_-]*)$').hasMatch(value)) {
                            return 'Invalid username';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        minLines: 1,
                        maxLines: 20,
                        textAlign: TextAlign.justify,
                        decoration: const InputDecoration(
                          labelText: 'Message (Optional)',
                          labelStyle:
                              TextStyle(overflow: TextOverflow.ellipsis),
                        ),
                        onChanged: (String value) {
                          message = value;
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
