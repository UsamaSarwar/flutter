#!/bin/sh
##? Building Flutter apk for release and exporting the apk to the export/
flutter build apk --release
rm export/app.apk
cp build/app/outputs/flutter-apk/app-release.apk export/app.apk

##? Building Flutter appbundle for release and exporting the appbundle to the export/
flutter build appbundle --release
mkdir export
rm export/app.aab
cp build/app/outputs/bundle/release/app-release.aab export/app.aab

##? Building Flutter web for release and exporting the web to the build/web/
# flutter build web --release

##? Building Flutter ios for release and exporting the ios to the export/
# flutter build ios --release
# rm export/app.ipa
# cp build/ios/iphoneos/Runner.app/App.framework/App export/app.ipa

# flutter build macos --release
# flutter build ios --release
# flutter build web --release