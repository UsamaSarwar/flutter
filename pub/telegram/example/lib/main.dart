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
  String? botToken;
  String? chatId;
  bool _isLoading = false;
  String _result = '';

  // Demo values
  final String demoUsername = 'UsamaSarwar';
  final String demoChannel = 'freelancers_inc';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Telegram API Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            title: Text(
              username == null || username == ''
                  ? 'Telegram API Demo'
                  : '@$username',
            ),
            bottom: const TabBar(
              tabs: [
                Tab(icon: Icon(Icons.send), text: 'URL Schemes'),
                Tab(icon: Icon(Icons.smart_toy), text: 'Bot API'),
                Tab(icon: Icon(Icons.extension), text: 'Utilities'),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              _buildUrlSchemeTab(),
              _buildBotApiTab(),
              _buildUtilitiesTab(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUrlSchemeTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _key,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'URL Scheme Methods',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Username',
                hintText: 'UsamaSarwar',
                border: OutlineInputBorder(),
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
                if (!RegExp(r'^([a-zA-Z0-9_-]*)$').hasMatch(value)) {
                  return 'Invalid username';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              minLines: 1,
              maxLines: 5,
              decoration: const InputDecoration(
                labelText: 'Message (Optional)',
                hintText: 'Hello from Telegram Flutter Package!',
                border: OutlineInputBorder(),
              ),
              onChanged: (String value) {
                message = value;
              },
            ),
            const SizedBox(height: 24),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ElevatedButton.icon(
                  onPressed: () => _performAction(() {
                    if (_key.currentState!.validate()) {
                      Telegram.send(username: username!, message: message);
                    }
                  }),
                  icon: const Icon(Icons.send),
                  label: const Text('Send Message'),
                ),
                ElevatedButton.icon(
                  onPressed: () => _performAction(() {
                    if (_key.currentState!.validate()) {
                      Telegram.copyLinkToClipboard(
                        username: username!,
                        message: message,
                      );
                      _showSnackBar('Link copied to clipboard!');
                    }
                  }),
                  icon: const Icon(Icons.content_copy),
                  label: const Text('Copy Link'),
                ),
                ElevatedButton.icon(
                  onPressed: () => _performAction(() async {
                    if (_key.currentState!.validate()) {
                      await Telegram.openChat(username: username!);
                    }
                  }),
                  icon: const Icon(Icons.chat),
                  label: const Text('Open Chat'),
                ),
                ElevatedButton.icon(
                  onPressed: () => _performAction(() async {
                    bool installed = await Telegram.isTelegramInstalled();
                    _showSnackBar('Telegram installed: $installed');
                  }),
                  icon: const Icon(Icons.info),
                  label: const Text('Check Installation'),
                ),
              ],
            ),
            const SizedBox(height: 24),
            const Text(
              'Demo Actions',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                OutlinedButton.icon(
                  onPressed: () => _performAction(() async {
                    await Telegram.openGroup(username: demoChannel);
                  }),
                  icon: const Icon(Icons.group),
                  label: Text('Join $demoChannel'),
                ),
                OutlinedButton.icon(
                  onPressed: () => _performAction(() async {
                    await Telegram.shareContact(
                      phone: '+923100007773',
                      firstName: 'Usama',
                      lastName: 'Sarwar',
                    );
                  }),
                  icon: const Icon(Icons.contact_phone),
                  label: const Text('Share Contact'),
                ),
                OutlinedButton.icon(
                  onPressed: () => _performAction(() async {
                    await Telegram.openBot(username: 'BotFather');
                  }),
                  icon: const Icon(Icons.smart_toy),
                  label: const Text('Open BotFather'),
                ),
                OutlinedButton.icon(
                  onPressed: () => _performAction(() async {
                    await Telegram.openStickerSet(
                      stickerSetName: 'AnimatedEmojies',
                    );
                  }),
                  icon: const Icon(Icons.emoji_emotions),
                  label: const Text('Sticker Set'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBotApiTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Bot API Methods',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          TextFormField(
            decoration: const InputDecoration(
              labelText: 'Bot Token',
              hintText: '123456789:ABCdefGHIjklMNOpqrsTUVwxyz',
              border: OutlineInputBorder(),
            ),
            onChanged: (String value) {
              botToken = value;
              if (value.isNotEmpty) {
                Telegram.setBotToken(value);
              }
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            decoration: const InputDecoration(
              labelText: 'Chat ID',
              hintText: '@username or numeric ID',
              border: OutlineInputBorder(),
            ),
            onChanged: (String value) {
              chatId = value;
            },
          ),
          const SizedBox(height: 24),
          if (_isLoading)
            const Center(child: CircularProgressIndicator())
          else
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ElevatedButton.icon(
                  onPressed: () => _performBotApiAction(() async {
                    final result = await Telegram.getMe();
                    return 'Bot Info: ${result['first_name']} (@${result['username']})';
                  }),
                  icon: const Icon(Icons.info),
                  label: const Text('Get Bot Info'),
                ),
                ElevatedButton.icon(
                  onPressed: () => _performBotApiAction(() async {
                    if (chatId?.isNotEmpty != true) {
                      throw Exception('Chat ID is required');
                    }
                    await Telegram.sendMessage(
                      chatId: chatId!,
                      text: 'Hello from Telegram Flutter Package! 🚀',
                    );
                    return 'Message sent successfully!';
                  }),
                  icon: const Icon(Icons.send),
                  label: const Text('Send Text'),
                ),
                ElevatedButton.icon(
                  onPressed: () => _performBotApiAction(() async {
                    if (chatId?.isNotEmpty != true) {
                      throw Exception('Chat ID is required');
                    }
                    await Telegram.sendPhoto(
                      chatId: chatId!,
                      photo: 'https://picsum.photos/400/300',
                      caption: 'Random photo from Telegram Package',
                    );
                    return 'Photo sent successfully!';
                  }),
                  icon: const Icon(Icons.photo),
                  label: const Text('Send Photo'),
                ),
                ElevatedButton.icon(
                  onPressed: () => _performBotApiAction(() async {
                    if (chatId?.isNotEmpty != true) {
                      throw Exception('Chat ID is required');
                    }
                    await Telegram.sendLocation(
                      chatId: chatId!,
                      latitude: 37.7749,
                      longitude: -122.4194,
                    );
                    return 'Location sent successfully!';
                  }),
                  icon: const Icon(Icons.location_on),
                  label: const Text('Send Location'),
                ),
                ElevatedButton.icon(
                  onPressed: () => _performBotApiAction(() async {
                    if (chatId?.isNotEmpty != true) {
                      throw Exception('Chat ID is required');
                    }
                    final chat = await Telegram.getChat(chatId: chatId!);
                    return 'Chat: ${chat['title'] ?? chat['first_name'] ?? 'Unknown'}';
                  }),
                  icon: const Icon(Icons.chat_bubble),
                  label: const Text('Get Chat Info'),
                ),
                ElevatedButton.icon(
                  onPressed: () => _performBotApiAction(() async {
                    await Telegram.setMyCommands(
                      commands: [
                        {'command': 'start', 'description': 'Start the bot'},
                        {'command': 'help', 'description': 'Show help message'},
                        {'command': 'about', 'description': 'About this bot'},
                      ],
                    );
                    return 'Bot commands set successfully!';
                  }),
                  icon: const Icon(Icons.list),
                  label: const Text('Set Commands'),
                ),
              ],
            ),
          const SizedBox(height: 24),
          if (_result.isNotEmpty)
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Result:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(_result),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildUtilitiesTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Utility Methods',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Link Generation',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton.icon(
                    onPressed: () {
                      final link = Telegram.getLink(
                        username: demoUsername,
                        message: 'Hello from Flutter!',
                      );
                      _showDialog('Generated Link', link);
                    },
                    icon: const Icon(Icons.link),
                    label: const Text('Generate Message Link'),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton.icon(
                    onPressed: () {
                      final shareUrl = Telegram.generateShareUrl(
                        text: 'Check out this amazing Telegram package!',
                        url: 'https://pub.dev/packages/telegram',
                      );
                      _showDialog('Share URL', shareUrl);
                    },
                    icon: const Icon(Icons.share),
                    label: const Text('Generate Share URL'),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Advanced Features',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      ElevatedButton.icon(
                        onPressed: () => _performAction(() async {
                          await Telegram.openWebApp(
                            botUsername: 'gamebot',
                            webAppUrl: 'https://example.com/game',
                            startParam: 'demo',
                          );
                        }),
                        icon: const Icon(Icons.web),
                        label: const Text('Open Web App'),
                      ),
                      ElevatedButton.icon(
                        onPressed: () => _performAction(() async {
                          await Telegram.openTheme(themeName: 'dark');
                        }),
                        icon: const Icon(Icons.palette),
                        label: const Text('Open Theme'),
                      ),
                      ElevatedButton.icon(
                        onPressed: () => _performAction(() async {
                          bool available =
                              await Telegram.checkUsernameAvailability(
                                username: demoUsername,
                              );
                          _showSnackBar('Username available: $available');
                        }),
                        icon: const Icon(Icons.search),
                        label: const Text('Check Username'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Demo Information',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 12),
                  Text('Demo Username: @$demoUsername'),
                  Text('Demo Channel: t.me/$demoChannel'),
                  const SizedBox(height: 8),
                  const Text(
                    'To test Bot API features, create a bot with @BotFather and enter the token in the Bot API tab.',
                    style: TextStyle(fontStyle: FontStyle.italic),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Package Features',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 12),
                  const Text('✅ URL Scheme Methods'),
                  const Text('✅ Bot API Integration'),
                  const Text('✅ Media Sending'),
                  const Text('✅ Location Sharing'),
                  const Text('✅ Chat Management'),
                  const Text('✅ Web App Support'),
                  const Text('✅ Sticker Sets & Themes'),
                  const Text('✅ Link Generation'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _performAction(Function action) async {
    try {
      setState(() => _isLoading = true);
      await action();
      setState(() => _result = 'Action completed successfully!');
    } catch (e) {
      _showSnackBar('Error: $e');
      setState(() => _result = 'Error: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _performBotApiAction(Future<String> Function() action) async {
    try {
      setState(() => _isLoading = true);
      final result = await action();
      setState(() => _result = result);
    } catch (e) {
      _showSnackBar('Error: $e');
      setState(() => _result = 'Error: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  void _showDialog(String title, String content) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: SelectableText(content),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}
