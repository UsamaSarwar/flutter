#!/bin/sh

##? Inspecting the current state of the Flutter environment
flutter doctor -v

##? Inspecting the current state of the Flutter environment with verbose mode
# flutter doctor -v --verbose

##? Checking for the latest version of Flutter
# flutter upgrade

##? Checking for the latest version of Flutter with force update
# flutter upgrade --force

##? Checking for the latest version of Flutter with a specific channel
# flutter channel stable
# flutter channel master
# flutter channel beta
# flutter channel dev
# flutter upgrade

##? Checking for the latest version of Flutter with a specific version
# flutter version 3.4.4
# flutter version 2.10.0
# flutter upgrade

##? Checking for the latest version of Flutter with a specific version and channel
# flutter channel stable
# flutter version 3.4.4
# flutter upgrade

##? Listing all available Flutter channels
# flutter channel

##? Switching to a specific Flutter channel
# flutter channel stable
# flutter channel master
# flutter channel beta
# flutter channel dev

##? Listing all available Flutter versions
# flutter version

##? Switching to a specific Flutter version
# flutter version 3.4.4
# flutter version 2.10.0

##? Checking for the Flutter configuration
# flutter config

##? Setting a Flutter configuration (e.g. enable or disable analytics, enable or disable telemetry)
# flutter config --enable-analytics
# flutter config --disable-telemetry

##? Listing all available Flutter features (e.g. analytics, telemetry)
# flutter config --list-features