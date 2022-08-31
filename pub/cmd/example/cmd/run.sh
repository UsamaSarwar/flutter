#!/bin/sh

##? Running the Flutter application
flutter run -v

##? Running Flutter web on http://localhost:8080/
# flutter run -d chrome --web-devtools-connected
# flutter run -d chrome --web-devtools-debug-proxy-enabled
# flutter run -d chrome --web-devtools-remote-debugging-enabled
# flutter run -d chrome --web-devtools-remote-debugging-url=ws://localhost:8080/devtools/page/0
# flutter run -d chrome --web-devtools-remote-debugging-url=ws://localhost:8080/devtools/page/0 --web-devtools-remote-debugging-port=8080
# flutter run -d chrome --web-devtools-remote-debugging-url=ws://localhost:8080/devtools/page/0 --web-devtools-remote-debugging-port=8080 --web-devtools-remote-debugging-allowed-ports=8080