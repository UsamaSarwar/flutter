// ignore_for_file: avoid_print

library dev_tools;

import 'dart:io';

export 'cmd.dart';

/// Run "flutter pub run cmd:install" to install cmd scripts...
class CMD {
  /// Run "flutter pub run cmd:install" to install cmd scripts...
  CMD() {
    print(
        '''\x1B[33mRun "flutter pub run cmd:install" to install Flutter Commands.
📁 cmd will be installed at \x1B[37m${Directory.current.path}\\cmd\\\x1B[0m
''');
  }
}
