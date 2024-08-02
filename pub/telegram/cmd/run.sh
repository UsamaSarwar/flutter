#!/bin/sh

##? Running the Flutter application
# flutter run -v

##? Running the Flutter application in release mode
# flutter run --release

##? Running the Flutter application in profile mode
# flutter run --profile

##? Running the Flutter application in debug mode
# flutter run --debug

##? Running the Flutter application in a specific flavor
# flutter run --flavor dev
# flutter run --flavor prod
# flutter run --flavor staging

##? Running the Flutter application on a specific device
# flutter run -d emulator-5554
# flutter run -d emulator-5556
# flutter run -d physical-device-id

##? Running Flutter web on http://localhost:8080/
# flutter run -d chrome --web-devtools-connected
# flutter run -d chrome --web-devtools-debug-proxy-enabled
# flutter run -d chrome --web-devtools-remote-debugging-enabled
# flutter run -d chrome --web-devtools-remote-debugging-url=ws://localhost:8080/devtools/page/0
# flutter run -d chrome --web-devtools-remote-debugging-url=ws://localhost:8080/devtools/page/0 --web-devtools-remote-debugging-port=8080
# flutter run -d chrome --web-devtools-remote-debugging-url=ws://localhost:8080/devtools/page/0 --web-devtools-remote-debugging-port=8080 --web-devtools-remote-debugging-allowed-ports=8080

##? Running Flutter with different build modes
# flutter run --debug
# flutter run --profile
# flutter run --release

##? Running Flutter with different target platforms
# flutter run -d android
# flutter run -d ios
# flutter run -d web
# flutter run -d windows
# flutter run -d macos
# flutter run -d linux

##? Running Flutter with different architectures
# flutter run --arch x86
# flutter run --arch x64
# flutter run --arch arm
# flutter run --arch arm64

##? Running Flutter with different locales
# flutter run --locale en
# flutter run --locale fr
# flutter run --locale es

##? Running Flutter with different orientations
# flutter run --orientation portrait
# flutter run --orientation landscape

##? Running Flutter with different screen sizes
# flutter run --screen-size 1080x1920
# flutter run --screen-size 720x1280

##? Running Flutter with different pixel ratios
# flutter run --pixel-ratio 2.0
# flutter run --pixel-ratio 3.0

##? Running Flutter with different text scales
# flutter run --text-scale 1.5
# flutter run --text-scale 2.0

##? Running Flutter with different accessibility features
# flutter run --enable-software-rendering
# flutter run --enable-dart-asserts
# flutter run --enable-experimentnal-html-entrypoints
# flutter run --high-contrast
# flutter run --screen-reader

##? Running Flutter with different cache options
# flutter run --cache-sksl
# flutter run --no-cache-sksl
# flutter run --cache-dart
# flutter run --no-cache-dart

##? Running Flutter with different observatory options
# flutter run --observatory-port 8080
# flutter run --no-observatory

##? Running Flutter with different tracing options
# flutter run --trace-startup
# flutter run --no-trace-startup